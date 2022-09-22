import QtQuick 2.0


Item {
    id: notify_manager

    property var notifyComponent

    function showNotify(title, context, mode) {
        var toast = notifyComponent.createObject(notify_manager);
    }

    Column {
        id: layout;
        spacing: 5;
        anchors.centerIn: parent

    }

    Component.onCompleted {
    }


}
