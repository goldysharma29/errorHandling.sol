// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LostAndFound {
    struct Smartphone {
        address owner;
        string brand;
        string model;
        string color;
        bool isFound;
    }

    mapping(uint => Smartphone) public smartphones;
    uint public nextId;

    event SmartphoneReported(uint id, address owner, string brand, string model, string color);
    event SmartphoneFound(uint id);

    function reportSmartphone(string memory _brand, string memory _model, string memory _color) public {
        require(bytes(_brand).length > 0, "Brand must not be empty");
        require(bytes(_model).length > 0, "Model must not be empty");
        require(bytes(_color).length > 0, "Color must not be empty");

        smartphones[nextId] = Smartphone({
            owner: msg.sender,
            brand: _brand,
            model: _model,
            color: _color,
            isFound: false
        });
        emit SmartphoneReported(nextId, msg.sender, _brand, _model, _color);
        
        // Increment nextId safely
        uint oldNextId = nextId;
        nextId++;
        assert(nextId == oldNextId + 1); // Ensure nextId is incremented correctly
    }

    function findSmartphone(uint _id) public {
        require(_id < nextId, "Smartphone ID does not exist");
        require(!smartphones[_id].isFound, "Smartphone is already found");

        smartphones[_id].isFound = true;
        emit SmartphoneFound(_id);

        // Ensure isFound is correctly set to true
        assert(smartphones[_id].isFound);
    }

    // Fallback function to revert transactions sent to this contract
    fallback() external {
        revert("Invalid transaction");
    }

    // Receive function to accept ether sent to this contract
    receive() external payable {
        revert("Contract does not accept ether");
    }
}
