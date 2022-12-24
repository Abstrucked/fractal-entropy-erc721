// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./interfaces/IFractalEntropy.sol";
/**
 * @dev TODO 
 * - Add metadata variables
 * - Implement the rest of contract
 */

contract FractalEntropy is IFractalEntropy, ERC721, ERC721URIStorage, Ownable {
    
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    struct Fractal {
        uint256 xmin;
        uint256 ymin;
        uint8 pixels;
        uint32 scale;
        bytes palette;
    }

    mapping(uint256 => Fractal) private _fractals;

    bool private _MINT_ENABLED = false;
    string public _baseTokenUri;
    uint256 MAX_SUPPLY = 10;
    
    string private base = "https://";
    function saleOpen() view external returns (bool){
        return _MINT_ENABLED;
    }

    function toggleSale() external onlyOwner {
        _MINT_ENABLED = !_MINT_ENABLED;
        emit SaleStateChange(_MINT_ENABLED);
    }

    function changeTokenBaseUri(string memory _newTokenBaseUri) external onlyOwner {

    }

    constructor() ERC721("FractalEntropy", "FRCTL") { }
    
    // function _baseURI() internal pure override returns (string memory) {
    //     return "https://api.fractalentropy.xyz/";
    // }


    function safeMint(address to, string memory _tokenURI, bytes memory data) public returns (uint256) {
        if(!_MINT_ENABLED) {
            revert SaleIsClosed();
        }
        if(_tokenIdCounter.current() >= MAX_SUPPLY) {
            revert MaxSupplyReached();
        }
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        
        (uint256 x, uint256 y, uint8 p, uint32 s,bytes memory palette) = abi.decode(data, (uint256, uint256, uint8, uint32, bytes));
        _fractals[tokenId] = Fractal(x,y,p,s,palette);
        
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, _tokenURI);
        return tokenId;
    }    

    function getFractalData(uint256 id) public view returns ( Fractal memory) {
        Fractal storage fractal = _fractals[id];
        return fractal;
    }

    function changePalette(uint256 id, bytes memory data) public{
        if(ownerOf(id)!= msg.sender) {
            revert("Only the token owner can change palette");
        }
        Fractal storage fractal = _fractals[id];
        fractal.palette = data;
    }

    function _burn(uint256 tokenId) internal onlyOwner override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

}