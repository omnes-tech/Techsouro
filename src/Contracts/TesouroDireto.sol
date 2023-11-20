// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@erc721a/ERC721A.sol";

//_packedOwnershipOf(tokenId); == previous ownership
contract tesouroDireto is ERC721A{
    //-----------------------------------------------------------------------------------------------
    //
    //                                      ERRORS
    //
    //-----------------------------------------------------------------------------------------------

    error NotKYCed();
    error NotEmitter();
    error NotValidTreasuryType();

    //-----------------------------------------------------------------------------------------------
    //
    //                                      EVENTS
    //
    //-----------------------------------------------------------------------------------------------

    //-----------------------------------------------------------------------------------------------
    //
    //                                      VARIABLES
    //
    //-----------------------------------------------------------------------------------------------

    enum treasuryType{
        LTN, //PREFIXADO,O investidor conhece o retorno exato ao final da aplicação
        NTN_F, //descrito acima e que são pagos juros semestrais ao investidor 
        LFT, //POS-FIXADO que acompanha a variação da taxa Selic diariamente
        NTN_B_MAIN, //MISTO, combinando rentabilidade prefixada com o IPCA,
        NTN_B ////descrito acima e que são pagos juros semestrais ao investidor 
    }

    struct treasuryData{
        treasuryType _type;
        uint24 _apy;
        uint256 _minInvestment;
        uint256 _validThru;
        uint256 _avlbTokens;
    }

    address public emitter; //Union wallet
    mapping (address => bool) public buyer; //KYC Users
    mapping (uint256 => uint256) public certificateToToken; //ERC721A to ERC1155

    //-----------------------------------------------------------------------------------------------
    //
    //                                      CONSTRUCTOR
    //
    //-----------------------------------------------------------------------------------------------
    constructor(string memory _name, string memory _symbol) ERC721A(_name,_symbol){
        emitter == msg.sender;
    }


    //-----------------------------------------------------------------------------------------------
    //
    //                                      PUBLIC FUNCTIONS
    //
    //-----------------------------------------------------------------------------------------------

    function KYC(address _KYCed) public onlyEmitter{
        buyer[_KYCed] = true;
    }

    function emitTreasury(address _buyer, treasuryData memory _data) public KYCcheck(_buyer) onlyEmitter{
        if (_data._type == treasuryType.LTN){
            ERC721A._mint(_buyer, 1);
            ERC721A._setExtraDataAt(ERC721A._nextTokenId(), _data._apy);
        }else if(_data._type == treasuryType.NTN_F){
            ERC721A._mint(_buyer, 1);
            ERC721A._setExtraDataAt(ERC721A._nextTokenId(), _data._apy);
        }else if(_data._type == treasuryType.LFT){
            ERC721A._mint(_buyer, 1);
            ERC721A._setExtraDataAt(ERC721A._nextTokenId(), _data._apy);
        }else if(_data._type == treasuryType.NTN_B_MAIN){
            ERC721A._mint(_buyer, 1);
            ERC721A._setExtraDataAt(ERC721A._nextTokenId(), _data._apy);
        }else if(_data._type == treasuryType.NTN_B){
            ERC721A._mint(_buyer, 1);
            ERC721A._setExtraDataAt(ERC721A._nextTokenId(), _data._apy);
        }else{
            revert NotValidTreasuryType();
        }
    }

    //-----------------------------------------------------------------------------------------------
    //
    //                                      INHERIT FROM ERC721A
    //
    //-----------------------------------------------------------------------------------------------

    function _extraData(
        address from,
        address to,
        uint24 previousExtraData
    ) internal view override returns (uint24) {
        return previousExtraData;
    }


    //-----------------------------------------------------------------------------------------------
    //
    //                                      MODIFIERS
    //
    //-----------------------------------------------------------------------------------------------


    modifier onlyEmitter() {
        if(msg.sender != emitter) revert NotEmitter();
        _;
    }

    modifier KYCed() {
        if(!buyer[msg.sender]) revert NotKYCed();
        _;
    }
    modifier KYCcheck(address _check) {
        if(!buyer[_check]) revert NotKYCed();
        _;
    }
    
}