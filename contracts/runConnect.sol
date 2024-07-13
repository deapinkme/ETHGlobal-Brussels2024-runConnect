// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LocationRegistry {
    // Mapping from coarse location to list of telegram handles (runners)
    mapping(string => string[]) private locationToRunners;

    // Event emitted when a runner is added to a location
    event RunnerAdded(string coarseLocation, uint preciseLocation , string telegramHandle); // AMS - FHE encrypted preciseLocation

    // Function to register a runner at a coarse location
    function registerCoarseLocation(string calldata coarseLocation, string calldata telegramHandle) external {
        require(bytes(location).length > 0, "Location cannot be empty");
        require(bytes(telegramHandle).length > 0, "Telegram handle cannot be empty");

        locationToRunners[location].push(telegramHandle);
        emit RunnerAdded(location, telegramHandle); //AMS - do we wanna hand in encrypted fine location
    }

    // Function to find runners within a given distance radius
    function findRunners(string calldata location, uint distanceRadius) external view returns (string[] memory) {
        require(bytes(location).length > 0, "Location cannot be empty");
        require(distanceRadius > 0, "Distance radius must be greater than zero"); // AMS - maybe there should be a minimum and maximum

        string[] memory result;

        // Loop through neighboring coarse locations (for demonstration, let's assume a simplified model)
        // In real-world applications, you would need a more sophisticated method to determine neighbors
        for (uint i = 0; i <= distanceRadius; i++) {
            string memory neighborLocation = concatenateLocations(location, int(i));
            result = concatArrays(result, locationToRunners[neighborLocation]);
        }

        // AMS - conditional pushing requires branching
        // AMS - use bit string - inclusion is binary 

        return result;
    }

    // Helper function to concatenate a location with an integer offset
    function concatenateLocations(string memory location, int offset) internal pure returns (string memory) {
        // Convert offset to string and concatenate with location
        // For demonstration, this is a simplified method and should be adjusted based on your actual use case
        return string(abi.encodePacked(location, "_", toString(offset)));
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

    // Helper function to convert an int to a string
    function toString(int value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        bool negative = value < 0;
        uint v = negative ? uint(-value) : uint(value);
        uint len = negative ? 2 : 1 + uint(log10(v));
        bytes memory bstr = new bytes(len);
        unchecked {
            uint p = len - 1;
            if (negative) {
                bstr[0] = "-";
            }
            while (v != 0) {
                bstr[p--] = bytes1(uint8(48 + v % 10));
                v /= 10;
            }
        }
        return string(bstr);
    }
}
