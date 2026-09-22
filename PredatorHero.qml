import QtQuick
import qs.Commons
import qs.Ui

Item {
  id: root
  required property var panelRoot

  width: parent ? parent.width : Style.space(370)
  implicitHeight: heroColumn.implicitHeight

  Column {
    id: heroColumn
    anchors.horizontalCenter: parent.horizontalCenter
    spacing: Style.space(8)

    // 1. Predator Logo (White in normal mode, Fiery Red when Turbo is Active)
    Image {
      id: bigLogo
      anchors.horizontalCenter: parent.horizontalCenter
      width: Style.space(72)
      height: Style.space(72)
      source: root.panelRoot.turboActive
        ? Qt.resolvedUrl("assets/predator_red_highres.png")
        : Qt.resolvedUrl("assets/predator_white_highres.png")
      fillMode: Image.PreserveAspectFit
      smooth: true
      mipmap: true
    }

    // 2. Predator Wordmark (standalone razor-sharp high-res asset)
    Image {
      id: predatorWordmark
      anchors.horizontalCenter: parent.horizontalCenter
      width: Style.space(136)
      height: Style.space(20)
      source: Qt.resolvedUrl("assets/predator_text_highres.png")
      fillMode: Image.PreserveAspectFit
      smooth: true
      mipmap: true
    }

    // 3. Profile Status Subtitle
    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      text: root.panelRoot.turboActive ? "TURBO MODE ACTIVE • MAXIMUM PERFORMANCE" : "NORMAL PROFILE • HARDWARE AUTOMATIC"
      font.family: root.panelRoot.bar ? root.panelRoot.bar.fontFamily : Style.font.family
      font.pixelSize: Style.font.caption
      font.bold: true
      color: root.panelRoot.turboActive ? Color.urgent : Color.accent
      opacity: 0.95
    }
  }
}
