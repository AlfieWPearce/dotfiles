pragma Singleton

import Quickshell
import Quickshell.Services.UPower
import Quickshell.Networking
import Quickshell.Bluetooth
import Quickshell.Services.Pipewire

Singleton {
    id: root

    // Configuration
    readonly property int batteryCriticalThreshold: 20
    readonly property int batteryWarningThreshold: 40
    readonly property int batteryChargingLimit: 80

    // Battery
    readonly property var batteryDevice: UPower.displayDevice

    readonly property bool batteryAvailable:
        batteryDevice !== null
        && batteryDevice.ready
        && batteryDevice.isLaptopBattery
        && batteryDevice.isPresent

    // UPower reports percentage as a 0.0 - 1.0 value.
    readonly property int batteryPercentage:
        batteryAvailable
            ? Math.round(batteryDevice.percentage * 100)
            : 0

    readonly property bool batteryCharging:
        batteryAvailable
        && batteryDevice.state === UPowerDeviceState.Charging

    readonly property bool batteryLow:
        batteryAvailable
        && batteryPercentage <= batteryWarningThreshold

    readonly property bool batteryCritical:
        batteryAvailable
        && batteryPercentage <= batteryCriticalThreshold

    readonly property bool batteryPercentVisible:
        batteryAvailable
        && (
            batteryLow
            || (
                batteryCharging
                && batteryPercentage < batteryChargingLimit
            )
        )

    readonly property string batteryTooltip: {
        if (!batteryAvailable)
            return "Battery unavailable"

        return "Battery: " + batteryPercentage + "%\n"
            + (batteryCharging ? "Charging" : "Not charging")
    }

    // Wi-Fi
    readonly property var wifiDevice:
        Networking.devices.values.find(
            device => device.type === DeviceType.Wifi
        ) ?? null

    readonly property var connectedNetwork:
        wifiDevice?.networks.values.find(
            network => network.connected
        ) ?? null

    readonly property bool wifiEnabled:
        Networking.wifiEnabled
        && Networking.wifiHardwareEnabled

    readonly property bool wifiConnected:
        wifiEnabled && connectedNetwork !== null

    readonly property string wifiName:
        connectedNetwork?.name ?? ""

    // WifiNetwork.signalStrength is 0.0 to 1.0.
    readonly property int wifiSignalStrength:
        connectedNetwork
            ? Math.round(connectedNetwork.signalStrength * 100)
            : 0

    readonly property string wifiSignalQuality: {
        if (!wifiConnected)
            return "Disconnected"

        if (wifiSignalStrength >= 80)
            return "Excellent"
        if (wifiSignalStrength >= 60)
            return "Good"
        if (wifiSignalStrength >= 40)
            return "Fair"
        if (wifiSignalStrength >= 20)
            return "Weak"

        return "Very weak"
    }

    readonly property string wifiTooltip: {
        if (!wifiEnabled)
            return "Wi-Fi disabled"

        if (!wifiConnected)
            return "Not connected to Wi-Fi"

        return "Wi-Fi - "
            + wifiName + "\n"
            + "Signal: " + wifiSignalStrength
            + " (" + wifiSignalQuality + ")"
    }
    // Bluetooth
    readonly property var bluetoothAdapter: Bluetooth.defaultAdapter

    readonly property bool bluetoothEnabled: bluetoothAdapter?.enabled ?? false

    readonly property var connectedBluetoothDevices:
        Bluetooth.devices.values.filter(
            device => device.connected
        )

    readonly property bool bluetoothConnected: connectedBluetoothDevices.length > 0

    readonly property string bluetoothTooltip: {
        if (!bluetoothEnabled)
            return "Bluetooth disabled"

        if (connectedBluetoothDevices.length === 0)
            return "Bluetooth enabled\nNo connected devices"

        return "Connected devices:\n"
            + connectedBluetoothDevices.map(
                device => device.name || device.deviceName
            ).join("\n")
    }

    // Microphone
    PwNodeLinkTracker {
        id: microphoneTracker

        node: Pipewire.defaultAudioSource
    }

    readonly property bool microphoneAvailable:
        Pipewire.ready
        && Pipewire.defaultAudioSource !== null

    readonly property bool microphoneInUse:
        microphoneAvailable
        && microphoneTracker.linkGroups.length > 0

    readonly property string microphoneTooltip:
        microphoneInUse
            ? "Microphone in use"
            : "Microphone not in use"

    // Camera
    // Look for an active PipeWire connection from a
    // hardware video source (such as a webcam).
    readonly property bool cameraInUse: {
        if (!Pipewire.ready)
            return false

        return Pipewire.linkGroups.values.some(group => {
            const source = group.source

            return source !== null
                && !source.isStream
                && (source.type & PwNodeType.VideoSource)
                    === PwNodeType.VideoSource
        })
    }

    readonly property string cameraTooltip:
        cameraInUse
            ? "Camera in use"
            : "Camera not in use"
}

