import QtQuick 2.0


Item {
    id: notify_manager

    property var notifyComponent
    property var screenLayout: null;
    property int layoutY: 75;

    function showNotify(title, context, mode) {
        initScreenLayout();

    }

    function initScreenLayout(){
        if(screenLayout == null){
            screenLayout = layoutComponent.createObject(parent);
            screenLayout.y = layoutY;
            screenLayout.z = 99999; //z轴
        }
    }

    //layout
    property var layoutCompnent: Component{
        id:layoutComponent
        Column{
            spacing: 10;
            width: 1000;
            // y轴动效
            move: Transition {
                NumberAnimation { properties: "y"; easing.type: Easing.OutBack; duration: 300 }
            }

            onChildrenChanged: if(children.length === 0)  destroy();
        }
    }

    Component.onCompleted {
    }

}
