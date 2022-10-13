import QtQuick 2.0
import QtGraphicalEffects 1.3
import QtQuick.Window 2.2

/******************************************************************************
 * All right reserved. See COPYRIGHT for detailed Information.
 * Contact: zlozl5566@163.com
 *
 * @file       WBNotification.qml
 * @version    1.0.0
 * @author     zlozl
 * @date       2022/09/22
 * @brief      XXXX Function
 * @history
 *
 *
 *
 *****************************************************************************/

//Item {
//    id: root
//    width:300
//    height:70

//    function show(title, context, mode) {
//        notifyTitle = title;
//        notifyMode = mode;
//        notifyContext = context;
//        showWindow();
//    }

//    property int margin: 10;
//    property bool isHoverd: false;
//    property bool isShowed: false;

//    property int notifyMode: 1;
//    property string notifyContext: "";
//    property string notifyTitle: "";

//    signal notifyClicked();
//    signal notifyClosed();

    /*property Component wbnotify_style: */Rectangle {
        id: notify_rect;

        function show(title, context, showtime, mode) {
            notifyTitle = title;
            notifyMode = mode;
            notifyContext = context;
            displayTime = showtime;
            showWindow();
        }

        property int margin: 10;
        property bool isHoverd: false;
        property bool isShowed: false;

        property int displayTime: 3000;
        property int notifyMode: 1;
        property string notifyContext: "";
        property string notifyTitle: "";

        signal notifyClicked();
        signal notifyClosed();

        x: Screen.width - width
        y: 100
        width:300
        height:70
        radius:10
        opacity: 0

        color: Qt.rgba(0.8,0.8,0.8,0.8) //
        //抗锯齿
        antialiasing: true

        Row {
            id: rowlayout;
            x: 10
            y: parent.Center
            spacing: 10

            Image {
                id: img_icon
                width: 50
                height: 50
                source: "qrc:/res/cloudmusic.ico"
                anchors.verticalCenter: parent.verticalCenter;
                asynchronous: true
                smooth: true
                visible: true
            }

            Column {
                spacing: 5
                Text {
                    id: title_text
                    Font {family: "微软雅黑"; pointSize: 13; bold: true}
                    text: notifyTitle
                }
                Text {
                    id: context_text
                    Font {family: "微软雅黑"; pointSize: 11}
                    text: notifyContext
                    wrapMode : Text.WordWrap
                }
                Text {
                    id: time_text
                    Font {family: "微软雅黑"; pointSize: 10}
                    text: qsTr("just now")
                }
            }
        }

        MouseArea{
            id:content_mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                console.info(" onClicked.....")
                notifyClicked();
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
                target:notify_rect
                property: "opacity"
                from:notify_rect.opacity
                to: 1
                duration:600
            }
            //位置移动动画
            NumberAnimation{
                target:notify_rect
                property: "x"
                //从当前值开始移动
                from: Screen.width
                to: notify_rect.x - width - margin
                duration:600
            }
            onStarted:{
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
                target:notify_rect
                property: "opacity"
                from:notify_rect.opacity
                to: 0
                duration:600
            }
            //位置移动动画
            NumberAnimation{
                target:notify_rect
                property: "x"
                //从当前值开始移动
                from: notify_rect.x
                to: Screen.width
                duration:600
            }
            //动画结束之后关闭窗口
            onStopped:{
                show_timer.stop();
                isShowed = false;
            }
        }

        //显示弹窗
        function showWindow(){
            show_anim.start()
        }

        //隐藏弹窗
        function hideWindow(){
            show_anim.stop()
            hide_anim.start()
        }
    }
//}
