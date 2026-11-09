//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import QtQuick
import Quickshell
import "modules"
import "modules/bar"
import "modules/dashboard"

ShellRoot {
    Bar {
      id: bar
      dashboardController: dashboard
    }
    Dashboard {
      id: dashboard
      anchorWindow: bar.panelWindow
    }

    QuickNote {
      anchorWindow: bar.panelWindow
    }
}
