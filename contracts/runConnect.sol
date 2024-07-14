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
        emit RunnerAdded(msg.sender, address2runnerI[msg.sender]); //AMS - do we wanna hand in encrypted fine location
    }

     // Function to register a runner at a coarse location
    function removeRunner() external {

        if (address2runnerI[msg.sender] != 0){ 
            // AMS - set index to 0
            address2runnerI[msg.sender] = 0;
        }


        // coarseLocationToRunnersLocationAndTelegram[coarseLocation].push((_encryptedPreciseLocation, telegramHandle));
        emit RunnerAdded(msg.sender, address2runnerI[msg.sender]); //AMS - do we wanna hand in encrypted fine location
    }
   

    // Function to find runners within a given distance radius
    function findRunners(uint distanceRadius) external view returns (string[] calldata theList) {
        // AMS - check that they have created runner
        // AMS - 
        require(distanceRadius > 0, "Distance radius must be greater than zero"); // AMS - maybe there should be a minimum and maximum

        if (address2runnerI[msg.sender] != 0){ 
            // check coarse location x
            // check coarse location x
            uint myX = allRunners[address2runnerI[msg.sender]].coarseLocationX;
            uint myY = allRunners[address2runnerI[msg.sender]].coarseLocationY;
            euint8 myEx = allRunners[address2runnerI[msg.sender]].encryptedPreciseLocationX;
            euint8 myEy = allRunners[address2runnerI[msg.sender]].encryptedPreciseLocationY;
            uint[] memory othersI = loc2RI[myX][myY];
            theList = new string[](othersI.length);
            for (uint i = 0; i<othersI.length; i++) {
                euint8 othersEx = allRunners[i].encryptedPreciseLocationX;
                euint8 othersEy = allRunners[i].encryptedPreciseLocationY;
                if (dist(myEx, myEy, othersEx, othersEy) <= distanceRadius) {
                    string storage th = allRunners[i].telegramHandle;
                    theList.push(th);
                }
            }
            // return list of runners
        }
    }

    function dist(euint8 x1, euint8 y1, euint8 x2, euint8 y2) internal returns (uint8) {
        euint8 eDist = FHE.add(
            FHE.sub(FHE.max(x1, x2), FHE.min(x1, x2)),
            FHE.sub(FHE.max(y1, y2), FHE.min(y1, y2)));
        return FHE.decrypt(eDist);
    }
}
