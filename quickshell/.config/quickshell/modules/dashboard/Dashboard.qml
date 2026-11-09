import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import "../../theme"
import "pages"

Scope {
    id: dashboard

    property var anchorWindow: null
    // Dashboard state
    property int currentPage: 0
    property bool opened: false

    readonly property var pages: [
        "Home",
        "Kanban",
        "Settings"
    ]

    // Open a specific page
    function openPage(index) {
        if (index < 0 || index >= pages.length)
            return

        currentPage = index
        // dashboardWindow.visible = true
        opened = true
    }

    // Toggle visibility
    function toggle() {
      // dashboardWindow.visible = !dashboardWindow.visible
      opened = !opened
    }

    // IPC commands
    IpcHandler {
        target: "dashboard"

        function toggle() {
            dashboard.toggle()
        }

        function home() {
            dashboard.openPage(0)
        }

        function kanban() {
            dashboard.openPage(1)
        }

        function settings() {
            dashboard.openPage(2)
        }

        function close() {
            // dashboardWindow.opened = false
            dashboard.opened = false
        }
    }

    // Keep popup alive for its animations
    Timer {
      id: closeTimer
      interval: 220
    }

    Connections {
      target: dashboard
      function onOpenedChanged() {
        if (dashboard.opened)
          closeTimer.stop()
        else
          closeTimer.restart()
      }
    }

    // Handles dashboard visibility
    // Item {
    PopupWindow {
        id: dashboardWindow
        grabFocus: true
        anchor.window: dashboard.anchorWindow
        anchor.rect.x: dashboard.anchorWindow ? (dashboard.anchorWindow.width - width) / 2 : 0
        anchor.rect.y: 0
        width: 850
        height: 520

        visible: dashboard.opened || closeTimer.running
        color: "transparent"

        // Animated content
        Item {
          anchors.fill: parent
          visible: dashboard.opened || opacity > 0.01
          opacity: dashboard.opened ? 1 : 0

          Behavior on opacity {
              NumberAnimation {
                  duration: 250
                  easing.type: Easing.InOutCubic
              }
          }
          transformOrigin: Item.Top

          scale: dashboard.opened ? 1.0 : 0.0
          Behavior on scale {
              NumberAnimation {
                  duration: 250
                  easing.type: Easing.InOutCubic
                  easing.overshoot: 0.15
              }
          }
        // // Main dashboard window
        // FloatingWindow {
        //     id: dashboardWindow
        //
        //     title: "Dashboard"
        //     // visible: false
        //
        //     implicitWidth: 850
        //     implicitHeight: 520
        //
        //     color: Theme.background

            Rectangle {
                id: dashboardSurface
                anchors.fill: parent

                color: Theme.background
                radius: 16
                topLeftRadius: 0
                topRightRadius: 0


                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    // anchors.leftMargin: 18
                    // anchors.rightMargin: 18
                    // anchors.bottomMargin: 18
                    anchors.topMargin: 0
                    spacing: 12

                    // NAVIGATION
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 38
                        spacing: 8

                        Repeater {
                            model: dashboard.pages

                            delegate: Rectangle {
                                required property int index
                                required property string modelData

                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                radius: 8
                                color: Theme.background
                                // Bottom Border
                                Rectangle {
                                  anchors {
                                    bottom: parent.bottom
                                    left: parent.left
                                    right: parent.right
                                  }
                                  height: 2
                                  color: Theme.backgroundSecondary
                                  visible: dashboard.currentPage === index
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData

                                    color: Theme.textPrimary
                                    font.pixelSize: Theme.fontLarge
                                    font.weight: Font.Medium
                                    font.family: Theme.fontFamily
                                    font.bold: dashboard.currentPage === index
                                }

                                MouseArea {
                                    anchors.fill: parent

                                    onClicked: {
                                        dashboard.currentPage = index
                                    }

                                    cursorShape: Qt.PointingHandCursor
                                }
                            }
                        }
                    }

                    // PAGE CONTENT
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Rectangle {
                            anchors.fill: parent
                            radius: 12
                            color: Theme.background

                            StackLayout {
                              anchors.fill: parent
                              // Layout.fillWidth: true
                              // Layout.fillHeight: true

                              currentIndex: dashboard.currentPage

                              Home {
                                // anchors.fill: parent
                              }
                              Kanban {
                                // anchors.fill: parent
                              }
                              Settings {
                                // anchors.fill: parent
                              }
                            }
                        }
                    }
                }
            }
        }
    }
}

