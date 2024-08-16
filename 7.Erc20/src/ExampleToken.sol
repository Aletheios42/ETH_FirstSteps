// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ExampleToken {
    string tokenName = "Example";
    mapping(address => uint256) private s_balance;

    function name() public view returns (string memory) {
        return tokenName;
    }

    function totalsupply() public pure returns (uint256) {
        return 100 ether; //100 * 1000000000000000000
    }

    function deciamls() public pure returns (uint256) {
        return 18;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return s_balance[_owner];
    }

    function transfer(address _to, uint256 _amount) public {
        uint256 previousBalances = balanceOf(msg.sender) + balanceOf(_to);
        s_balance[msg.sender] -= _amount;
        s_balance[_to] += _amount;
        require(balanceOf(msg.sender) + balanceOf(_to) == previousBalances);
    }
}
