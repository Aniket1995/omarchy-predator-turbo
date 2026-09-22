import QtQuick
import qs.Commons
import qs.Ui
import "Model.js" as Model

Column {
  id: root
  required property var panelRoot

  width: parent ? parent.width : Style.space(370)
  spacing: Style.space(8)

  PanelSectionHeader {
    text: "COOLING SYSTEM"
  }

  Row {
    width: parent.width
    spacing: Style.space(12)

    // CPU Turbine Card
    BorderSurface {
      width: (parent.width - Style.space(12)) / 2
      implicitHeight: Style.space(130)
      radius: Style.cornerRadius
      color: Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.04)
      borderSpec: Border.surfaceSpec("panels", "border", root.panelRoot.turboActive ? Qt.rgba(Color.urgent.r, Color.urgent.g, Color.urgent.b, 0.4) : Color.popups.border, 1)

      Column {
        anchors.centerIn: parent
        spacing: Style.space(5)

        PredatorTurbineGauge {
          anchors.horizontalCenter: parent.horizontalCenter
          size: Style.space(64)
          rpm: root.panelRoot.cpuFanRpm
          turboActive: root.panelRoot.turboActive
          bar: root.panelRoot.bar
        }

        Text {
          anchors.horizontalCenter: parent.horizontalCenter
          text: "CPU FAN"
          font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.caption
          font.bold: true
          color: Qt.darker(root.panelRoot.bar ? root.panelRoot.bar.foreground : Color.foreground, 1.4)
        }

        Text {
          anchors.horizontalCenter: parent.horizontalCenter
          text: Model.fanSpeedText(root.panelRoot.cpuFanRpm, root.panelRoot.turboActive)
          font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.body
          font.bold: true
          color: root.panelRoot.turboActive ? Color.urgent : (root.panelRoot.bar ? root.panelRoot.bar.foreground : Color.foreground)
        }
      }
    }

    // GPU Turbine Card
    BorderSurface {
      width: (parent.width - Style.space(12)) / 2
      implicitHeight: Style.space(130)
      radius: Style.cornerRadius
      color: Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.04)
      borderSpec: Border.surfaceSpec("panels", "border", root.panelRoot.turboActive ? Qt.rgba(Color.urgent.r, Color.urgent.g, Color.urgent.b, 0.4) : Color.popups.border, 1)

      Column {
        anchors.centerIn: parent
        spacing: Style.space(5)

        PredatorTurbineGauge {
          anchors.horizontalCenter: parent.horizontalCenter
          size: Style.space(64)
          rpm: root.panelRoot.gpuFanRpm
          turboActive: root.panelRoot.turboActive
          bar: root.panelRoot.bar
        }

        Text {
          anchors.horizontalCenter: parent.horizontalCenter
          text: "GPU FAN"
          font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.caption
          font.bold: true
          color: Qt.darker(root.panelRoot.bar ? root.panelRoot.bar.foreground : Color.foreground, 1.4)
        }

        Text {
          anchors.horizontalCenter: parent.horizontalCenter
          text: Model.fanSpeedText(root.panelRoot.gpuFanRpm, root.panelRoot.turboActive)
          font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.body
          font.bold: true
          color: root.panelRoot.turboActive ? Color.urgent : (root.panelRoot.bar ? root.panelRoot.bar.foreground : Color.foreground)
        }
      }
    }
  }
}
