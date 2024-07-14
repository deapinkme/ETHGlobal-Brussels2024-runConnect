# ETHGlobal-Brussels2024-runConnect
🏃‍♀️ Run Connect

Run Connect is a project designed to find runners (or users) near you.

Here's what we built:

This is a proof of concept/trail to see if FHE is a viable/reasonable way to hide a users location and be used to find other users "nearby" without having to ever disclose location.

Public URL: https://ethglobal.com/showcase/undefined-fnj87
Slides: https://www.figma.com/slides/qJlmC5WLDUOQrz7HJZlSiH/Untitled?node-id=16-152&t=LYcjgFtZuirNARDD-0

This project is meant to see if FHE can be used to create a way for users (in this sample, runners) to connect without having to share location.

The premise of this is to create 3 basic features/functions:
1) Adding yourself to the runners pool
2) Removing yourself from it
3) Finding runners near you (within a specified distance)

The idea here is to try and create a way for runners (users) to find other runners(users) near by. Using FHE we can calculate the distance between two encrypted point and compare that to a desired and specified distance range.


The solidity smart contract imports FHE.

A struct is created that contains:
1) rounded longitude coordinate
2) rounded latitude coordinate
3) encrypted longitude coordinate
4) encrypted latitude coordinate
5) telegram handle

A user can register one runner per ETH address, and we have a mapping of ETH addresses to an index associated with a runner and therefore our struct.

A user can add to the list of runners, they can remove themselves from the list, and can provide a distance range, which uses the coarse (rounded) location to narrow down runners(users) and then goes through that list of runners and calculates the distance between the encrypted longitude and latitude coordinates.

The distance between two points should be calculated with Haversine formula (d  =  2r⋅arcsin(sin2(2Δϕ​)+cos(ϕ1​)⋅cos(ϕ2​)⋅sin2(2Δλ​)​)      ), given that the distance is not on a flat surface, but rather a spherical surface. This however is too complex for this example. For this example I decided to use Manhattan distance (distance  = d = ϕ2​−ϕ1​∣+∣λ2​−λ1​∣ ). This is accurate enough. Consider that the largest difference/discrepancy occurs between the poles and the horizon and a single degree will be 1km at the pole and 111km at the equator, this estimation is valid.

I pushed code to github, however, I compiled and tested my solidity smart contract in the remix web browser.
