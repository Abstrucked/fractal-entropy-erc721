
/**
 * Data price check
 * 
 * Ethereum -     0xbbCF401Bd6434B7Cff4c18e1D92E51816Ecc37D4
 * Arbitrum One - 0xF6A39693691B1F4fBeb77BFda23CFbD4bBF2bCfc
 */
const { ethers, waffle } = require("hardhat");
const { expect } = require("chai");
const { id, hexlify } = require("ethers/lib/utils");
const { BigNumber } = require("ethers");

describe("FractalEntropy contract", async () => {
  let AEFToken;
  let token721;
  let _name='FractalEntropy';
  let _symbol='FRCTL';
  let MAX_SUPPLY = 10;
  let account1,otheraccounts;
  let data;
  beforeEach(async function () {
    AEFToken = await ethers.getContractFactory("FractalEntropy");
   [owner, account1, ...otheraccounts] = await ethers.getSigners();

    token721 = await AEFToken.deploy();
    // const bg = ethers.BigNumber.from("000001")
    // console.log(bg)
    // const p = "thisisthepalette"
    // const palette = ethers.utils.defaultAbiCoder.encode(['string'], [p.toString()])
    // data = ethers.utils.defaultAbiCoder.encode(['uint256', 'uint256', 'uint8', 'uint32', 'bytes' ], [bg, bg, 8, 5000, palette] )

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
      
      const id  = await token721.safeMint( address1, ethers.utils.id("firstNFT"));
      id.wait()
      expect(await token721.ownerOf(ethers.BigNumber.from(1))).to.equal(address1);     
      
      const fractal = await token721.getFractalData(ethers.BigNumber.from(1))
      // console.log("Fractal: 1 --- ", fractal);
      // console.log(await token721.ownerOf(0x1));     
      const user = token721.connect(account1)
      const p = `0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000a737b2278223a2d302e353937373539353937333335383531342c2279223a2d302e363539393534313538343433343033372c227363616c65223a3432362c2270616c65747465223a5b2223666666666666222c2223666566656665222c2223666466646664222c2223666366636663222c2223666266626662222c2223666166616661222c2223663966396639222c2223663866386638222c2223663766376637222c2223663666366636222c2223663566356635222c2223663466346634222c2223663366336633222c2223663266326632222c2223663166316631222c2223663066306630222c2223656665666566222c2223656565656565222c2223656465646564222c2223656365636563222c2223656265626562222c2223656165616561222c2223653965396539222c2223653865386538222c2223653765376537222c2223653665366536222c2223653565356535222c2223653465346534222c2223653365336533222c2223653265326532222c2223653165316531222c2223653065306530222c2223646664666466222c2223646564656465222c2223646464646464222c2223646364636463222c2223646264626462222c2223646164616461222c2223643964396439222c2223643864386438222c2223643764376437222c2223643664366436222c2223643564356435222c2223643464346434222c2223643364336433222c2223643264326432222c2223643164316431222c2223643064306430222c2223636663666366222c2223636563656365222c2223636463646364222c2223636363636363222c2223636263626362222c2223636163616361222c2223633963396339222c2223633863386338222c2223633763376337222c2223633663366336222c2223633563356335222c2223633463346334222c2223633363336333222c2223633263326332222c2223633163316331222c2223633063306330222c2223626662666266222c2223626562656265222c2223626462646264222c2223626362636263222c2223626262626262222c2223626162616261222c2223623962396239222c2223623862386238222c2223623762376237222c2223623662366236222c2223623562356235222c2223623462346234222c2223623362336233222c2223623262326232222c2223623162316231222c2223623062306230222c2223616661666166222c2223616561656165222c2223616461646164222c2223616361636163222c2223616261626162222c2223616161616161222c2223613961396139222c2223613861386138222c2223613761376137222c2223613661366136222c2223613561356135222c2223613461346134222c2223613361336133222c2223613261326132222c2223613161316131222c2223613061306130222c2223396639663966222c2223396539653965222c2223396439643964222c2223396339633963222c2223396239623962222c2223396139613961222c2223393939393939222c2223393839383938222c2223393739373937222c2223393639363936222c2223393539353935222c2223393439343934222c2223393339333933222c2223393239323932222c2223393139313931222c2223393039303930222c2223386638663866222c2223386538653865222c2223386438643864222c2223386338633863222c2223386238623862222c2223386138613861222c2223383938393839222c2223383838383838222c2223383738373837222c2223383638363836222c2223383538353835222c2223383438343834222c2223383338333833222c2223383238323832222c2223383138313831222c2223383038303830222c2223376637663766222c2223376537653765222c2223376437643764222c2223376337633763222c2223376237623762222c2223376137613761222c2223373937393739222c2223373837383738222c2223373737373737222c2223373637363736222c2223373537353735222c2223373437343734222c2223373337333733222c2223373237323732222c2223373137313731222c2223373037303730222c2223366636663666222c2223366536653665222c2223366436643664222c2223366336633663222c2223366236623662222c2223366136613661222c2223363936393639222c2223363836383638222c2223363736373637222c2223363636363636222c2223363536353635222c2223363436343634222c2223363336333633222c2223363236323632222c2223363136313631222c2223363036303630222c2223356635663566222c2223356535653565222c2223356435643564222c2223356335633563222c2223356235623562222c2223356135613561222c2223353935393539222c2223353835383538222c2223353735373537222c2223353635363536222c2223353535353535222c2223353435343534222c2223353335333533222c2223353235323532222c2223353135313531222c2223353035303530222c2223346634663466222c2223346534653465222c2223346434643464222c2223346334633463222c2223346234623462222c2223346134613461222c2223343934393439222c2223343834383438222c2223343734373437222c2223343634363436222c2223343534353435222c2223343434343434222c2223343334333433222c2223343234323432222c2223343134313431222c2223343034303430222c2223336633663366222c2223336533653365222c2223336433643364222c2223336333633363222c2223336233623362222c2223336133613361222c2223333933393339222c2223333833383338222c2223333733373337222c2223333633363336222c2223333533353335222c2223333433343334222c2223333333333333222c2223333233323332222c2223333133313331222c2223333033303330222c2223326632663266222c2223326532653265222c2223326432643264222c2223326332633263222c2223326232623262222c2223326132613261222c2223323932393239222c2223323832383238222c2223323732373237222c2223323632363236222c2223323532353235222c2223323432343234222c2223323332333233222c2223323232323232222c2223323132313231222c2223323032303230222c2223316631663166222c2223316531653165222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033222c2223303330333033225d2c22697465726174696f6e73223a3235352c226261696c6f7574223a322e352c22706978656c73223a367d00000000000000000000000000`
      const palette = ethers.utils.defaultAbiCoder.encode(['string'], [p.toString()])
      const res = await user.changePalette(ethers.BigNumber.from(1), palette)
      res.wait();
      const fractal2 = await token721.getFractalData(ethers.BigNumber.from(1))
      // console.log("Fractal: 2 --- ", fractal2);

      await token721.safeMint( address1, ethers.utils.id("secondNFT"));
      // console.log(await token721.tokenURI(0x1))
      
      expect(await token721.ownerOf(ethers.BigNumber.from(2))).to.equal(address1);
      
      expect( await token721.balanceOf( address1 ) ).to.equal( ethers.BigNumber.from( 2 ) );
    });

    it("Should mint up to MAX_SUPPLY", async function () {
      const address1=account1.address;
      await token721.toggleSale();

      let i;
      for( i = 1; i <= ( MAX_SUPPLY  ); i++ ) {
        await token721.safeMint( address1, ethers.utils.id("firstNFT") ); 
      }
      const minted = await token721.minted()
      // console.log("minted: ", minted, "max: ", ethers.BigNumber.from(MAX_SUPPLY));
      expect( (await token721.minted()) === ethers.BigNumber.from(MAX_SUPPLY) )
    });
    
    it("Should revert with 'Max supply reached!'", async function () {
      const address1=account1.address;
      let i, bigIndex;
      await token721.toggleSale();

      for(i = 1; i <= (MAX_SUPPLY ); i++){
        let uri = ethers.utils.id(i + "something")
        // console.log(uri, " ", i)
        idx = await token721.safeMint(address1, uri);
        await idx.wait()
        bigIndex = hexlify(i)
        // console.log(await token721.tokenURI(i))
      }
        let response =  token721.safeMint(address1, ethers.utils.id("firstNFT"));
        await expect(response).to.be.revertedWith("MaxSupplyReached()");
    });
  });
});