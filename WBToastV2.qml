import QtQuick 2.0
import QtGraphicalEffects 1.0

///WBToast.qml
Item {
    id: root
    height: 46
    width: 147
    //pos
    x: (parent.width - width) /2
    y:  0
    z: 99999

    //需要对外暴露的属性
    property alias backgroundColor: wb_toast.color
    property alias toastWidth: wb_toast.width
    property alias toastX: wb_toast.x
    property alias toastY: wb_toast.y

    property alias textColor: contentText.color
    property alias contextText: contentText.text

    property string toast_type:  "";
    property int toast_displayTime: 3000;
    property int toast_moveY: 30;

    property color shadowColor: "#D5D9DC"; //ZX021

    //api
    function show(type,text,displayTime) {
        contentText.text = text;
        root.width = contentText.contentWidth + 66;
        toast_displayTime = displayTime;
        toast_type = type;
        console.log(" type "+ type+ " text "+ text+ " displayTime "+ displayTime);
        wb_toast.hideToast();
        wb_toast.showToast();
    }

    Rectangle {
        id: wb_toast;
        height: parent.height
        width: parent.width
        //pos
        x: (parent.width - width) /2
        y:  0
        z: 99999
        radius: 30
        opacity: 0

        color: "#FFFFFF"  //ZX031
        //抗锯齿
        antialiasing: true
        //shadow
        //true: 渲染一次并缓存
        layer.enabled: true
        layer.effect: DropShadow {
            id: shadow;
            horizontalOffset: 0
            verticalOffset: 3
            radius: 6
            samples: 13
            spread: 0
            color: shadowColor
        }

        //gif
        AnimatedImage {
            id: gifIcon
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter;
            anchors.left: parent.left
            anchors.leftMargin: 20
            asynchronous: true
            source: "qrc:/res/loading.gif"
            visible: toast_type == "refersh"
        }
        Image {
            id:imgIcon
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter;
            anchors.left: parent.left
            anchors.leftMargin: 20
            source:{
                switch(toast_type){
                case "success":    return "qrc:/res/success_20_20.svg";
                case "failed":     return "qrc:/res/failed_20_20.svg";
                }
                return ""
            }
            //异步加载图片
            asynchronous: true
            //平滑处理
            smooth: true
            visible: !gifIcon.visible
        }

        Text {
            id: contentText
            color: "#181C2F" //ZX001
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            font.family: "微软雅黑"
            font.pixelSize: 14
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 0
            anchors.left:parent.left
            anchors.leftMargin:40+6
        }

        //设置出现后显示时间的计时器
        Timer{
            id:show_timer
            interval: toast_displayTime
            repeat: true
            onTriggered:{
                console.log(" show_timer onTriggered ")
                show_anim.stop()
                hide_anim.start()
            }
        }

        //设置出现显示动画
        ParallelAnimation{
            id: show_anim
            //透明度动画
            NumberAnimation{
                target:wb_toast
                property: "opacity"
                from:wb_toast.opacity
                to: 1
                duration:800
            }
            //位置移动动画
            NumberAnimation{
                target:wb_toast
                property: "y"
                //从当前值开始移动
                from: 0
                to: toast_moveY
                duration:800
            }
            //动画结束信号
            onStopped:{
                console.log(" show_anim ...."+wb_toast.width+wb_toast.height)
                show_timer.start()
            }
        }

        //设置关闭显示动画
        ParallelAnimation{
            id: hide_anim
            // 透明度动画
            NumberAnimation{
                target:wb_toast
                property: "opacity"
                from:wb_toast.opacity
                to: 0
                duration:800
            }
            //动画结束之后关闭窗口
            onStopped:{
                show_timer.stop();
            }
        }

        //显示弹窗
        function showToast(){
            show_anim.start()
        }

        //隐藏弹窗
        function hideToast(){
            show_anim.stop()
            hide_anim.start()
        }
    }
}
