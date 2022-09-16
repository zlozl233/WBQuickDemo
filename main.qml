import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0

ApplicationWindow{
    width: 640
    height: 480
    visible: true
    Grid {
        spacing: 10
        Button{
            text:"Notification"
            width:100
            height:50
            onClicked:pop.showWindow()
        }
        Button{
            text:"ToastDemo"
            width:100
            height:50
        }
    }
    WBNotifiction{
        id:pop
        // 设置初始位置,对PopWindow里面的x,y进行了覆盖
        x: get_screen_pixel(1, Screen.width) /*- get_screen_pixel(0.005, Screen.width)*/
        y: get_screen_pixel(0.05, Screen.height)
        content_pop_window:
            Rectangle{
                id:bk_rectangle
                width:300
                height:70
                radius:10
                color: Qt.rgba(0.8,0.8,0.8,0.8)
                // icon
                Image {
                    id: img
                    width: 50
                    height: 50
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin:10
                    source: "qrc:/res/cloudmusic.ico"
                    smooth: true
                    visible: true
                }

                Rectangle {
                    id: img_mask
                    width: img.width
                    height: img.height
                    radius: 10
                    color: "#FFFFFF"
                    visible: false
                }

                OpacityMask {
                    anchors.fill: img
                    source: img
                    maskSource: img_mask
                }

                // title
                Text{
                    id:title_name
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -20
                    anchors.left:img.right
                    anchors.leftMargin:10
                    font.pointSize:13
                    font.bold: true
                    text:qsTr("Music Name")
                }
                // moreMsg
                Text{
                    id:text_name
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 0
                    anchors.left:img.right
                    anchors.leftMargin:10
                    font.pointSize:11
                    text:qsTr("Player")
                }
                // time
                Text{
                    id:time_name
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 25
                    anchors.left:img.right
                    anchors.leftMargin:10
                    font.pointSize:10
                    text:qsTr("just now")
                }
                // close
                Image {
                    id:close_btn
                    width:16
                    height:16
                    anchors.top: parent.top
                    anchors.topMargin:8
                    anchors.right: parent.right
                    anchors.rightMargin:8
                    smooth: true
                    visible: true
                    asynchronous: true
                    source: "qrc:/res/close-px.svg"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: console.log(" close button is clicked")
                    }
                }
//                MouseArea{
//                    anchors.fill: parent
//                    //是否传递到被覆盖的MouseArea
//                    propagateComposedEvents: true

//                    onClicked: {
//                        console.info(" onClicked1111.....")
//                        mouse.accepted = false
//                    }
//                    onEntered: console.log(" onEntered111....")
//                }

            }
    }

    // 为了适应不同的屏幕，需要使用百分比表示
    function get_screen_pixel(percent, sum_pixel){
        return percent * sum_pixel
    }

}
