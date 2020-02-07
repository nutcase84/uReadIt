import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItems
import "../manifest.js" as Manifest

Page {
    id: aboutPage

    header: PageHeader {
        id: pageHeader
        title: i18n.tr("About")
    }

    Flickable {
        anchors {
            top: pageHeader.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: units.gu(2)
        }
        contentHeight: detailsList.height

        Column {
            id: detailsList
            width: parent.width

            UbuntuShape {
                anchors.horizontalCenter: parent.horizontalCenter
                height: units.gu(25)
                width: units.gu(25)
                radius: "medium"

                image: Image {
                    source: Qt.resolvedUrl("../images/uReadit.png")
                }
            }

            ListItems.SingleValue {
                text: i18n.tr("Name")
                value: Manifest.appData.title
            }
            ListItems.SingleValue {
                text: i18n.tr("Author")
                value: Manifest.appData.maintainer
            }
            ListItems.SingleValue {
                text: i18n.tr("Based on work done by")
                value: "Michael Hall"
            }
            ListItems.SingleValue {
                text: i18n.tr("Version")
                value: Manifest.appData.version
            }
            ListItems.SingleValue {
                text: i18n.tr("Released")
                value: Manifest.releaseDate
            }
        }
    }
}
