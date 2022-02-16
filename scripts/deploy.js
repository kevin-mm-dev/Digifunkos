const deploy =async()=>{
    const [deployer] = await ethers.getSigners();
    
    console.log("Deploying contract with the account ", deployer.address);
    const DigiFunkos= await ethers.getContractFactory("DigiFunkos");

    const deployed = await DigiFunkos.deploy(10000);
    // const deployed = await DigiFunkos.deploy(["0x4317c44fD3143D8AC5723865CF046238A2cd8FD3", "0x128b13c88537ea482D318014720dd0De5aC0B22e"], [60, 40], 10000);
    console.log('DigiFunkos is deployed at: ', deployed.address);
};

deploy().then(()=>process.exit(0)).catch(e=>{
    console.log(e);
    process.exit(1);
}); 

// (async function deploy() {
//     const contractName = "PlatziPunks";
//     try {
//         const [account] = await ethers.getSigners();
//         console.log("Deploying contract with the account:", account.address);
//         const contractFactory = await ethers.getContractFactory(contractName);
//         const contract = await contractFactory.deploy();
//         console.log(`${contractName} has been deployed at: ${contract.address}`)
//         process.exit(0);
//     } catch (error) {
//         console.log("Error: ",`An error occurred, the contract ${contractName} could not be deployed \n ${error.stack}`);
//         process.exit(1);
//     }
// })()