import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
    Image {
        source: "/home/mau/.config/quickshell/newtile.png"
    }
    Image {
        x: 80
        width: 100
        height: 100
        source: "tile.png"
    }
    Image {
        x: 190
        width: 100
        height: 100
        fillMode: Image.Tile
        source: "tile.png"
    }
}
