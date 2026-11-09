pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  // Individual values
  readonly property int hour: clock.hours
  readonly property int minute: clock.minutes
  readonly property int second: clock.seconds

  // Date object
  readonly property string currentDate: clock.date

  // Formatted time and date properties
  readonly property string time: Qt.formatTime(clock.date, "hh:mm:ss")
  readonly property string timeShort: Qt.formatTime(clock.date, "hh:mm")
  readonly property string date: Qt.formatDateTime(clock.date, "dd/MM/yyyy")
  readonly property string day: Qt.formatDateTime(clock.date, "dddd")
  readonly property string dayShort: Qt.formatDateTime(clock.date, "dddd").substring(0, 3)
  
  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}
