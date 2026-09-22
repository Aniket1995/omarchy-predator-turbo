import QtQuick
import qs.Commons
import qs.Ui

Column {
  id: root
  required property var panelRoot

  width: parent ? parent.width : Style.space(370)
  spacing: Style.space(8)

  PanelSectionHeader {
    text: "HARDWARE TELEMETRY"
  }

  Row {
    width: parent.width
    spacing: Style.space(12)

    // GPU Clock Card
    BorderSurface {
      width: (parent.width - Style.space(12)) / 2
      implicitHeight: Style.space(80)
      radius: Style.cornerRadius
      color: Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.04)
      borderSpec: Border.surfaceSpec("panels", "border", Color.popups.border, 1)

      Column {
        anchors.centerIn: parent
        spacing: Style.space(3)

        Row {
          anchors.horizontalCenter: parent.horizontalCenter
          spacing: Style.space(4)
          Text {
            text: "\uf108"
            font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
            font.pixelSize: Style.font.caption
            color: Color.accent
          }
          Text {
            text: "GPU CLOCK"
            font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
            font.pixelSize: Style.font.caption
            font.bold: true
            color: Qt.darker(root.panelRoot.bar ? root.panelRoot.bar.foreground : Color.foreground, 1.4)
          }
        }

        Text {
          anchors.horizontalCenter: parent.horizontalCenter
          text: root.panelRoot.gpuClockMhz + " MHz"
          font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.title
          font.bold: true
          color: root.panelRoot.bar ? root.panelRoot.bar.foreground : Color.foreground
        }

        Text {
          anchors.horizontalCenter: parent.horizontalCenter
          text: root.panelRoot.gpuTemp + "°C • " + root.panelRoot.gpuPower + "W"
          font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.caption
          color: Qt.darker(root.panelRoot.bar ? root.panelRoot.bar.foreground : Color.foreground, 1.4)
        }
      }
    }

    // CPU Clock Card
    BorderSurface {
      width: (parent.width - Style.space(12)) / 2
      implicitHeight: Style.space(80)
      radius: Style.cornerRadius
      color: Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.04)
      borderSpec: Border.surfaceSpec("panels", "border", Color.popups.border, 1)

      Column {
        anchors.centerIn: parent
        spacing: Style.space(3)

        Row {
          anchors.horizontalCenter: parent.horizontalCenter
          spacing: Style.space(4)
          Text {
            text: "\uf2db"
            font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
            font.pixelSize: Style.font.caption
            color: Color.accent
          }
          Text {
            text: "CPU FREQ"
            font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
            font.pixelSize: Style.font.caption
            font.bold: true
            color: Qt.darker(root.panelRoot.bar ? root.panelRoot.bar.foreground : Color.foreground, 1.4)
          }
        }

        Text {
          anchors.horizontalCenter: parent.horizontalCenter
          text: root.panelRoot.cpuClockGhz + " GHz"
          font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.title
          font.bold: true
          color: root.panelRoot.bar ? root.panelRoot.bar.foreground : Color.foreground
        }

        Text {
          anchors.horizontalCenter: parent.horizontalCenter
          text: "12 Threads Active"
          font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.caption
          color: Qt.darker(root.panelRoot.bar ? root.panelRoot.bar.foreground : Color.foreground, 1.4)
        }
      }
    }
  }
}
