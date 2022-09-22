import QtQuick 2.0

Item {
    id: toast_manager
    property var toastComponent

    function showToast(type,text,msleep) {
        toast_v2.show(type,text,msleep);
    }

    Component.onCompleted: Qt.createComponent("WBToastV2.qml");

    WBToastV2 {
        id: toast_v2
    }

//    Column {
//        function showToast(type,text,msleep) {
//            var toast = toastComponent.createObject(toastManager);
//            toast.show(type,text,msleep);
//        }

//        spacing: 10;
//    }
}
