import Quickshell
import QtQuick

Text {
  property string time: "00:00"
  text: time
  color: "white"
  font.pixelSize: 16
  font.weight: Font.Medium
  font.family: "monospace"
  font.letterSpacing: 1
  font.features: {"tnum": 1}
}
