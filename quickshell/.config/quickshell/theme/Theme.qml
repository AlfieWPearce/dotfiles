pragma Singleton

import Quickshell
import QtQuick

Singleton {
    // Colours
    readonly property color background: "#353535"
    readonly property color backgroundSecondary: "#454545"

    readonly property color textPrimary: "#ffffff"
    readonly property color textSecondary: "#b0b0b0"

    // Spacing
    readonly property int spacingSmall: 4
    readonly property int spacingMedium: 8
    readonly property int spacingLarge: 16

    // Padding
    readonly property int paddingHorizontal: 10
    readonly property int paddingVertical: 4

    readonly property int textPadding: 8

    // Corner radii
    readonly property int radiusSmall: 6
    readonly property int radiusMedium: 8
    readonly property int radiusLarge: 12

    // Typography
    readonly property int fontSmall: 12
    readonly property int fontNormal: 14
    readonly property int fontLarge: 16

    readonly property string fontFamily: "JetBrainsMono Nerd Font" //"monospace"
}
