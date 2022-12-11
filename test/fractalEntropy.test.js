
const { ethers, waffle } = require("hardhat");
const { expect } = require("chai");
const { id, hexlify } = require("ethers/lib/utils");

describe("FractalEntropy contract", async () => {
  let AEFToken;
  let token721;
  let _name='FractalEntropy';
  let _symbol='FRCTL';
  let MAX_SUPPLY = 10;
  let account1,otheraccounts;

  beforeEach(async function () {
    AEFToken = await ethers.getContractFactory("FractalEntropy");
   [owner, account1, ...otheraccounts] = await ethers.getSigners();

    token721 = await AEFToken.deploy();
  });

  describe("Should Deploy", async function () {

    it("Should have the correct name and symbol ", async function () {
      expect(await token721.name()).to.equal(_name);
      expect(await token721.symbol()).to.equal(_symbol);
    });
    
    it("Should set the sale to open", async function () {
      await expect(await token721.toggleSale()).to.emit(token721, "SaleStateChange").withArgs(true);
    })
    
    it("Should revert with error SaleIsClosed()", async function () {
      const address1=account1.address;
      let response =  token721.safeMint(address1, ethers.utils.id("firstNFT"));
          await expect(response).to.be.revertedWith("SaleIsClosed()");
       
    })

    it("Should mint a token with token ID 1 & 2 to account1", async function () {
      const address1 = account1.address;
      
      await token721.toggleSale();
      
      await token721.safeMint( address1, ethers.utils.id("firstNFT") );
      expect(await token721.ownerOf(ethers.BigNumber.from(1))).to.equal(address1);     
      
      await token721.safeMint( address1, ethers.utils.id("secondNFT") );
      console.log(await token721.tokenURI(0x1))
      expect(await token721.ownerOf(ethers.BigNumber.from(2))).to.equal(address1);
      
      expect( await token721.balanceOf( address1 ) ).to.equal( ethers.BigNumber.from( 2 ) );
    });

    it("Should mint up to MAX_SUPPLY", async function () {
      const address1=account1.address;
      await token721.toggleSale();

      let i;
      for( i = 1; i < ( MAX_SUPPLY + 1 ); i++ ) {
        await token721.safeMint( address1, ethers.utils.id("firstNFT") ); 
      }
      expect( i == MAX_SUPPLY )
    });
    
    it("Should revert with 'Max supply reached!'", async function () {
      const address1=account1.address;
      let i, bigIndex;
      await token721.toggleSale();

      for(i = 1; i < (MAX_SUPPLY + 1); i++){
        let uri = ethers.utils.id(i + "something")
        console.log(uri, " ", i)
        idx = await token721.safeMint(address1, uri);
        await idx.wait()
        bigIndex = hexlify(i)
        console.log(await token721.tokenURI(i))

        if(i == MAX_SUPPLY) {
          let response =  token721.safeMint(address1, ethers.utils.id("firstNFT"));
          await expect(response).to.be.revertedWith("MaxSupplyReached()");
        }
      }
    });
  });
});