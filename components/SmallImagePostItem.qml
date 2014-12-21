import QtQuick 2.0
import Ubuntu.Components 1.1

Item {
    id: postitemroot
    property string title: parent.title
    property string text: parent.text
    property string score: parent.score
    property string author: parent.author
    property string domain: parent.domain
    property string thumbnail: parent.thumbnail
    property string url: parent.url
    property string comments: parent.comments

    height: Math.max(postThumbnail.height + units.gu(2), titleLabel.height + authorLabel.height + actionsRow.height + (text == "" ? units.gu(3) : units.gu(10)))
    width: parent.width

    Rectangle {
        color: "#222222"
        anchors.fill: parent
        border.color: "#111111"
        Image {
            id: postThumbnail
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: source == "" ? 0 : units.gu(1)
            height: source == "" ? 0 : units.gu(15)
            width: source == "" ? 0 : units.gu(15)
            source: postitemroot.thumbnail

            MouseArea {
                anchors.fill: parent
                onClicked: postitemroot.parent.clicked()
            }
        }

        Label {
            id: titleLabel
            anchors.left: postThumbnail.right
            anchors.leftMargin: units.gu(1)
            anchors.right: parent.right
            y: parent.y

            fontSize: "medium"
            font.weight: Font.DemiBold
            color: UbuntuColors.warmGrey

            maximumLineCount: 3
            elide: Text.ElideRight
            wrapMode: Text.WordWrap

            text: postitemroot.title
            MouseArea {
                anchors.fill: parent
                onClicked: postitemroot.parent.clicked()
            }
        }

        Label {
            id: authorLabel
            anchors.left: postThumbnail.right
            anchors.leftMargin: units.gu(1)
            anchors.top: titleLabel.bottom
            anchors.right: domainLabel.left

            fontSize: "small"
            font.weight: Font.Light
            color: UbuntuColors.warmGrey
            elide: Text.ElideRight

            text: postitemroot.author
        }

        Label {
            id: domainLabel
            anchors.right: parent.right
            anchors.rightMargin: units.gu(1)
            anchors.top: titleLabel.bottom

            fontSize: "small"
            font.weight: Font.Light
            color: UbuntuColors.warmGrey
            text: postitemroot.domain ? "("+postitemroot.domain+")" : ""
        }

        Label {
            id: selfTextLabel
            anchors.left: postThumbnail.right
            anchors.leftMargin: units.gu(1)
            anchors.right: parent.right
            anchors.top: authorLabel.bottom
            anchors.bottom: actionsRow.top

            fontSize: "small"
            font.weight: Font.Light
            color: UbuntuColors.warmGrey

            elide: Text.ElideRight
            wrapMode: Text.WordWrap

            text: postitemroot.text
        }

        Item {
            id: actionsRow
            width: parent.width - units.gu(17)
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: units.gu(3)

            Label {
                id: scoreLabel
                text: (postitemroot.score > 0 ? "+" : "")+postitemroot.score
                x: 1*(parent.width / 4)-(parent.width / 8)-(width/2)
                color: score > 100 ? "#55AA55" : score > 10 ? "#5555AA" : UbuntuColors.warmGrey
            }
            Icon {
                x: 2*(parent.width / 4)-(parent.width / 8)-(width/2)
                source: Qt.resolvedUrl("../images/upvote.png")
                width: units.gu(2)
                height: units.gu(2)
                color: UbuntuColors.warmGrey

                MouseArea {
                    anchors.fill: parent
                    onClicked: postitemroot.parent.upvoteClicked()
                }
            }
            Icon {
                x: 3*(parent.width / 4)-(parent.width / 8)-(width/2)
                source: Qt.resolvedUrl("../images/downvote.png")
                width: units.gu(2)
                height: units.gu(2)
                color: UbuntuColors.warmGrey

                MouseArea {
                    anchors.fill: parent
                    onClicked: postitemroot.parent.downvoteClicked()
                }
            }
            BorderIcon {
                id: commentIcon
                x: 4*(parent.width / 4)-(parent.width / 8)-(width/2)
                source: Qt.resolvedUrl('../images/comment_16.png')
                width: Math.max(commentCount.width + units.gu(1), units.gu(3))
                height: units.gu(2.5)
                color: UbuntuColors.warmGrey

                border {
                    left: 8
                    right: 3
                    bottom: 4
                    top: 4
                }

                Text {
                    id: commentCount
                    text: postitemroot.comments
                    color: UbuntuColors.coolGrey
                    font.pixelSize: parent.height - units.gu(1)
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: postitemroot.parent.commentsClicked()
                }
            }
        }

    }

}
