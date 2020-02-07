import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItems
import "../components"
import "../models/QReddit"
import "../models/QReddit/QReddit.js" as QReddit

Page {
    id: subredditSwitcherPage

    header: PageHeader {
        id: pageHeader
        contents: TextField {
            id: subredditField
            placeholderText: "Frontpage"
            anchors.centerIn: parent
            width: parent.width - units.gu(2)
            text: frontpage.subreddit
            inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
            onAccepted: confirmChangeAction.triggered(subredditField)
            onTextChanged: {
                subredditsList.subredditSearch = text;
            }
        }
        leadingActionBar.actions: Action {
            id: cancelAction
            iconName: "close"
            onTriggered: {
                mainStack.pop()
            }
        }
        extension: Sections {
            actions: [
                Action {
                    text: "Defaults"
                    onTriggered: subredditsList.subredditSource = "subreddits_default"
                },
                Action {
                    text: "Search"
                    onTriggered: subredditsList.subredditSource = "subreddits_search"
                },
                Action {
                    text: "My Subscriptions"
                    onTriggered: subredditsList.subredditSource = "subreddits_mine subscriber"
                    visible: uReadIt.qreddit.notifier.isLoggedIn
                }
            ]
        }
    }

    UbuntuListView {
        id: subredditsList
        anchors {
            top: pageHeader.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        property string subredditSource: ""
        property string subredditSearch: subredditField.text

        model: null
        onSubredditSourceChanged: {
            subredditsList.model = null
            if (subredditsList.subredditSource == "subreddits_search") {
                var subsrConnObj = uReadIt.qreddit.getAPIConnection(subredditsList.subredditSource, {q: subredditsList.subredditSearch});
                subsrConnObj.onConnection.connect(function(response){
                    subredditsList.model = response.data.children
                });
            } else {
                var subsrConnObj = uReadIt.qreddit.getAPIConnection(subredditsList.subredditSource);
                subsrConnObj.onConnection.connect(function(response){
                    subredditsList.model = response.data.children
                });
            }
        }
        onSubredditSearchChanged: {
            if (subredditsList.subredditSource == "subreddits_search") {
                var subsrConnObj = uReadIt.qreddit.getAPIConnection(subredditsList.subredditSource, {q: subredditsList.subredditSearch});
                subsrConnObj.onConnection.connect(function(response){
                    subredditsList.model = response.data.children
                });
            }
        }

        delegate: ListItems.Standard {
            text: modelData.data['display_name']
            onClicked: {
                //frontpage.postsList.clear();
                //subredditField.text = modelData.data['display_name']
                frontpage.subreddit = modelData.data['display_name']
                mainStack.pop()
            }
        }
    }
    Scrollbar {
        flickableItem: subredditsList
        align: Qt.AlignTrailing
    }

    flickable: subredditsList

}
