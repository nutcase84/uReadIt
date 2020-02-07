import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.0 as ListItems
import "../components"
import "../models/QReddit"
import "../models/QReddit/QReddit.js" as QReddit

Page {
    id: frontpage

    property string subredditPrefix: '/r/'
    property string subreddit: ""
    property string multis: ""
    property string subredditFilter: "hot"

    header: PageHeader {
        id: pageHeader
        title: (subreddit==="" && subredditPrefix==="/r/") ? i18n.tr("Frontpage") : subredditPrefix+(subredditPrefix=="/r/"?subreddit:multis)
        leadingActionBar.actions: Action {
            id: menuAction
            iconName: "navigation-menu"
            onTriggered: {
                mainStack.push(Qt.resolvedUrl("SubredditSwitcherPage.qml"))
            }
        }
        trailingActionBar.actions: [ // about/settings/users/etc
            Action {
                    id: loginAction
                    text: i18n.tr("Login")
                    iconName: "contact"
                    visible: !uReadIt.qreddit.notifier.isLoggedIn
                    onTriggered: {
                        mainStack.push(Qt.resolvedUrl("UserAccountsPage.qml"));
                    }
                },
                Action {
                    id: inboxUnreadAction
                    text: i18n.tr("New Unread")
                    iconSource: Qt.resolvedUrl("../images/email-unread.svg")
                    visible: uReadIt.qreddit.notifier.isLoggedIn && uReadIt.qreddit.notifier.hasUnreadMessages
                    onTriggered: {
                        mainStack.push(Qt.resolvedUrl("UserMessagesPage.qml"), {'where': 'unread'});
                    }
                },
                Action {
                    id: galleryAction
                    text: i18n.tr("View as Gallery")
                    iconName: "stock_image"
                    visible: subreddit != ""
                    onTriggered: {
                        mainStack.push(Qt.resolvedUrl("SubredditGalleryPage.qml"), {'subreddit': subreddit, 'subredditFilter': subredditFilter});
                    }
                },
                Action {
                    id: inboxAction
                    text: i18n.tr("Inbox")
                    iconName: "email"
                    visible: uReadIt.qreddit.notifier.isLoggedIn && !inboxUnreadAction.visible
                    onTriggered: {
                        mainStack.push(Qt.resolvedUrl("UserMessagesPage.qml"), {'where': 'inbox'});
                    }
                },
                Action {
                    id: userAction
                    text: i18n.tr("Users")
                    iconName: "contact"
                    visible: uReadIt.qreddit.notifier.isLoggedIn
                    onTriggered: {
                        mainStack.push(Qt.resolvedUrl("UserAccountsPage.qml"));
                    }
                },
                Action {
                    id: settingsAction
                    text: i18n.tr("Settings")
                    iconName: "settings"
                    onTriggered: {
                        mainStack.push(Qt.resolvedUrl("SettingsPage.qml"));
                    }
                },
                Action {
                    id: aboutAction
                    text: i18n.tr("About")
                    iconName: "help"
                    onTriggered: {
                        mainStack.push(Qt.resolvedUrl("AboutPage.qml"));
                    }
                },
                Action {
                    id: logoutAction
                    text: i18n.tr("Logout")
                    iconName: "system-log-out"
                    visible: uReadIt.qreddit.notifier.isLoggedIn
                    onTriggered: {
                        var logoutConnObj = uReadIt.qreddit.logout();
                        logoutConnObj.onSuccess.connect(function() {
                            //postsModel.clear();
                            //postsModel.load();
                        });
                    }
                }
        ]
        extension: Sections {
            actions: [
                Action {
                    text: "Hot"
                    onTriggered: subredditFilter = "hot"
                },
                Action {
                    text: "New"
                    onTriggered: subredditFilter = "new"
                },
                Action {
                    text: "Top"
                    onTriggered: subredditFilter = "top"
                },
                Action {
                    text: "Controversial"
                    onTriggered: subredditFilter = "controversial"
                },
                Action {
                    text: "Rising"
                    onTriggered: subredditFilter = "rising"
                }
            ]
        }
    }

    Connections {
        target: uReadIt.qreddit.notifier

        onIsLoggedInChanged: {
            if (postsModel.loaded) {
                reload()
            }
            changeSubredditStateSections.selectedIndex = uReadIt.qreddit.notifier.isLoggedIn ? 0 : 1
        }

    }

    function reload() {
        postsList.clear();
        postsModel.clear();
        postsModel.load();
    }

    function refresh() {
        postsModel.startAfter = "";
        reload();
    }

    PullToRefresh {
        refreshing: postsList.isLoading
        onRefresh: frontpage.refresh()
        target: postsList
    }
    MultiColumnListView {
        id: postsList
        anchors {
            top: pageHeader.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: units.gu(1)
        }
        width: parent.width

        columns: parent.width > units.gu(50) ? parent.width / units.gu(50) : 1

        rowSpacing: units.gu(1)
        colSpacing: units.gu(1)

        balanced: true

        Behavior on contentY {
                SmoothedAnimation { duration: 500 }
        }

        SubredditListModel {
            id: postsModel
            redditObj: uReadIt.qreddit
            subreddit: frontpage.subreddit
            filter: frontpage.subredditFilter
        }
        MultisListModel {
            id: multisModel
            redditObj: uReadIt.qreddit
            multis: frontpage.multis
            filter: frontpage.subredditFilter
        }
        model: postsModel

        delegate: PostListItem {
            title: model.data.title
            thumbnail: (model.data.thumbnail != null && model.data.thumbnail != "self") ? model.data.thumbnail : ""
            author: "/r/"+model.data.subreddit
            domain: model.data.domain
            text: model.data.selftext
            score: model.data.score
            url: model.data.url
            comments: model.data.num_comments
            likes: model.data.likes
            property var postObj: new QReddit.PostObj(uReadIt.qreddit, model);

            onClicked: {
                if (model.data.is_self) {
                    mainStack.push(Qt.resolvedUrl("CommentsPage.qml"), {'postObj': model})
                } else {
                    mainStack.push(Qt.resolvedUrl("ArticlePage.qml"), {'postObj': model})
                }
            }
            onUpvoteClicked: {
                if (!uReadIt.qreddit.notifier.isLoggedIn) {
                    console.log("You can't vote when you're not logged in!");
                    return;
                }

                var voteConnObj = postObj.upvote();
                var postItem = this;
                voteConnObj.onSuccess.connect(function(response){
                    postItem.likes = model.data.likes = postObj.data.likes;
                    postItem.score = model.data.score = postObj.data.score;
                });
            }
            onDownvoteClicked: {
                if (!uReadIt.qreddit.notifier.isLoggedIn) {
                    console.log("You can't vote when you're not logged in!");
                    return;
                }
                var voteConnObj = postObj.downvote();
                var postItem = this;
                voteConnObj.onSuccess.connect(function(response){
                    postItem.likes = model.data.likes = postObj.data.likes;
                    postItem.score = model.data.score = postObj.data.score;
                });
            }
            onCommentsClicked: mainStack.push(Qt.resolvedUrl("CommentsPage.qml"), {'postObj': model})
        }

    }

    // TODO: refactor this
    Item {
        id: moreLoaderItem
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        height: units.gu(2)

        property real loadMoreLength: units.gu(0)
        property real overflow: 0
        property variant spaceRect: null

        Connections {
            target: postsList

            onAtYEndChanged: {
                var pf = postsList
                if(pf.atYEnd && !pf.atYBeginning && (pf.contentHeight >= parent.height)) {
                    moreLoaderItem.overflow = pf.contentY - pf.contentHeight + pf.height
                    if ((moreLoaderItem.overflow > moreLoaderItem.loadMoreLength) && !moreLoaderItem.spaceRect) {
                        moreLoaderItem.spaceRect = Qt.createQmlObject("import QtQuick 2.0; Item{width: 1; height: " + moreLoaderItem.loadMoreLength + "}", frontpage)
                        postsList.model.loadMore()
                    }

                } else {
                    moreLoaderItem.overflow = 0
                    moreLoaderItem.spaceRect = null
                }
            }
        }

    }
}
