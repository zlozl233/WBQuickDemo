//pragma Singleton
import QtQuick 2.0

/******************************************************************************
 * Copyright(C),2022,The Webull Tech Company Ltd
 * All right reserved. See COPYRIGHT for detailed Information.
 * Contact: https://www.webull.com/
 *
 * @file       WBToast.qml
 * @version    1.0.0
 * @author     zhanglei@webull.com
 * @date       2022/09/16
 * @brief      XXXX Function
 * @history
 *
 *
 *
 *****************************************************************************/

Rectangle {
    id:wb_toast;

    property int layoutY: 75;

    function showSuccess(text,duration,moremsg){
        mcontrol.create(mcontrol.const_success,text,duration,moremsg ? moremsg : "");
    }

    function showRefresh(text,duration,moremsg){
        mcontrol.create(mcontrol.const_loading,text,duration,moremsg ? moremsg : "");
    }

    function showFailed(text,duration,moremsg){
        mcontrol.create(mcontrol.const_failed,text,duration,moremsg ? moremsg : "");
    }


    // 自定义
    function showCustom(itemcomponent,duration){
        mcontrol.createCustom(itemcomponent,duration);
    }

    property var controlObj: QtObject {
        id:mcontrol;

//        property var root_window: _root_window_;
        property var screenLayout: null;

        // 消息类型
        property string const_success:    "success";
        property string const_loading:    "loading";
        property string const_failed:     "failed";

        property string const_trade_success:    "trade_success";
        property string const_trade_loading:    "trade_loading";
        property string const_trade_failed:     "trade_failed";

        // 弹出位置 中上 中下 左上 左下 右上 右下 中中
        property string const_midmid:       "midmid";

        property int maxWidth: 300;

        function create(type,text,duration,moremsg){
            if(screenLayout){
                var last = screenLayout.getLastloader();
                if(last.type === type && last.text === text && moremsg === last.moremsg){
                    last.restart();
                    return;
                }
            }

//            initScreenLayout();
            contentComponent.createObject(screenLayout,{
                                              type:type,
                                              text:text,
                                              duration:duration,
                                              moremsg:moremsg,
                                          });
        }

        function createCustom(itemcomponent,duration){
            initScreenLayout();
            if(itemcomponent){
                contentComponent.createObject(screenLayout,{itemcomponent:itemcomponent,duration:duration});
            }
        }

        function initScreenLayout(){
            if(screenLayout == null){
                screenLayout = screenlayoutComponent.createObject(root_window);
                screenLayout.y = wb_toast.layoutY;
                screenLayout.z = 100000; //z轴
            }
        }

        //layout
        property var layoutCompnent: Component{
            id:screenlayoutComponent
            Column{
                spacing: 20;
                width: 1000;
                // y轴动效
                move: Transition {
                    NumberAnimation { properties: "y"; easing.type: Easing.OutBack; duration: 300 }
                }

                onChildrenChanged: if(children.length === 0)  destroy();

                function getLastloader(){
                    if(children.length > 0){
                        return children[children.length - 1];
                    }
                    return null;
                }
            }
        }

        //content
        property var contentComponent: Component{
            id:contentComponent
            Item{
                id:content;
                property int    duration: 3000;
                property var    itemcomponent;
                property string type;
                property string text;
                property string moremsg;

                width:  parent.width;
                height: loader.height;

                function close(){
                    content.destroy();
                }

                function restart(){
                    delayTimer.restart();
                }

                Timer {
                    id:delayTimer
                    interval: duration; running: true; repeat: true
                    onTriggered: content.close();
                }

                Loader{
                    id:loader;
                    x:(parent.width - width) / 2;
                    property var _super: content;

                    scale: item ? 1 : 0;
                    // 异步加载
                    asynchronous: true
                    // 逐渐放大动画
                    Behavior on scale {
                        NumberAnimation {
                            easing.type: Easing.OutBack;
                            duration: 100
                        }
                    }

                    sourceComponent:itemcomponent ? itemcomponent : mcontrol.wbtoast_sytle;
                }

            }
        }

        // -- WBToast TMessage style
        property Component wbtoast_sytle:  Rectangle{
            id:rect;
            width:  rowlayout.width  + (_super.moremsg ? 25 : 80);
            height: rowlayout.height + 20;

            property color bg_color: "#FFFFFF";
            property color fg_color: "#181C2F";

            //bg
            color: {
                return bg_color
            }
            radius: 4;

//            border.width: 1;
//            border.color: Qt.lighter(ticon.color,1.2);

            Row{
                id:rowlayout
                x:20;
                y:(parent.height - height) / 2;
                spacing: 10
                Image{
                    id:ticon
                    anchors.verticalCenter: parent.verticalCenter;
                    source:{
                        switch(_super.type){
                            case mcontrol.const_success:    return "qrc:/res/success_20_20.svg";
                            case mcontrol.const_failed:     return "qrc:/res/failed_20_20.svg";
                            case mcontrol.const_loading:    return "qrc:/res/loading.gif";
                        }
                        return ""
                    }

                    width:  more.visible ? 40 : 22;
                    height: more.visible ? 40 : 22;
                }

                Column{
                    spacing: 5;
                    Text{
                        font.bold:more.visible
                        font.pixelSize: 20;
                        text: _super.text
                        color: fg_color;
                    }
                    Text{
                        id:more
                        color:    fg_color;
                        text:    _super.moremsg;
                        visible: _super.moremsg;
                        wrapMode : Text.WordWrap

                        onContentWidthChanged: {
                            width = contentWidth < mcontrol.maxWidth - 100 ? 220 : mcontrol.maxWidth;
                        }
                    }
                }
            }

             //close btn
            TIconButton{
                icon.width:  12;
                icon.height: 12;
                y:4; x:parent.width - width
                icon.type: TIconType.SVG;
                icon.position: TPosition.Only;
                icon.source: "qrc:/net.toou.2d/resource/svg/close-px.svg"
                icon.color:"#ADADAD";
                backgroundComponent: null;
                onClicked: _super.close();
            }

        }
        //style....end
    }
}
