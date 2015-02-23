import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Themes.Ambiance 0.1

QtObject {
    // MainView
    property color backgroundColor: '#c0ddf7'
    property color panelColor: '#FFFFFF'
    property color panelOverlay: '#EDEDED'

    // Base Text
    property color baseFontColor: '#5d5d5d'
    property color baseLinkColor: '#5d38ff'

    // Posts
    property color postItemBackgroundColor: Qt.lighter(backgroundColor, 1.5)
    property color postItemBorderColor:  Qt.darker(backgroundColor, 1.5)
    property color postItemHeaderColor: baseLinkColor
    property color postItemFontColor: baseFontColor

    // Comments
    property color commentBackgroundColorEven: Qt.lighter('#EDEDED', 1.05)
    property color commentBackgroundColorOdd: Qt.darker(commentBackgroundColorEven, 1.05)
    property color commentFontColor: baseFontColor
    property color commentLinkColor: baseLinkColor

    // Messages
    property color messageBackgroundColor: commentBackgroundColorOdd
    property color messageFontColor: baseFontColor
    property color messageLinkColor: baseLinkColor

    // Sharing
    property color shareBackgroundColor: commentBackgroundColorEven
}