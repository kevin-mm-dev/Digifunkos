const { expect } = require('chai');

describe('Digi Funkos Contract',()=>{
    const setup = async ({maxSupply=1000})=>{
        const [owner] = await ethers.getSigners();
        const DigiFunkos= await ethers.getContractFactory('DigiFunkos');

        const deployed = await DigiFunkos.deploy(maxSupply);
        return {
            owner,
            deployed
        }
        
    }
    describe('Deployment',()=>{
        it('Set max supply to passed param',async ()=>{
            const maxSupply=4000;
            const {deployed} = await setup({maxSupply});
            const returnedMaxSupply = await deployed.maxSupply();
            expect(maxSupply).to.equal(returnedMaxSupply);
        });
    });

    describe('Minting',()=>{
        it('Mints a new token and assings it to owner', async ()=>{

            const {owner,deployed} = await setup({});
            await deployed.mint();
            const ownerOfMinting = await deployed.ownerOf(0);
            expect(ownerOfMinting).to.equal(owner.address);

        });
        it('Has a minting limit', async () =>{
            const maxSupply=2;
            const {deployed}=await setup({maxSupply});
            await Promise.all([deployed.mint(),deployed.mint(), deployed.mint()]); 
            // await deployed.mint();
            // await deployed.mint();

            //Assert that last minting
            // console.log('Try new mint ',await deployed.mint());
            await expect(deployed.mint()).to.be.revertedWith("No DigiFunkos left :(");
        });
    });


    describe("tokenURI", () => {
        it("returns valid metadata", async () => {
          const { deployed } = await setup({});
  
          await deployed.mint();
  
          const tokenURI = await deployed.tokenURI(0);
          const stringifiedTokenURI = await tokenURI.toString();
          const [, base64JSON] = stringifiedTokenURI.split(
            "data:aplication/json;base64,"
          );
          const stringifiedMetadata = await Buffer.from(
            base64JSON,
            "base64"
          ).toString("ascii");
          const metadata = JSON.parse(stringifiedMetadata);
          expect(metadata).to.have.all.keys("name", "description", "image");
        });
      });
});








