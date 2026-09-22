import QtQuick
import qs.Commons
import qs.Ui

BorderSurface {
  id: root
  required property var panelRoot

  width: parent ? parent.width : Style.space(370)
  implicitHeight: Style.space(70)
  radius: Style.cornerRadius
  color: root.panelRoot.turboActive
    ? Qt.rgba(Color.urgent.r, Color.urgent.g, Color.urgent.b, 0.12)
    : Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.04)
  borderSpec: Border.surfaceSpec("panels", "border", root.panelRoot.turboActive ? Color.urgent : Color.popups.border, 1)

  Item {
    anchors.fill: parent
    anchors.margins: Style.space(12)

    // 1. Icon on the left
    Item {
      id: iconContainer
      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter
      width: Style.space(32)
      height: Style.space(32)

      Text {
        anchors.centerIn: parent
        text: "\uf0e7"
        font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
        font.pixelSize: Style.font.title + Style.space(2)
        color: root.panelRoot.turboActive ? Color.urgent : Color.accent
      }
    }

    // 2. Hardware Pill Toggle Switch on the right
    Item {
      id: pillSwitch
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      width: Style.space(48)
      height: Style.space(26)

      // Pill Track
      Rectangle {
        id: pillTrack
        anchors.fill: parent
        radius: height / 2
        color: root.panelRoot.turboActive
          ? Color.urgent
          : (pillMouse.containsMouse ? Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.14) : Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.08))
        border.width: 1
        border.color: root.panelRoot.turboActive
          ? Color.urgent
          : Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.22)

        Behavior on color {
          ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
        }
        Behavior on border.color {
          ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
        }

        // Sliding Knob (Thumb)
        Rectangle {
          id: pillThumb
          width: Style.space(20)
          height: Style.space(20)
          radius: height / 2
          anchors.verticalCenter: parent.verticalCenter
          x: root.panelRoot.turboActive
            ? parent.width - width - Style.space(3)
            : Style.space(3)
          color: root.panelRoot.turboActive ? "#ffffff" : (root.panelRoot.bar ? root.panelRoot.bar.foreground : Color.foreground)

          Behavior on x {
            NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
          }

          // Subtle mini lightning bolt inside knob
          Text {
            anchors.centerIn: parent
            text: "\uf0e7"
            font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
            font.pixelSize: Style.font.caption - Style.space(2)
            color: root.panelRoot.turboActive ? Color.urgent : "#101315"
          }
        }
      }

      MouseArea {
        id: pillMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.panelRoot.toggleTurbo()
      }
    }

    // 3. Text Column in the middle (bounded between icon and pill switch)
    Column {
      anchors.left: iconContainer.right
      anchors.leftMargin: Style.space(10)
      anchors.right: pillSwitch.left
      anchors.rightMargin: Style.space(12)
      anchors.verticalCenter: parent.verticalCenter
      spacing: Style.space(2)

      Text {
        width: parent.width
        elide: Text.ElideRight
        text: "TURBO OVERCLOCK"
        font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
        font.pixelSize: Style.font.body
        font.bold: true
        color: root.panelRoot.turboActive ? Color.urgent : (root.panelRoot.bar ? root.panelRoot.bar.foreground : Color.foreground)
      }

      Text {
        width: parent.width
        elide: Text.ElideRight
        text: root.panelRoot.turboActive ? "Max Fans • Overclock" : "Auto curve • Stock clocks"
        font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
        font.pixelSize: Style.font.caption
        color: Qt.darker(root.panelRoot.bar ? root.panelRoot.bar.foreground : Color.foreground, 1.4)
      }
    }
  }
}
