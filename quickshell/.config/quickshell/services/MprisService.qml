pragma Singleton

import Quickshell
import Quickshell.Services.Mpris

Singleton {
  id: root

  // Connected media players
  readonly property var players: Mpris.players.values

  // Select a playing player, or the first player if none are playing
  readonly property var activePlayer: {
    const playingPlayer = root.players.find(player => player.isPlaying)
    return playingPlayer ?? root.players[0] ?? null
  }

  // Player status
  readonly property bool available: activePlayer !== null
  readonly property bool isPlaying: activePlayer ? activePlayer.isPlaying : false

  // Track information
  readonly property string title: activePlayer ? activePlayer.trackTitle : "Unknwon Title"
  readonly property string artist: activePlayer ? activePlayer.trackArtist : "Unknown Artist"
  readonly property string album: activePlayer ? activePlayer.trackAlbum : ""
  readonly property string artUrl: activePlayer ? activePlayer.trackArtUrl : ""
  readonly property string playerName: activePlayer ? activePlayer.identity : ""

  // Playback information
  readonly property real position: activePlayer ? activePlayer.position : 0
  readonly property real length: activePlayer ? activePlayer.length : 0

  // Available controls
  readonly property bool canTogglePlaying: activePlayer ? activePlayer.canTogglePlaying : false
  readonly property bool canGoNext: activePlayer ? activePlayer.canGoNext : false
  readonly property bool canGoPrevious: activePlayer ? activePlayer.canGoPrevious : false

  // Playback functions
  function togglePlaying() {
      if (activePlayer && activePlayer.canTogglePlaying)
          activePlayer.togglePlaying()
  }

  function next() {
      if (activePlayer && activePlayer.canGoNext)
          activePlayer.next()
  }

  function previous() {
      if (activePlayer && activePlayer.canGoPrevious)
          activePlayer.previous()
  }

  function raisePlayer() {
      if (activePlayer && activePlayer.canRaise)
          activePlayer.raise()
  }
}
