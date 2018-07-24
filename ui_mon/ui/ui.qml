/****************************************************************************
**
** Copyright (C) 2014 Alexander Rössler
** License: LGPL version 2.1
**
** This file is part of QtQuickVcp.
**
** All rights reserved. This program and the accompanying materials
** are made available under the terms of the GNU Lesser General Public License
** (LGPL) version 2.1 which accompanies this distribution, and is available at
** http://www.gnu.org/licenses/lgpl-2.1.html
**
** This library is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
** Lesser General Public License for more details.
**
** Contributors:
** Alexander Rössler @ The Cool Tool GmbH <mail DOT aroessler AT gmail DOT com>
**
****************************************************************************/
import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.4
import Machinekit.Controls 1.0
import Machinekit.HalRemote.Controls 1.0
import Machinekit.HalRemote 1.0
import Machinekit.Application.Controls 1.0
import QtQuick.Layouts 1.3

HalApplicationWindow {
    id: main

    name: "ui_mon"
    color: "#678f8f"
    border.width: 0
    title: qsTr("Krosnių stebėjimas")

    function itemIndex(item) {
        if (item.parent === null)
            return -1
        var siblings = item.parent.children
        for (var i = 0; i < siblings.length; i++)
            if (siblings[i] === item)
                return i
        return -1 //will never happen
    }

    Item { // Configuration
        id: c
        property int kiln: 1 // kiln number
        property int pts: 10 // point count
        property real maxX: 168
        property real stepX: 0.25
        property int decDx: 2
        property int decX: 2
        property real maxY: 1100
        property real stepY: 10
        property int decY: 0
        property int fs: Math.min(38, main.width / 50) // fontsize
        property int gwidth: testlabel.width
        Label {
            id: testlabel
            visible: false
            text: qsTr("dav.") + " 2"
        }
    }

    ColumnLayout {
        id: col1
        anchors.fill: parent

        RowLayout {
            id: row1
            spacing: 10
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.fillWidth: false
            Label {
                text: qsTr("Rodyti krosnis:")
                smooth: false
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                Layout.fillWidth: true
            }
                // Identical below vvv
            CheckBox {
                text: itemIndex(this)
                smooth: false
                checked: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                Layout.fillWidth: true
                onCheckedChanged: {
                    col1.children[itemIndex(this)].visible = checked
                }
            }
            CheckBox {
                text: itemIndex(this)
                smooth: false
                checked: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                Layout.fillWidth: true
                onCheckedChanged: {
                    col1.children[itemIndex(this)].visible = checked
                }
            }
            CheckBox {
                text: itemIndex(this)
                smooth: false
                checked: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                Layout.fillWidth: true
                onCheckedChanged: {
                    col1.children[itemIndex(this)].visible = checked
                }
            }
            // Identical above ^^^
        }
        // Identical below vvv

        ColumnLayout {
            property int i: itemIndex(this)
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 5

            GridLayout {
                rows: 3
                flow: GridLayout.TopToBottom
                Layout.fillHeight: true
                Layout.fillWidth: true

                RowLayout {
                    Layout.fillWidth: true

                    Label { // Kiln number
                        text: "" + parent.parent.parent.i
                        font.pointSize: 16
                    }
                    HalLed {
                        name: "k" + parent.parent.parent.i + "_comm_ok"
                        onColor: "green"
                        smooth: false
                    }
                    Label {
                        text: qsTr("ryšys ")
                    }
                    Item{
                        Layout.fillWidth: true
                    }
                    HalLed {
                        name: "k" + parent.parent.parent.i + "_runs"
                        onColor: "orange"
                        smooth: false
                    }
                    Label {
                        text: qsTr("programa")
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }
                    Item{
                        Layout.fillWidth: true
                    }
                    Label {
                        text: qsTr("Galia:")
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    }
                }
                LogChart {
                    value: parent.children[itemIndex(this) + 3].value
                    smooth: false
                    leftTextVisible: false
                    decimals: 1
                    changeGraphEnabled: true
                    autoSampling: true
                    maximumValue: c.maxY
                    rightTextVisible: false
                    suffix: "°C"
                    yGrid: 100
                    xGrid: 3600000
                    timeSpan: 3600000
                    sampleInterval: 10000
                    maximumLogSize: 7200
                    targetValue: 1000
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
                RowLayout {
                    Layout.fillWidth: true
                    Label {
                        text: qsTr("Laikas t, h")
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                    HalLabel {
                        name: "k" + parent.parent.parent.i + "_duration"
                        prefix: "Programos trukmė: "
                        wrapMode: Text.WordWrap
                        decimals: c.decX
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                    }
                    HalLabel {
                        name: "k" + parent.parent.parent.i + "_elapsed"
                        prefix: "Praėjęs laikas: "
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignRight
                    }
                }

                HalGauge {
                    name: "k" + parent.parent.i + "_op1"
                    suffix: "%"
                    minimumValueVisible: false
                    maximumValueVisible: false
                    implicitWidth: c.gwidth
                    smooth: false
                    decimals: 0
                    fancy: false
                    maximumValue: 100
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_pv1"
                    maximumValueVisible: false
                    minimumValueVisible: false
                    smooth: false
                    decimals: 0
                    Layout.fillHeight: true
                    implicitWidth: c.gwidth
                    fancy: true
                    z0BorderValue: 200
                    z1BorderValue: 600
                    maximumValue: c.maxY
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("dav.") + " 1"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }

                HalGauge {
                    name: "k" + parent.parent.i + "_op2"
                    suffix: "%"
                    minimumValueVisible: false
                    maximumValueVisible: false
                    implicitWidth: c.gwidth
                    smooth: false
                    decimals: 0
                    fancy: false
                    maximumValue: 100
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_pv2"
                    maximumValueVisible: false
                    minimumValueVisible: false
                    smooth: false
                    decimals: 0
                    Layout.fillHeight: true
                    implicitWidth: c.gwidth
                    fancy: true
                    z0BorderValue: 200
                    z1BorderValue: 600
                    maximumValue: c.maxY
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("dav.") + " 2"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }

                Label {
                    text: qsTr("°C")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVBottom
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_sp"
                    minimumValueVisible: false
                    maximumValueVisible: false
                    smooth: false
                    decimals: 0
                    Layout.fillHeight: true
                    invert: false
                    implicitWidth: c.gwidth
                    minimumValue: 0
                    maximumValue: c.maxY
                    fancy: false
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("Užduota")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }
            }
        }

        ColumnLayout {
            property int i: itemIndex(this)
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 5

            GridLayout {
                rows: 3
                flow: GridLayout.TopToBottom
                Layout.fillHeight: true
                Layout.fillWidth: true

                RowLayout {
                    Layout.fillWidth: true

                    Label { // Kiln number
                        text: "" + parent.parent.parent.i
                        font.pointSize: 16
                    }
                    HalLed {
                        name: "k" + parent.parent.parent.i + "_comm_ok"
                        onColor: "green"
                        smooth: false
                    }
                    Label {
                        text: qsTr("ryšys ")
                    }
                    Item{
                        Layout.fillWidth: true
                    }
                    HalLed {
                        name: "k" + parent.parent.parent.i + "_runs"
                        onColor: "orange"
                        smooth: false
                    }
                    Label {
                        text: qsTr("programa")
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }
                    Item{
                        Layout.fillWidth: true
                    }
                    Label {
                        text: qsTr("Galia:")
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    }
                }
                LogChart {
                    value: parent.children[itemIndex(this) + 3].value
                    smooth: false
                    leftTextVisible: false
                    decimals: 1
                    changeGraphEnabled: true
                    autoSampling: true
                    maximumValue: c.maxY
                    rightTextVisible: false
                    suffix: "°C"
                    yGrid: 100
                    xGrid: 3600000
                    timeSpan: 3600000
                    sampleInterval: 10000
                    maximumLogSize: 7200
                    targetValue: 1000
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
                RowLayout {
                    Layout.fillWidth: true
                    Label {
                        text: qsTr("Laikas t, h")
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                    HalLabel {
                        name: "k" + parent.parent.parent.i + "_duration"
                        prefix: "Programos trukmė: "
                        wrapMode: Text.WordWrap
                        decimals: c.decX
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                    }
                    HalLabel {
                        name: "k" + parent.parent.parent.i + "_elapsed"
                        prefix: "Praėjęs laikas: "
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignRight
                    }
                }

                HalGauge {
                    name: "k" + parent.parent.i + "_op1"
                    suffix: "%"
                    minimumValueVisible: false
                    maximumValueVisible: false
                    implicitWidth: c.gwidth
                    smooth: false
                    decimals: 0
                    fancy: false
                    maximumValue: 100
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_pv1"
                    maximumValueVisible: false
                    minimumValueVisible: false
                    smooth: false
                    decimals: 0
                    Layout.fillHeight: true
                    implicitWidth: c.gwidth
                    fancy: true
                    z0BorderValue: 200
                    z1BorderValue: 600
                    maximumValue: c.maxY
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("dav.") + " 1"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }

                HalGauge {
                    name: "k" + parent.parent.i + "_op2"
                    suffix: "%"
                    minimumValueVisible: false
                    maximumValueVisible: false
                    implicitWidth: c.gwidth
                    smooth: false
                    decimals: 0
                    fancy: false
                    maximumValue: 100
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_pv2"
                    maximumValueVisible: false
                    minimumValueVisible: false
                    smooth: false
                    decimals: 0
                    Layout.fillHeight: true
                    implicitWidth: c.gwidth
                    fancy: true
                    z0BorderValue: 200
                    z1BorderValue: 600
                    maximumValue: c.maxY
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("dav.") + " 2"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }

                Label {
                    text: qsTr("°C")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVBottom
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_sp"
                    minimumValueVisible: false
                    maximumValueVisible: false
                    smooth: false
                    decimals: 0
                    Layout.fillHeight: true
                    invert: false
                    implicitWidth: c.gwidth
                    minimumValue: 0
                    maximumValue: c.maxY
                    fancy: false
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("Užduota")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }
            }
        }

        ColumnLayout {
            property int i: itemIndex(this)
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 5

            GridLayout {
                rows: 3
                flow: GridLayout.TopToBottom
                Layout.fillHeight: true
                Layout.fillWidth: true

                RowLayout {
                    Layout.fillWidth: true

                    Label { // Kiln number
                        text: "" + parent.parent.parent.i
                        font.pointSize: 16
                    }
                    HalLed {
                        name: "k" + parent.parent.parent.i + "_comm_ok"
                        onColor: "green"
                        smooth: false
                    }
                    Label {
                        text: qsTr("ryšys ")
                    }
                    Item{
                        Layout.fillWidth: true
                    }
                    HalLed {
                        name: "k" + parent.parent.parent.i + "_runs"
                        onColor: "orange"
                        smooth: false
                    }
                    Label {
                        text: qsTr("programa")
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }
                    Item{
                        Layout.fillWidth: true
                    }
                    Label {
                        text: qsTr("Galia:")
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    }
                }
                LogChart {
                    value: parent.children[itemIndex(this) + 3].value
                    smooth: false
                    leftTextVisible: false
                    decimals: 1
                    changeGraphEnabled: true
                    autoSampling: true
                    maximumValue: c.maxY
                    rightTextVisible: false
                    suffix: "°C"
                    yGrid: 100
                    xGrid: 3600000
                    timeSpan: 3600000
                    sampleInterval: 10000
                    maximumLogSize: 7200
                    targetValue: 1000
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
                RowLayout {
                    Layout.fillWidth: true
                    Label {
                        text: qsTr("Laikas t, h")
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                    HalLabel {
                        name: "k" + parent.parent.parent.i + "_duration"
                        prefix: "Programos trukmė: "
                        wrapMode: Text.WordWrap
                        decimals: c.decX
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                    }
                    HalLabel {
                        name: "k" + parent.parent.parent.i + "_elapsed"
                        prefix: "Praėjęs laikas: "
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignRight
                    }
                }

                HalGauge {
                    name: "k" + parent.parent.i + "_op1"
                    suffix: "%"
                    minimumValueVisible: false
                    maximumValueVisible: false
                    implicitWidth: c.gwidth
                    smooth: false
                    decimals: 0
                    fancy: false
                    maximumValue: 100
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_pv1"
                    maximumValueVisible: false
                    minimumValueVisible: false
                    smooth: false
                    decimals: 0
                    Layout.fillHeight: true
                    implicitWidth: c.gwidth
                    fancy: true
                    z0BorderValue: 200
                    z1BorderValue: 600
                    maximumValue: c.maxY
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("dav.") + " 1"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }

                HalGauge {
                    name: "k" + parent.parent.i + "_op2"
                    suffix: "%"
                    minimumValueVisible: false
                    maximumValueVisible: false
                    implicitWidth: c.gwidth
                    smooth: false
                    decimals: 0
                    fancy: false
                    maximumValue: 100
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_pv2"
                    maximumValueVisible: false
                    minimumValueVisible: false
                    smooth: false
                    decimals: 0
                    Layout.fillHeight: true
                    implicitWidth: c.gwidth
                    fancy: true
                    z0BorderValue: 200
                    z1BorderValue: 600
                    maximumValue: c.maxY
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("dav.") + " 2"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }

                Label {
                    text: qsTr("°C")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVBottom
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_sp"
                    minimumValueVisible: false
                    maximumValueVisible: false
                    smooth: false
                    decimals: 0
                    Layout.fillHeight: true
                    invert: false
                    implicitWidth: c.gwidth
                    minimumValue: 0
                    maximumValue: c.maxY
                    fancy: false
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("Užduota")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }
            }
        }
        // Identical above ^^^
    }    
    Button {
        text: qsTr("grįžti")
        anchors.rightMargin: 5
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 5
        onClicked: {
            main.disconnect()
        }
        style: ButtonStyle {
            label: Text {
                renderType: Text.NativeRendering
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
//                font.pixelSize: c.fs
                text: control.text
            }
        }
    }
}
