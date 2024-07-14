// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@fhenixprotocol/contracts/FHE.sol";

contract LocationRegistry {
    // create struct tuple (encryptedPreciseLocation, telegramHandle)
    struct RunnerInfo {
            uint coarseLocationX;
            uint coarseLocationY;
            euint8 encryptedPreciseLocationX;
            euint8 encryptedPreciseLocationY;
            string telegramHandle;
    }

    //
    mapping(uint coarseLocationX => mapping(uint coarseLocationY => uint[] runnersI )) loc2RI; //loc2RI - location to runner index

    // how to find yourself and others
    mapping(address => uint runnerIndex) address2runnerI; // ETH address to runner index

    // all runners
    RunnerInfo[] allRunners;
    
    // Event emitted when a runner is added to a location
    event RunnerAdded(address, uint runnerIndex); // AMS - FHE encrypted preciseLocation - RunnerInfo runner?

    // Function to register a runner at a coarse location
    function registerRunner(uint coarseLocationX, uint coarseLocationY, inEuint8 calldata _encryptedPreciseLocationX, inEuint8 calldata _encryptedPreciseLocationY, string memory telegramHandle) external {
        require(coarseLocationX > 0, "Location cannot be empty");
        require(coarseLocationY > 0, "Location cannot be empty");
        require(bytes(telegramHandle).length > 0, "Telegram handle cannot be empty");


        if (address2runnerI[msg.sender] != 0){ 
            // AMS - this address has already registered a runner, do we want to re-register? Do we wanna delete EOD?
            // throw error?
        } else {
            allRunners.push(RunnerInfo({
                coarseLocationX: coarseLocationX,
                coarseLocationY: coarseLocationY,
                encryptedPreciseLocationX: FHE.asEuint8(_encryptedPreciseLocationX),
                encryptedPreciseLocationY: FHE.asEuint8(_encryptedPreciseLocationY),
                telegramHandle: telegramHandle
                }));
        }


        // coarseLocationToRunnersLocationAndTelegram[coarseLocation].push((_encryptedPreciseLocation, telegramHandle));
        emit RunnerAdded(address, address2runnerI[msg.sender]); //AMS - do we wanna hand in encrypted fine location
    }

    // Function to find runners within a given distance radius
    function findRunners(uint distanceRadius) external view returns (string[] memory) {
        // AMS - check that they have created runner
        // AMS - 
        
        // require(bytes(location).length > 0, "Location cannot be empty");
        // require(distanceRadius > 0, "Distance radius must be greater than zero"); // AMS - maybe there should be a minimum and maximum

        string[] result;

        // Loop through neighboring coarse locations (for demonstration, let's assume a simplified model)
        // In real-world applications, you would need a more sophisticated method to determine neighbors
        for (uint i = 0; i <= distanceRadius; i++) {
            euint8 neighborEPreciseLocation = concatenateLocations(location, int(i));
            result = concatArrays(result, coarseLocationToRunnersLocationAndTelegram[neighborEPreciseLocation]);
        }

        // AMS - conditional pushing requires branching
        // AMS - use bit string - inclusion is binary 

        return result;
    }

    // Helper function to concatenate a location with an integer offset
    function concatenateLocations(string memory location, int offset) internal pure returns (string memory) {
        // Convert offset to string and concatenate with location
        // For demonstration, this is a simplified method and should be adjusted based on your actual use case
        return string(abi.encodePacked(location, "_", offset)); // AMS - this is not the same type!!!
    }

    // Helper function to concatenate two string arrays
    function concatArrays(string[] memory arr1, string[] memory arr2) internal pure returns (string[] memory) {
        uint len1 = arr1.length;
        uint len2 = arr2.length;
        string[] memory merged = new string[](len1 + len2);

        for (uint i = 0; i < len1; i++) {
            merged[i] = arr1[i];
        }

        for (uint i = 0; i < len2; i++) {
            merged[len1 + i] = arr2[i];
        }

        return merged;
    }

}
