pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
}
contract UniswapSpendLimit{
    address constant USDCContract = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address constant UNIContract = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984;
    address constant TimelockContract = 0x1a9C8182C09F50C8318d769245beA52c32BE35BC;
    address public beneficiary;
    
    uint public UNISpendLimit; 
    uint public USDCSpendLimit;
    
    modifier onlyUniGov{
        require (msg.sender == TimelockContract);
        _;
    }
    
    modifier onlyBeneficiary{
        require (msg.sender == beneficiary);
        _;
    }
    
    constructor(){
        beneficiary = 0x1C95930Dfc1139381265ce45B5f480F1EFae09A1;
    }
    
    function setBeneficiary(address newBeneficiary) public onlyBeneficiary{
        beneficiary = newBeneficiary;
    }
    
    function withdrawTokens(address token, uint amount) public onlyBeneficiary{
        if (token == USDCContract){
            USDCSpendLimit -= amount;
        }
        if (token == UNIContract){
            UNISpendLimit -= amount;
        }
        IERC20(token).transfer(beneficiary, amount);
    }
    
    function recallFunds(address token, uint amount) public onlyUniGov{
        IERC20(token).transfer(TimelockContract, amount);
    }
    
    function increaseSpendLimit(uint uniLimit, uint usdcLimit) public onlyUniGov{
        UNISpendLimit += uniLimit;
        USDCSpendLimit += usdcLimit;
    }
    function setSpendLimit(uint uniLimit, uint usdcLimit) public onlyUniGov{
        UNISpendLimit = uniLimit;
        USDCSpendLimit = usdcLimit;
    }
}
