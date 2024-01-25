// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IFractalEntropy is IERC721 {
    event SaleStateChange(bool state);

    struct Fractal {
        uint256 xmin;
        uint256 ymin;
        uint8 pixels;
        uint32 scale;
        uint256 palette;
    }

    function isSaleOpen() external returns (bool);
    function toggleSale() external;

    error MaxSupplyReached();
    error SaleIsClosed();
    
}
