pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IFractalEntropy is IERC721 {
    event SaleStateChange(bool state);

    function saleOpen() external returns (bool);
    function toggleSale() external;

    error MaxSupplyReached();
    error SaleIsClosed();
    
}
