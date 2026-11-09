import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../theme"

Scope {
    id: root

    property var anchorWindow: null
    property bool opened: false
    property string pendingText: ""
    property string errorText: ""

    property var destinations: []
    property int destinationIndex: 0

    readonly property string discoveryScript:
        "import json, re\n" +
        "from pathlib import Path\n" +
        "vault = Path.home() / 'vault'\n" +
        "files = list(vault.glob('*.md')) + list((vault / 'Kanban').glob('*.md'))\n" +
        "result = []\n" +
        "for path in sorted(set(files)):\n" +
        "    content = path.read_text(encoding='utf-8')\n" +
        "    board = re.search(r'(?m)^kanban-plugin:\\s*board\\s*$', content)\n" +
        "    if board:\n" +
        "        for heading in re.finditer(r'(?m)^##\\s+(.+?)\\s*$', content):\n" +
        "            result.append({'label': path.stem + ' → ' + heading.group(1), 'path': str(path), 'file': str(path.relative_to(vault)), 'kind': 'kanban', 'section': heading.group(1)})\n" + 
        // "            result.append({'label': path.stem + ' → ' + heading.group(1), 'path': str(path), 'kind': 'kanban', 'section': heading.group(1)})\n" +
        "    else:\n" +
        "           result.append({ 'label': str(path.relative_to(vault)), 'path': str(path), 'file': str(path.relative_to(vault)), 'kind': 'note', 'section': ''})\n" +
        // "        result.append({'label': str(path.relative_to(vault)), 'path': str(path), 'kind': 'note', 'section': ''})\n" +
        "print(json.dumps(result))"

    readonly property string writerScript:
        "import pathlib, re, sys\n" +
        "from pathlib import Path\n" +
        "kind, filename, section, content = sys.argv[1:5]\n" +
        "path = Path(filename)\n" +
        "text = path.read_text(encoding='utf-8') if path.exists() else ''\n" +
        "if kind == 'note':\n" +
        "    path.write_text(text.rstrip() + ('\\n\\n' if text.strip() else '') + content + '\\n', encoding='utf-8')\n" +
        "else:\n" +
        "    match = re.search(r'(?m)^##\\s+' + re.escape(section) + r'[ \\t]*$', text)\n" +
        "    if not match:\n" +
        "        raise SystemExit('Could not find section: ' + section)\n" +
        "    tail = text[match.end():]\n" +
        "    boundary = re.search(r'(?m)^(?:##\\s+|%%\\s*kanban:settings)', tail)\n" +
        "    pos = match.end() + (boundary.start() if boundary else len(tail))\n" +
        "    task = ' '.join(content.splitlines()).strip()\n" +
        "    entry = '\\n\\n- [ ] ### ' + task + '\\n'\n" +
        "    text = text[:pos].rstrip() + entry + text[pos:].lstrip('\\n')\n" +
        "    path.write_text(text, encoding='utf-8')"

    function open() {
        opened = true
        if (!discoveryProcess.running) discoveryProcess.running = true
    }

    function close() {
        opened = false
    }


    function save() {
        const content = noteArea.text.trim()

        if (!content.length) {
            errorText = "Nothing to save."
            return
        }

        if (writerProcess.running)
            return

        const destination = destinations[destinationIndex]

        if (!destination) {
            errorText = "No destination selected."
            return
        }

        pendingText = content
        errorText = ""

        writerProcess.command = [
            "python3",
            "-c",
            writerScript,
            destination.kind,
            destination.path,
            destination.section,
            pendingText
        ]

        writerProcess.running = true
    }

    function openSelectedInObsidian() {
        const destination = destinations[destinationIndex]

        if (!destination)
            return

        const url = "obsidian://open?vault=vault&file="
            + encodeURIComponent(destination.file)

        Qt.openUrlExternally(url)
    }

    // IPC
    IpcHandler {
        target: "quicknote"

        function open() {
            root.open()
        }

        function toggle() {
            if (!root.opened) {
                root.open()
            } else {
                root.close()
            }
        }

        function close() {
            root.close()
        }
    }

    Process {
        id: writerProcess

        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                noteArea.clear()
                root.pendingText = ""
                root.opened = false
                root.errorText = ""
            } else {
                root.errorText = "Save failed (exit code: " + exitCode + ")"
            }
        }
    }

    Process {
        id: discoveryProcess

        command: [
            "python3",
            "-c",
            root.discoveryScript
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.destinations = JSON.parse(text)
                    root.destinationIndex = 0

                    if (root.destinations.length === 0)
                        root.errorText = "No destinations found."
                } catch (error) {
                    root.errorText = "Failed to read destinations."
                    console.error(error)
                }
            }
        }
    }

    PopupWindow {
        id: popup

        anchor.window: root.anchorWindow
        anchor.rect.x: root.anchorWindow
            ? (root.anchorWindow.width - width) / 2 : 0
        anchor.rect.y: 0

        width: 540
        height: 340

        visible: root.opened
        color: "transparent"
        grabFocus: true

        onVisibleChanged: {
            if (visible) {
                noteArea.text = ""
                root.errorText = ""
                Qt.callLater(() => noteArea.forceActiveFocus())
            }
        }

        // Keyboard shortcuts
        Shortcut {
            sequence: "Escape"
            onActivated: root.close()
        }

        Shortcut {
            sequence: "Ctrl+Return"
            onActivated: root.save()
        }

        Shortcut {
            sequence: "Ctrl+Enter"
            onActivated: root.save()
        }

        Rectangle {
            anchors.fill: parent
            radius: Theme.radiusLarge
            topLeftRadius: 0
            topRightRadius: 0
            color: Theme.background
            // border.color: Theme.backgroundSecondary
            // border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 18
                spacing: 12

                // Header
                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Quick Note"
                        color: Theme.textPrimary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontLarge
                        font.bold: true
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Text {
                        text: "ESC to close"
                        color: Theme.textSecondary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSmall
                    }
                }

                ComboBox {
                    id: destinationSelector

                    Layout.fillWidth: true

                    model: root.destinations
                    textRole: "label"

                    currentIndex: root.destinationIndex

                    enabled: !writerProcess.running
                        && root.destinations.length > 0

                    onActivated: index => {
                        root.destinationIndex = index
                    }
                }

                // Editor
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    radius: Theme.radiusMedium
                    color: Theme.backgroundSecondary

                    TextArea {
                        id: noteArea

                        anchors.fill: parent
                        anchors.margins: 8

                        placeholderText: "What's on your mind?"
                        placeholderTextColor: Theme.textSecondary

                        color: Theme.textPrimary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontNormal

                        wrapMode: TextEdit.Wrap
                        selectByMouse: true

                        background: null
                    }
                }

                // Footer
                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: root.errorText || "Ctrl + Enter to save"
                        color: root.errorText
                            ? "#ff7777"
                            : Theme.textSecondary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSmall
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Button {
                        text: "Open in Obsidian"
                        enabled: root.destinations.length > 0
                        onClicked: root.openSelectedInObsidian()
                    }
                
                    Button {
                        text: "Cancel"
                        enabled: !writerProcess.running
                        onClicked: root.close()
                    }

                    Button {
                        text: writerProcess.running ? "Saving..." : "Save"

                        enabled: !writerProcess.running
                            && noteArea.text.trim().length > 0
                            && root.destinations.length > 0

                        onClicked: root.save()
                    }
                }
            }
        }
    }
}

