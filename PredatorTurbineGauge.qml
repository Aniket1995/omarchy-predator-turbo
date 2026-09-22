import QtQuick
import qs.Commons
import qs.Ui
import "Model.js" as Model

Item {
  id: root

  property int rpm: 0
  property bool turboActive: false
  property var bar: null
  property real size: Style.space(64)

  width: root.size
  height: root.size

  onRpmChanged: arcCanvas.requestPaint()
  onTurboActiveChanged: arcCanvas.requestPaint()

  // 1. Cyber Tachometer Arc Gauge
  Canvas {
    id: arcCanvas
    anchors.fill: parent
    antialiasing: true

    onPaint: {
      var ctx = getContext("2d");
      ctx.clearRect(0, 0, width, height);

      var cx = width / 2;
      var cy = height / 2;
      var radius = (width / 2) - Style.space(3);
      var lineWidth = Style.space(2.5);

      // 270 degree arc from 135 deg to 405 deg
      var startAngle = 0.75 * Math.PI;
      var totalSweep = 1.5 * Math.PI;
      var endAngle = startAngle + totalSweep;

      // Outer guide / background track
      ctx.beginPath();
      ctx.arc(cx, cy, radius, startAngle, endAngle, false);
      ctx.lineWidth = lineWidth;
      ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.08);
      ctx.lineCap = "round";
      ctx.stroke();

      // Active RPM Arc
      var percent = Model.fanRpmPercent(root.rpm, root.turboActive);
      var activeEnd = startAngle + (totalSweep * percent);

      ctx.beginPath();
      ctx.arc(cx, cy, radius, startAngle, activeEnd, false);
      ctx.lineWidth = lineWidth;
      ctx.strokeStyle = root.turboActive ? "#ff2a44" : Color.accent;
      ctx.lineCap = "round";
      ctx.stroke();
    }
  }

  // 2. Turbine Shroud Inset Housing
  Rectangle {
    anchors.fill: parent
    anchors.margins: Style.space(6)
    radius: width / 2
    color: Qt.rgba(0, 0, 0, 0.3)
    border.width: 1
    border.color: root.turboActive
      ? Qt.rgba(Color.urgent.r, Color.urgent.g, Color.urgent.b, 0.45)
      : Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.12)
  }

  // 3. Layer 1: Aerodynamic Flow Streaks / Motion Blur Trail
  Item {
    id: blurRotor
    anchors.centerIn: parent
    width: parent.width - Style.space(16)
    height: width
    transformOrigin: Item.Center
    opacity: root.turboActive ? 0.38 : 0.20

    Repeater {
      model: 8
      Item {
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        rotation: index * 45 + 14

        Rectangle {
          anchors.horizontalCenter: parent.horizontalCenter
          y: Style.space(2)
          width: Style.space(5)
          height: parent.height / 2 - Style.space(5)
          radius: 2
          rotation: -25
          color: root.turboActive ? "#ff5252" : Color.accent
        }
      }
    }

    RotationAnimation {
      target: blurRotor
      from: 0
      to: 360
      duration: Math.max(160, Model.fanRotationDuration(root.rpm, root.turboActive) * 0.88)
      loops: Animation.Infinite
      running: true
    }
  }

  // 4. Layer 2: Precision Aerodynamic Stator Blades (8 Blades)
  Item {
    id: turbineRotor
    anchors.centerIn: parent
    width: parent.width - Style.space(18)
    height: width
    transformOrigin: Item.Center

    Repeater {
      model: 8
      Item {
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        rotation: index * 45

        Rectangle {
          anchors.horizontalCenter: parent.horizontalCenter
          y: Style.space(2)
          width: Style.space(4)
          height: parent.height / 2 - Style.space(5)
          radius: 2
          rotation: -18
          color: root.turboActive
            ? (index % 2 === 0 ? "#ff2a44" : "#ff5e72")
            : (index % 2 === 0 ? Color.accent : Qt.lighter(Color.accent, 1.25))
        }
      }
    }

    RotationAnimation {
      target: turbineRotor
      from: 0
      to: 360
      duration: Model.fanRotationDuration(root.rpm, root.turboActive)
      loops: Animation.Infinite
      running: true
    }
  }

  // 5. Expanding Heat-Flare Shockwave Ring (Turbo Only)
  Rectangle {
    id: flareRing
    anchors.centerIn: parent
    width: Style.space(26)
    height: Style.space(26)
    radius: width / 2
    visible: root.turboActive
    color: "transparent"
    border.width: 1.5
    border.color: Color.urgent

    SequentialAnimation on scale {
      loops: Animation.Infinite
      running: root.turboActive
      NumberAnimation { from: 0.8; to: 1.5; duration: 450; easing.type: Easing.OutQuad }
    }
    SequentialAnimation on opacity {
      loops: Animation.Infinite
      running: root.turboActive
      NumberAnimation { from: 0.85; to: 0.0; duration: 450; easing.type: Easing.OutQuad }
    }
  }

  // 6. Center Jet Engine Spinner Hub
  Rectangle {
    anchors.centerIn: parent
    width: Style.space(18)
    height: Style.space(18)
    radius: width / 2
    color: "#0e1216"
    border.width: 1
    border.color: root.turboActive
      ? Color.urgent
      : Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.28)
  }

  // 7. Pulsating Energy Core Jewel
  Rectangle {
    id: energyCore
    anchors.centerIn: parent
    width: Style.space(8)
    height: Style.space(8)
    radius: width / 2
    color: root.turboActive ? "#ff2a44" : Color.accent

    SequentialAnimation on scale {
      loops: Animation.Infinite
      running: true
      NumberAnimation { from: 0.8; to: 1.35; duration: root.turboActive ? 320 : 850; easing.type: Easing.InOutQuad }
      NumberAnimation { from: 1.35; to: 0.8; duration: root.turboActive ? 320 : 850; easing.type: Easing.InOutQuad }
    }
    SequentialAnimation on opacity {
      loops: Animation.Infinite
      running: true
      NumberAnimation { from: 0.55; to: 1.0; duration: root.turboActive ? 320 : 850; easing.type: Easing.InOutQuad }
      NumberAnimation { from: 1.0; to: 0.55; duration: root.turboActive ? 320 : 850; easing.type: Easing.InOutQuad }
    }
  }

  Component.onCompleted: arcCanvas.requestPaint()
}
