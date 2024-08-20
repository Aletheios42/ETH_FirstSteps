//SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {DeployDsc} from "script/DeployDsc.s.sol";
import {DSCEngine} from "src/DSCEngine.sol";
import {DecentralizedStableCoin} from "src/DecentralizedStableCoin.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract InvariantsTest is Test {
    DeployDsc deployer;
    DSCEngine engine;
    DecentralizedStableCoin dsc;
    HelperConfig config;

    address weth;
    address wbtc;

    function setUp() external {
        deployer = new DeployDsc();
        console.log("Deploying contracts...");

        (dsc, engine, config) = deployer.run();
        console.log("Contracts deployed. Checking addresses...");

        console.log("DecentralizedStableCoin address: ", address(dsc));
        console.log("DSCEngine address: ", address(engine));
        console.log("HelperConfig address: ", address(config));

        require(address(dsc) != address(0), "dsc is zero address");
        require(address(engine) != address(0), "engine is zero address");
        require(address(config) != address(0), "config is zero address");

        (, , weth, wbtc, ) = config.activeNetworkConfig();
        console.log("WETH address: ", weth);
        console.log("WBTC address: ", wbtc);

        require(weth != address(0), "weth is zero address");
        require(wbtc != address(0), "wbtc is zero address");

        targetContract(address(engine));
        console.log("Target contract set. setUp completed.");
    }

    function invariant_protocolMustHaveMoreValueThanTotalSupply() public view {
        console.log("Testing if test inicialize");
        uint256 totalSupply = dsc.totalSupply();
        console.log("totalSupply: ", totalSupply);
        uint256 totalWethDeposited = IERC20(weth).balanceOf(address(engine));
        uint256 totalWbtcDeposited = IERC20(wbtc).balanceOf(address(engine));

        uint256 wethValue = engine.getUsdValue(weth, totalWethDeposited);
        uint256 wbtcValue = engine.getUsdValue(wbtc, totalWbtcDeposited);

        console.log("weth value: ", wethValue);
        console.log("wbtc value: ", wbtcValue);
        console.log("total supply: ", totalSupply);
        assert(wethValue + wbtcValue > totalSupply);
    }
}
