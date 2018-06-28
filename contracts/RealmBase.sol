pragma solidity ^0.4.4;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/Math/SafeMath.sol";

contract RealmBase {
    // Imports
    using SafeMath for uint256;
    // Events
    event OnUpdateTileOwner(uint tileId, address newOwner);
    event OnNewTile(uint tileId);
    
    // Structs
    struct Tile {
        int16 x;
        int16 y;
        uint8 resource;
        uint8 resourceQuantity;
        uint8 improvement;
    }

    // -- Storage --
    // World
    Tile[] tiles;

    // Maps
    mapping(int16 => mapping(int16 => uint)) positionToTileId;
    mapping (uint => address) tileIdToOwner;

    constructor() public {
        // Create base tiles
        for (int16 x = -5; x < 5; x++) {
            for (int16 y = -5; y < 5; y++) {
                createTile(x, y);
            }
        }
    }

    function createTile(int16 _x, int16 _y) internal returns(uint id) {
        // TODO - make sure position isn't already occupied
        //   and that it is valid (next to another tile)
        uint newId = tiles.push(Tile(_x, _y, 1, 1, 0)) - 1;
        positionToTileId[_x][_y] = newId;
        emit OnNewTile(newId);
        return newId;
    }

    function tileExists(int16 _x, int16 _y) internal view returns(bool) {
        if ( (_x != 0 || _y != 0) && (positionToTileId[_x][_y] == 0)) {
            return false;
        }
        return true;
    }
    
    /** @dev function for claiming unowned tiles
      * @return worked Whether or not claim went through
      */
    function ClaimTile(uint _id) public returns(bool) {
        require(tileIdToOwner[_id] == address(0));

        tileIdToOwner[_id] = msg.sender;
        emit OnUpdateTileOwner(_id, msg.sender);
    }

    /** @dev Returns the amount of tiles in the world
      * @return length The length of tiles in the world.
      */
    function GetTileCount() public view returns(uint) {
        return tiles.length;
    }

    /** @dev Gets data for a specific tile in the world
      * @param _id id of the tile to get data for.
      * @return owner The address of the owner of this tile.
      * @return x The x position of this tile.
      * @return y The y position of this tile.
      */
    function GetTile(uint _id) public view returns(address owner, int16 x, int16 y, uint8 resource, uint8 resourceQuantity, uint8 improvement) {
        return (tileIdToOwner[_id], tiles[_id].x, tiles[_id].y, tiles[_id].resource, tiles[_id].resourceQuantity, tiles[_id].improvement);
    }

    function TestValue(uint _id) public view returns(uint output) {
        return _id;
    }
 
}
  