import QtQuick 2.0

/******************************************************************************
 * Copyright(C),2022,The Webull Tech Company Ltd
 * All right reserved. See COPYRIGHT for detailed Information.
 * Contact: https://www.webull.com/
 *
 * @file       WBSVGIcon.qml
 * @version    1.0.0
 * @author     zhanglei@webull.com
 * @date       2022/09/16
 * @brief      svg 是一种比较流行的icon 源。
               默认是异步加载的,可提高性能。
 * @history
 *
 *
 *
 *****************************************************************************/

Item {
    id:wb_svgicon
    width:  16; height: 16;

    property bool   asynchronous : true;

    property bool   smooth: true;

    property color  color;

    property string source;

    property alias status: image.status;

    Image {
        id:image
        asynchronous: wb_svgicon.asynchronous;
        anchors.fill: wb_svgicon;
        source:  wb_svgicon.source;
        smooth: wb_svgicon.smooth
        visible: false;
        enabled: false;
    }

    ShaderEffect {
        id: shaderItem
        property variant source: image
        property color   color: wb_svgicon.color
        enabled: false;
        //加速svg渲染
        fragmentShader: "qrc:/res/close_16.svg"
        anchors.fill: parent;
        visible: wb_svgicon.status === Image.Ready;
    }
}
