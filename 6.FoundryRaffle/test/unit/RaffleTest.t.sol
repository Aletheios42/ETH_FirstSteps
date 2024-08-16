// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {Raffle} from "../../src/Raffle.sol";
import {HelperConfig, CodeConstants} from "../../script/HelperConfig.s.sol";
import {Test, console2} from "forge-std/Test.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {Vm} from "forge-std/Vm.sol";

contract RaffleTest is Test, CodeConstants {
    Raffle public raffle;
    HelperConfig public helperConfig;

    address public PLAYER = makeAddr("player");
    uint256 public constant STARTING_PLAYER_BALANCE = 10 ether;

    uint256 subscriptionId;
    bytes32 gasLane;
    uint256 automationUpdateInterval;
    uint256 entranceFee;
    uint32 callbackGasLimit;
    address vrfCoordinatorV2_5;

    /* Events */
    event RequestedRaffleWinner(uint256 indexed requestId);
    event RaffleEnter(address indexed player);
    event WinnerPicked(address indexed player);

    function setUp() external {
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.deployContract();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        subscriptionId = config.subscriptionId;
        gasLane = config.gasLane;
        automationUpdateInterval = config.automationUpdateInterval;
        entranceFee = config.raffleEntranceFee;
        callbackGasLimit = config.callbackGasLimit;
        vrfCoordinatorV2_5 = config.vrfCoordinatorV2_5;

        vm.deal(PLAYER, STARTING_PLAYER_BALANCE);
    }

    /**************************************************************************/
    /*                               Modifiers                                */
    /**************************************************************************/

    modifier raffleEntered() {
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
        vm.warp(block.timestamp + automationUpdateInterval + 1);
        vm.roll(block.number + 1);
        _;
    }

    modifier skipFork() {
        if (block.chainid != LOCAL_CHAIN_ID) {
            return;
        }
        _;
    }

    /**************************************************************************/
    /*                             Basic Testing                              */
    /**************************************************************************/

    function testRaffleInitializesInOpenState() public view {
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }

    function testRaffleRevertWhenYouDontPayEnough() public {
        //arange
        vm.prank(PLAYER);
        //act //asset
        vm.expectRevert(Raffle.Raffle__SendMoreToEnterRaffle.selector);
        raffle.enterRaffle();
    }

    function testRaffleRecordsPlayersWhenTheyEnter() public {
        //arrange
        vm.prank(PLAYER);
        //act
        raffle.enterRaffle{value: entranceFee}();
        //arrange
        address playerRecorded = raffle.getPlayer(0);
        assert(playerRecorded == PLAYER);
    }

    function testEnteringRaffleEmitsEvent() public {
        //Arrange
        vm.prank(PLAYER);
        //act
        vm.expectEmit(true, false, false, false, address(raffle));
        emit RaffleEnter(address(PLAYER));
        //assert
        raffle.enterRaffle{value: entranceFee}();
    }

    function testDontAllowPlayersToEnterWhileRaffleIsCalculating()
        public
        raffleEntered
    {
        //Arrange
        raffle.performUpkeep("");
        //act   //assert
        vm.expectRevert(Raffle.Raffle__RaffleNotOpen.selector);
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
    }

    /**************************************************************************/
    /*                              Check UpKeep                              */
    /**************************************************************************/

    function testUpCheckReturnsFalseIfItHasNoBalance() public {
        //Arrange
        vm.warp(block.timestamp + automationUpdateInterval + 1);
        vm.roll(block.number + 1);
        //act
        (bool upKeepNeeded, ) = raffle.checkUpkeep("");
        //assert
        assert(!upKeepNeeded);
    }

    function testCheckUpkeepReturnsFalseIfRaffleIsOpened()
        public
        raffleEntered
    {
        //Arrage
        raffle.performUpkeep("");
        //Act
        (bool upkeepNeeded, ) = raffle.checkUpkeep("");
        ////Assert
        assert(!upkeepNeeded);
    }

    /**************************************************************************/
    /*                             PerformUpkeep                              */
    /**************************************************************************/

    function testperformUpkeepCanOnlyRunIfCheckUpdateIsTrue()
        public
        raffleEntered
    {
        //Arrange
        //Act  //Assert
        raffle.performUpkeep("");
    }

    function testPerformUpkeepRevertIfCheckUpkeepIsFalse() public {
        //Arrange
        uint256 currentBalance = 0;
        uint256 numberOfPlayers = 0;
        Raffle.RaffleState rState = raffle.getRaffleState();

        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
        currentBalance = entranceFee + currentBalance;
        numberOfPlayers = 1;
        //Act //Asset
        vm.expectRevert(
            abi.encodeWithSelector(
                Raffle.Raffle__UpkeepNotNeeded.selector,
                currentBalance,
                numberOfPlayers,
                rState
            )
        );
        raffle.performUpkeep("");
    }

    function testPerformUpkeepUpdateRaffleStateAndEmitsRequestId()
        public
        raffleEntered
    {
        //Arrange el modifier
        //Act
        vm.recordLogs();
        raffle.performUpkeep("");
        Vm.Log[] memory entries = vm.getRecordedLogs();
        bytes32 requestId = entries[0].topics[1];
        //Assert
        Raffle.RaffleState raffleState = raffle.getRaffleState();
        assert(uint256(requestId) > 0);
        assert(uint256(raffleState) == 1); // 1 == Calculatin
    }

    /**************************************************************************/
    /*                          Fullfil Random Words                          */
    /**************************************************************************/
    //
    function testFullfilRandomWordsCanOnlyBeCalledAfterPerformUpkeep(
        uint256 randomRequestId
    ) public raffleEntered skipFork {
        //Arange
        vm.expectRevert(VRFCoordinatorV2_5Mock.InvalidRequest.selector);
        VRFCoordinatorV2_5Mock(vrfCoordinatorV2_5).fulfillRandomWords(
            randomRequestId,
            address(raffle)
        );
    }

    function testFulfillrandomWordsPicksWinnersResetsAndPaysMoney()
        public
        raffleEntered
        skipFork
    {
        uint256 additionalEntrants = 3;
        uint256 startingIndex = 1;
        address expectedWinner = address(1);

        for (
            uint256 i = startingIndex;
            i < startingIndex + additionalEntrants;
            i++
        ) {
            address newPlayer = address(uint160(i));
            hoax(newPlayer, 1 ether);
            raffle.enterRaffle{value: entranceFee}();
        }
        uint256 startingTimeStamp = raffle.getLastTimeStamp();
        uint256 winnerStartingBalance = expectedWinner.balance;

        //Act
        vm.recordLogs();
        raffle.performUpkeep("");
        Vm.Log[] memory entries = vm.getRecordedLogs();
        bytes32 requestId = entries[1].topics[1];
        VRFCoordinatorV2_5Mock(vrfCoordinatorV2_5).fulfillRandomWords(
            uint256(requestId),
            address(raffle)
        );

        //Assert
        address recentWinner = raffle.getRecentWinner();
        Raffle.RaffleState raffleState = raffle.getRaffleState();
        uint256 winnerBalance = recentWinner.balance;
        uint256 endingTimeStamp = raffle.getLastTimeStamp();
        uint prize = entranceFee * (additionalEntrants + 1);

        assert(expectedWinner == recentWinner);
        assert(uint256(raffleState) == 0);
        assert(winnerBalance == winnerStartingBalance + prize);
        assert(endingTimeStamp > startingTimeStamp);
    }
}
