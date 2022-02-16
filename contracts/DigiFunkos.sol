//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/StorageSlot.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./Base64.sol";
import "./DigiFunkosDNA.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";

contract DigiFunkos is ERC721, ERC721Enumerable, DigiFunkosDNA  {// ,PaymentSplitter
    using Counters for Counters.Counter;
    using Strings for uint256;



    Counters.Counter private _idCounter;
    uint256 public maxSupply;
    mapping (uint256=>uint256) public tokenDNA;

    // constructo r( uint256 _maxSupplay) ERC721("DigiFunkos", "DFKS"){
    
    // constructor( address[] memory _payees, uint256[] memory  _shares, uint256 _maxSupply) ERC721("DigiFunkos", "DFKS") PaymentSplitter(_payees, _shares) payable {
    constructor(uint256 _maxSupply ) ERC721("DigiFunkos", "DFKS") {
        maxSupply = _maxSupply;
    }

    function mint() public payable {
        uint256 current = _idCounter.current();
        require (current<=maxSupply, "No DigiFunkos left :(");
        tokenDNA[current]=deterministicPseudoRandomDNA(current,msg.sender);
        _safeMint(msg.sender, current);
        // require(msg.value >= 50000000000000000,"you neet 0.05 ETH to mint the PinaPunks");
        _idCounter.increment();
    }

    function _baseURI() internal pure override returns (string memory) {
        return 'https://avataaars.io/';

    }

    function _paramsURI(uint256 _dna) internal view returns (string memory) { 
        string memory params;
        {

        params = string(
                abi.encodePacked(
                    "accessoriesType=",
                    getAccessoriesType(_dna),
                    "&clotheColor=",
                    getClotheColor(_dna),
                    "&clotheType=",
                    getClotheType(_dna),
                    "&eyeType=",
                    getEyeType(_dna),
                    "&eyebrowType=",
                    getEyeBrowType(_dna),
                    "&facialHairColor=",
                    getFacialHairColor(_dna),
                    "&facialHairType=",
                    getFacialHairType(_dna),
                    "&hairColor=",
                    getHairColor(_dna),
                    "&hatColor=",
                    getHatColor(_dna),
                    "&graphicType=", 
                    getGraphicType(_dna),
                    "&mouthType=",
                    getMouthType(_dna),
                    "&skinColor=",
                    getSkinColor(_dna)
                )
            );
        }

        return string (abi.encodePacked(params,"&topType", getTopType(_dna)));
    }

    function imageByDNA(uint256 _dna) public view returns (string memory) {
        string memory base64=_baseURI();
        string memory paramsURI=_paramsURI(_dna);

        return string(abi.encodePacked(base64,"?",paramsURI));
    }

    function tokenURI(uint256 tokenId) public view override returns(string memory) {
        require(_exists(tokenId), "ERC721 Metadata: URI query for nonexistent token");
        uint256 dna=tokenDNA[tokenId];
        string memory image=imageByDNA(dna);
        string memory jsonURI = Base64.encode(
            abi.encodePacked( // it's to concat strings
                ' { "name":"DigiFunkos #', 
                tokenId.toString(),
                '", "description":"Digifunkos with ADN random", "image": "',image,'"}'
                )
            );

        return string (abi.encodePacked("data:aplication/json;base64,",jsonURI));
    }

    //Override required
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}









