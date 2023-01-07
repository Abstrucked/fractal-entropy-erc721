// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;
import "@openzeppelin/contracts/utils/Strings.sol";
import "solidity-bytes-utils/contracts/BytesLib.sol";
import "../libraries/Utils.sol";
import "hardhat/console.sol";

contract PaletteRenderer {
    uint256 constant SIZE = 512;

    struct Color {
        uint8 r;
        uint8 g;
        uint8 b;
    }

    function generateColor(bytes32 seed) 
        private
        pure
        returns (uint256)
    {
        return uint256(keccak256(abi.encodePacked(seed))) % 524288;
    }

    function getColorComponentRed(uint256 value)
        internal
        pure
        returns (uint8)
    {
        return uint8((value >> 8) & 0xff);
    }

    function getColorComponentGreen(uint256 value)
        internal
        pure
        returns (uint8)
    {
        return uint8((value >> 4) & 0xff);
    }

    function getColorComponentBlue(uint256 value)
        internal
        pure
        returns (uint8)
    {
        return uint8(value & 0xff);
    }

    /**
     * @param seed of the token 
     * @return value of 'number'
     */
    function getRGB(bytes32 seed) 
        public 
        pure 
        returns (uint8[3] memory)
    {
        uint256 col = generateColor(bytes32(seed));
        return [getColorComponentRed(col), getColorComponentGreen(col), getColorComponentBlue(col)];
    }

    function getHex(bytes32 seed) 
        public 
        pure 
        returns(string memory) 
    {
        uint8[3] memory rgb = getRGB(seed);
        string[3]memory  color;
        color[0] = string(Utils.uintToHex(rgb[0]));
        color[1] = string(Utils.uintToHex(rgb[1]));
        color[2] = string(Utils.uintToHex(rgb[2]));
        return  string.concat("#", color[0], color[1], color[2]);
    } 

   

    function SquareSVG(bytes32 seed) 
        private 
        view 
        returns (string memory) 
    {
        string[32] memory palette = getPalette(seed);
        // uint256 red = BytesLib.toUint256(palette[0], 0);
        string memory colorTuple;
        uint256 HEIGHT = 16;
        string memory renderSvg;
        for(uint256 i=0; i<palette.length; i++) {
            colorTuple = string.concat(
                Utils.uint2str(palette[i][0]),
                ",",
                Utils.uint2str(palette[i][1]),
                ",",
                Utils.uint2str(palette[i][2])
              );
            renderSvg = string.concat(
                renderSvg,
                '<rect width="',
                    Utils.uint2str(SIZE),
                    '" y="',
                    Utils.uint2str(i*HEIGHT),
                    '" height="',
                    Utils.uint2str(HEIGHT),
                    '" fill="rgb(',
                    colorTuple,
                    ')"></rect>'
                );
        }
        return renderSvg;
    }

    // function drawPalette(uint256 _tokenId, bytes32 _seed) public view returns (string memory) {
        
        
          
    //     // console.log("fff", palette[0][0]);
    //     string memory renderSvg = string.concat(
    //         '<svg width="',
    //         Utils.uint2str(SIZE),
    //         '" height="',
    //         Utils.uint2str(SIZE),
    //         '" viewBox="0 0 ',
    //         Utils.uint2str(SIZE),
    //         " ",
    //         Utils.uint2str(SIZE),
    //         '" xmlns="http://www.w3.org/2000/svg">'
    //       );
    //       string memory blocks = SquareSVG(_tokenId, _seed);
    //       renderSvg = string.concat(renderSvg, blocks, "</svg>");
          
    //       return renderSvg;
    // }

    
    function getBasePalette(bytes32 _seed) 
        public 
        view 
        returns (Color[32] memory)
    {
        Color[32] palette;
        uint256 baseColor = generateColor( _seed);

        Color base = Color( 
            getColorComponentRed(baseColor), 
            getColorComponentGreen(baseColor), 
            getColorComponentBlue(baseColor)
        );
        
        palette.push(base);
        bytes memory isColor = new bytes(1);
        if(base.r > base.g && base.r > base.b) {
            isColor = "r";
        }else if(base.g > base.b) {
            isColor = "g";
        }else if(base.b > base.g) {
            isColor = "b";
        }else {
            isColor = "x";
        }



        palette.push(
            Color(
                base.b,
                base.g,
                base.r  
            )
        );
        return palette;
    }
    
    // function asciiToInteger(bytes32 x) public pure returns (uint256) {
    //     uint256 y;
    //     for (uint256 i = 0; i < 32; i++) {
    //         uint256 c = (uint256(x) >> (i * 8)) & 0xff;
    //         if (48 <= c && c <= 57)
    //             y += (c - 48) * 10 ** i;
    //         else
    //             break;
    //     }
    //     return y;
    // }
}
