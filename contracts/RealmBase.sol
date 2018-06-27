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
        int32 x;
        int32 y;
    }

    // -- Storage --
    // World
    Tile[] tiles;

    // Maps
    mapping(int32 => mapping(int32 => uint)) positionToTileId;
    mapping (uint => address) tileIdToOwner;

    constructor() public {
        // Create base tiles

        // Genesis tile! id = 0
        createTile(0, 0);
        // other default tiles
        createTile(0, -1);
        createTile(0, 1);
        createTile(-1, 0);
        createTile(1, 0);
        createTile(1, -1);
        createTile(-1, 1);
    }

    function createTile(int32 _x, int32 _y) internal returns(uint id) {
        // TODO - make sure position isn't already occupied
        //   and that it is valid (next to another tile)
        uint newId = tiles.push(Tile(_x, _y)) - 1;
        positionToTileId[_x][_y] = newId;
        emit OnNewTile(newId);
        return newId;
    }

    function tileExists(int32 _x, int32 _y) internal view returns(bool) {
        if ( (_x != 0 || _y != 0) && (positionToTileId[_x][_y] == 0)) {
            return false;
        }
        return true;
    }
    
    /** @dev function for creating a new "guy"
      * @return worked Whether or not claim went through
      */
    function ClaimTile(uint _id) public returns(bool) {
        require(tileIdToOwner[_id] == address(0));

        // If we are claiming a tile for the first time
        Tile memory t = tiles[_id];
        if (!tileExists(t.x+1, t.y)) {
            createTile(t.x+1, t.y);
        }
        if (!tileExists(t.x, t.y+1)) {
            createTile(t.x, t.y+1);
        }
        if (!tileExists(t.x-1, t.y)) {
            createTile(t.x-1, t.y);
        }
        if (!tileExists(t.x, t.y-1)) {
            createTile(t.x, t.y-1);
        }
        if (!tileExists(t.x+1, t.y-1)) {
            createTile(t.x+1, t.y-1);
        }
        if (!tileExists(t.x-1, t.y+1)) {
            createTile(t.x-1, t.y+1);
        }

        tileIdToOwner[_id] = msg.sender;
        emit OnUpdateTileOwner(_id, msg.sender);
        // emit NewGuy(id, _name, _dna);
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
    function GetTile(uint _id) public view returns(address owner, int32 x, int32 y) {
        return (tileIdToOwner[_id], tiles[_id].x, tiles[_id].y);
    }

    function TestValue(uint _id) public view returns(uint output) {
        return _id;
    }
 
}
  