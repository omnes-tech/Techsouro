// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

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
    error notOpenMarket(address _sender);

    //-----------------------------------------------------------------------------------------------
    //
    //                                      EVENTS
    //
    //-----------------------------------------------------------------------------------------------

    event treasuryCreated(uint256 indexed _totalValue, uint256 indexed _apy, uint256 indexed _duration, treasuryType);
    event notOpenMarketContract(address indexed _sender);

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
    address public openMarket;
    mapping (uint256 => treasuryData) public tokenInfo; //ERC721A to ERC1155

    //-----------------------------------------------------------------------------------------------
    //
    //                                      CONSTRUCTOR
    //
    //-----------------------------------------------------------------------------------------------
    constructor(string memory _name, string memory _symbol, address _openMarket) ERC721A(_name,_symbol){
        emitter = msg.sender;
        openMarket = _openMarket;
    }


    //-----------------------------------------------------------------------------------------------
    //
    //                                      PUBLIC FUNCTIONS
    //
    //-----------------------------------------------------------------------------------------------

    function emitTreasury(treasuryData memory _data) public onlyEmitter{
        if (_data._type == treasuryType.LTN){
            ERC721A._mint(openMarket, 1);
            ERC721A._setExtraDataAt(ERC721A._nextTokenId(), _data._apy);
        }else if(_data._type == treasuryType.NTN_F){
            ERC721A._mint(openMarket, 1);
            ERC721A._setExtraDataAt(ERC721A._nextTokenId(), _data._apy);
        }else if(_data._type == treasuryType.LFT){
            ERC721A._mint(openMarket, 1);
            ERC721A._setExtraDataAt(ERC721A._nextTokenId(), _data._apy);
        }else if(_data._type == treasuryType.NTN_B_MAIN){
            ERC721A._mint(openMarket, 1);
            ERC721A._setExtraDataAt(ERC721A._nextTokenId(), _data._apy);
        }else if(_data._type == treasuryType.NTN_B){
            ERC721A._mint(openMarket, 1);
            ERC721A._setExtraDataAt(ERC721A._nextTokenId(), _data._apy);
        }else{
            revert NotValidTreasuryType();
        }
        tokenInfo[_nextTokenId() - 1] = _data;
        emit treasuryCreated(_data._avlbTokens*_data._minInvestment, _data._apy, _data._validThru, _data._type);
    }

    function retriveInvestment(uint256 _tokenId, uint256 _amount) external returns(bool){
        if(msg.sender != openMarket) revert notOpenMarket(msg.sender);


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
    //                                      GETTER FUNCTIONS
    //
    //-----------------------------------------------------------------------------------------------

    function getPriceAmount(uint256 _tokenId) external view returns(uint256 _price, uint256 _amount){
        _price = tokenInfo[_tokenId]._minInvestment;
        _amount = tokenInfo[_tokenId]._avlbTokens;
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

    
    
}