// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITesouroDireto {


    function getPriceAmount(uint256 _tokenId) external view returns(uint256 _price, uint256 _amount);

    function retriveFullInvestment(uint256 _tokenId, uint256 _amount) external returns(bool);
}