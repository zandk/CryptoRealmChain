pragma solidity ^0.4.16;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RealmBase.sol";

contract RealmBaseTest {
    function testInitialTileCount() public {
        RealmBase rb = RealmBase(DeployedAddresses.RealmBase());

        uint expected = 7;

        Assert.equal(rb.GetTileCount(), expected, "There should be 7 tiles");
    }

    function testGetTileValue1() public {
        RealmBase rb = RealmBase(DeployedAddresses.RealmBase());

        int32 expectedX = 0;
        int32 expectedY = -1;

        var (owner, x, y) = rb.GetTile(1);

        Assert.equal(x, expectedX, "X should be 0");
        Assert.equal(y, expectedY, "Y should be -1");
    }

    function testGetTileValue2() public {
        RealmBase rb = RealmBase(DeployedAddresses.RealmBase());

        int32 expectedX = 0;
        int32 expectedY = 1;

        var (owner, x, y) = rb.GetTile(2);

        Assert.equal(x, expectedX, "X should be 0");
        Assert.equal(y, expectedY, "Y should be 1");
    }
}