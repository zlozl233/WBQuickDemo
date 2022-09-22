import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Window 2.3

///> WBNotifiction.qml
Window{
    id: pop_window
    visible: false
    color: "transparent"
    // 透明度
    opacity: 0
    // 取消边框
    flags:Qt.FramelessWindowsHint | Qt.ToolTip
    // 设置为非模态
    modality: Qt.NonModal

    //设置初始位置(外部设置会覆盖此设置)
    x: Screen.width - content_pop_window.width
    y: 100

    //初始位置，在屏幕右下角 windows style
//    x: Screen.width - content_pop_window.width
//    y: Screen.desktopAvailableHeight - content_pop_window.height

    //根据Loader设置大小
    width: content_loader.width
    height: content_loader.height

    //设置显示内容的变量
    property alias content_pop_window:content_loader.sourceComponent
    //icon

    //显示时间
    property int displayTime: 3000;
    property int margin: 10;
    property bool isHoverd;
    property bool isShowed;

    MouseArea{
        id:content_mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            console.info(" onClicked.....")
        }
        onEntered: {
            console.info(" onEntered.....")
            isHoverd = true;
            show_timer.stop()
        }
        onExited: {
            console.info(" onExited.....")
            isHoverd = false;
            show_timer.start()
        }
    }

    //加载内容的Loader
    Loader{
        id:content_loader
        anchors.centerIn:parent
    }

    //设置出现后显示时间的计时器
    Timer{
        id:show_timer
        interval: displayTime
        repeat: true
        onTriggered:{
            console.log(" onTriggered....."+isHoverd)
            if (!isHoverd)
                hideWindow();
        }
    }

    //设置出现显示动画
    ParallelAnimation{
        id: show_anim
        //透明度动画
        NumberAnimation{
            target:pop_window
            property: "opacity"
            from:pop_window.opacity
            to: 1
            duration:800
        }
        //位置移动动画
        NumberAnimation{
            target:pop_window
            property: "x"
            //从当前值开始移动
            from: Screen.width
            to: pop_window.x - content_loader.width - margin
            duration:800
        }
        onStarted:{
            pop_window.show()
            isShowed = true
        }
        //动画结束信号
        onStopped:{
            show_timer.start()
        }
    }
    //设置关闭显示动画
    ParallelAnimation{
        id: hide_anim
        // 透明度动画
        NumberAnimation{
            target:pop_window
            property: "opacity"
            from:pop_window.opacity
            to: 0
            duration:800
        }
        //位置移动动画
        NumberAnimation{
            target:pop_window
            property: "x"
            //从当前值开始移动
            from: pop_window.x
            to: Screen.width
            duration:800
        }
        //动画结束之后关闭窗口
        onStopped:{
            show_timer.stop();
            pop_window.close();
            isShowed = false;
        }
    }

    //显示弹窗
    function showWindow(){
        if (!pop_window.isShowed)
        show_anim.start()
    }

    //隐藏弹窗
    function hideWindow(){
        show_anim.stop()
        hide_anim.start()
    }

}
