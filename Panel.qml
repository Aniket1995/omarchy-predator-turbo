import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui
import "Model.js" as Model

Panel {
  id: root
  moduleName: "local.predator"
  ipcTarget: "local.predator"

  // Critical for Bar layout: provides slot dimensions to Bar.qml
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  // Hardware telemetry state
  property bool turboActive: false
  property int cpuFanRpm: 0
  property int gpuFanRpm: 0
  property int gpuClockMhz: 300
  property int gpuMemMhz: 405
  property int gpuTemp: 45
  property string gpuPower: "5.0"
  property string gpuName: "GeForce RTX 2060"
  property string cpuClockGhz: "4.00"

  readonly property string dataScript: Qt.resolvedUrl("bin/predator-data").toString().replace(/^file:\/\//, "")

  function toggleTurbo() {
    // Instant optimistic update for responsiveness
    root.turboActive = !root.turboActive
    Util.execDetached(dataScript + " --toggle")
    refreshTimer.interval = 400
    refreshTimer.restart()
  }

  function handleTelemetry(rawText) {
    var data = Model.parseTelemetry(rawText)
    if (!data) return
    root.turboActive = data.turbo === true
    root.cpuFanRpm = Number(data.cpu_fan_rpm) || 0
    root.gpuFanRpm = Number(data.gpu_fan_rpm) || 0
    root.gpuClockMhz = Number(data.gpu_mhz) || 0
    root.gpuMemMhz = Number(data.gpu_mem_mhz) || 0
    root.gpuTemp = Number(data.gpu_temp) || 0
    root.gpuPower = String(data.gpu_power || "0")
    if (data.gpu_name) root.gpuName = String(data.gpu_name)
    if (data.cpu_ghz) root.cpuClockGhz = String(data.cpu_ghz)
  }

  function fetchTelemetry() {
    if (!telemetryProc.running) {
      telemetryProc.running = true
    }
  }

  // Telemetry fetching process
  Process {
    id: telemetryProc
    command: [root.dataScript]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.handleTelemetry(text)
    }
  }

  // Polling timer: 1.2s when open, 3.5s when idle
  Timer {
    id: refreshTimer
    interval: root.opened ? 1200 : 3500
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      interval = root.opened ? 1200 : 3500
      root.fetchTelemetry()
    }
  }

  onOpenedChanged: {
    if (root.opened) {
      root.fetchTelemetry()
    }
  }

  // ---------- Status Bar Button ----------
  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    slotSize: Style.bar.iconSlot
    tooltipText: root.turboActive ? "Acer Predator: TURBO ON" : "Acer Predator: Normal"

    iconComponent: Component {
      Item {
        anchors.fill: parent

        Image {
          id: emblem
          anchors.centerIn: parent
          width: Style.space(16)
          height: Style.space(16)
          source: root.turboActive ? Qt.resolvedUrl("assets/predator_red.png") : Qt.resolvedUrl("assets/predator_white.png")
          fillMode: Image.PreserveAspectFit
          smooth: true
          mipmap: true
          opacity: root.turboActive ? 1.0 : 0.88
        }

        // Active Turbo indicator line
        Rectangle {
          visible: root.turboActive
          anchors.bottom: parent.bottom
          anchors.horizontalCenter: parent.horizontalCenter
          width: Style.space(8)
          height: Style.space(2)
          radius: 1
          color: Color.urgent
        }
      }
    }

    onPressed: function(b) {
      if (b === Qt.RightButton) {
        root.toggleTurbo()
      } else {
        root.toggle()
      }
    }
  }

  // ---------- Popup Panel ----------
  KeyboardPanel {
    id: panel
    anchorItem: button
    owner: root
    bar: root.bar
    open: root.opened
    focusTarget: keyCatcher
    contentWidth: panel.fittedContentWidth(Style.space(370))
    contentHeight: panel.fittedContentHeight(contentColumn.implicitHeight)

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }

      Column {
        id: contentColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: Style.space(14)

        // 1. Big Predator Logo & Banner
        PredatorHero {
          panelRoot: root
        }

        PanelSeparator { width: parent.width }

        // 2. Turbo Mode Toggle Switch
        PredatorTurboCard {
          panelRoot: root
        }

        PanelSeparator { width: parent.width }

        // 3. Live Fan Speeds & Smooth Spinning Animations
        PredatorCoolingCard {
          panelRoot: root
        }

        PanelSeparator { width: parent.width }

        // 4. GPU & CPU Hardware Telemetry
        PredatorTelemetryCard {
          panelRoot: root
        }
      }
    }
  }
}
