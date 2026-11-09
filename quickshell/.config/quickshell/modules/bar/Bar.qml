import Quickshell
import QtQuick

import "."

Scope {
  id: root
  property var dashboardController
  property var panelWindow: null

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: barWindow
      required property var modelData
      screen: modelData

      Component.onCompleted: {
          root.panelWindow = barWindow
      }

      anchors {
        top: true
        left: true
        right: true
      }
      
      implicitHeight: 30
      color: "transparent"

      // MouseArea {
      //   anchors.fill: parent
      //   onClicked: dashboardController.toggle()
      // }
      TapHandler {
          onTapped: dashboardController.toggle()
      }

      CenterWidget {
        anchors.centerIn: parent
        dashboardControllerOpened: dashboardController.opened
      }

      StatusWidget {
        anchors {
          top: parent.top
          right: parent.right
        }
      }
    }
  }
}

