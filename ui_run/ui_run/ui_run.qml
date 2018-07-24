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

    name: "ui_run"
    color: "#678f8f"
    border.width: 0
    title: qsTr("Krosnių procesų valdymas")

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
        property real maxY: 1100
        property int decY: 0
        property int decX: 2
        property int fs: Math.min(main.height * 1.8, main.width) / 56 // fontsize
        property int gwidth: testlabel.width
        property int gheight: testlabel.height
        property int maxprog: 9
        property int gaugeMinWidth: 40
        property bool fancy: true
        property color z2Color: "red"
        property color z1Color: "orange"
        property color z0Color: "deepskyblue"
        property real z1BorderValue: 600
        property real z0BorderValue: 50
        Label {
            id: testlabel
            visible: false
            text: c.maxY.toFixed(c.decY) + " 2"
        }
    }
    HalPin {
        id: k1_duration
        name: "k1_duration"
        direction: HalPin.In
        type: HalPin.Float
    }
    HalPin {
        id: k2_duration
        name: "k2_duration"
        direction: HalPin.In
        type: HalPin.Float
    }
    HalPin {
        id: k3_duration
        name: "k3_duration"
        direction: HalPin.In
        type: HalPin.Float
    }

    RowLayout {
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.bottomMargin: 5
        anchors.topMargin: 5
        anchors.fill: parent

        // Identical with #exception below vvv

        ColumnLayout {
            property int i: itemIndex(this) + 1
            width: 100
            height: 100
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                property int i: parent.i
                Label {
                    text: "Krosnis " + parent.i
                    Layout.alignment: Qt.AlignLeft
                }
                HalLed {
                    name: "k" + parent.i + "_comm_ok"
                    onColor: "#00c000"
                }
                Label {
                    text: qsTr("Ryšys")
                }
            }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                property int i: parent.i
                HalButton {
                    text: qsTr("Startuoti\nprogramą Nr.")
                    implicitHeight: c.gheight * 2.5
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    name: "k" + parent.i + "_start"
                }
                HalSpinBox {
                    name: "k" + parent.i + "_program"
                    enabled: !k1_runs.value
                    Layout.maximumWidth: c.gwidth
                    halPin.direction: HalPin.IO
                    halPin.type: HalPin.U32
                    decimals: 0
                    stepSize: 1
                    maximumValue: c.maxprog
                }
            }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                property int i: parent.i
                HalLed {
                    id: k1_runs
                    name: "k" + parent.i + "_runs"
                    onColor: "#ff8000"
                }
                Label {
                    text: qsTr("Programa")
                }
                HalLed {
                    name: "k" + parent.i + "_waiting"
                    onColor: "#0066ff"
                }
                Label {
                    text: qsTr("Laukiama\ntemp.")
                }
            }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                property int i: parent.i
                HalButton {
                    text: qsTr("Pristabdyti")
                    Layout.alignment: Qt.AlignHCenter
                    name: "k" + parent.i + "_stay"
                    checkable: true
                }
                HalButton {
                    text: qsTr("Stabdyti")
                    Layout.alignment: Qt.AlignRight
                    name: "k" + parent.i + "_stop"
                }
            }
            GridLayout {
                property int i: parent.i
                rows: 3
                flow: GridLayout.TopToBottom
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.columnSpan: 2
                Layout.alignment: Qt.AlignCenter | Qt.AlignVCenter

                Label {
                    text: qsTr("Temp., °C")
                    Layout.alignment: Qt.AlignHCenter
                    horizontalAlignment: Text.AlignHCenter
                    Layout.columnSpan: 3
                }
                HalGauge {
                    name: "k" + parent.i + "_pv1"
                    decimals: c.decY
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                    Layout.minimumWidth: c.gaugeMinWidth
                    fancy: c.fancy
                    z2Color: c.z2Color
                    z1Color: c.z1Color
                    z0Color: c.z0Color
                    z1BorderValue: c.z1BorderValue
                    z0BorderValue: c.z0BorderValue
                    maximumValue: c.maxY
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("Esama")
                    Layout.fillHeight: false
                    Layout.columnSpan: 2
                    Layout.alignment: Qt.AlignCenter
                }
                HalGauge {
                    name: "k" + parent.i + "_pv2"
                    decimals: c.decY
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                    Layout.minimumWidth: c.gaugeMinWidth
                    minimumValueVisible: false
                    maximumValueVisible: false
                    fancy: c.fancy
                    z2Color: c.z2Color
                    z1Color: c.z1Color
                    z0Color: c.z0Color
                    z1BorderValue: c.z1BorderValue
                    z0BorderValue: c.z0BorderValue
                    maximumValue: c.maxY
                    orientation: Qt.Vertical
                }
                HalGauge {
                    name: "k" + parent.i + "_sp"
                    decimals: c.decY
                    Layout.fillHeight: true
                    invert: false
                    Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                    Layout.minimumWidth: c.gaugeMinWidth
                    minimumValueVisible: false
                    maximumValueVisible: false
                    minimumValue: 0
                    maximumValue: c.maxY
                    fancy: c.fancy
                    z2Color: c.z2Color
                    z1Color: c.z1Color
                    z0Color: c.z0Color
                    z1BorderValue: c.z1BorderValue
                    z0BorderValue: c.z0BorderValue
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("Užduota")
                    Layout.alignment: Qt.AlignCenter
                }
                Label {
                    text: qsTr("Laikas,\nh")
                    horizontalAlignment: Text.AlignHCenter
                }
                HalSlider {
                    name: "k" + parent.i + "_elapsed"
                    enabled: k1_runs.value
                    property int i: parent.i
                    orientation: Qt.Vertical
                    updateValueWhileDragging: true
                    tickmarksEnabled: true
                    minimumValueVisible: false
                    maximumValueVisible: false
                    valueVisible: false
                    value: 0
                    decimals: c.decX
                    stepSize: 0.01
                    minimumValue: 0
                    maximumValue: k1_duration.value // #exception
                    Layout.fillHeight: true
                    halPin.direction: HalPin.IO
                    Label {
                        text: parent.value.toFixed(c.decX)
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.bottom
                    }
                }
            }
        }
        ColumnLayout {
            property int i: itemIndex(this) + 1
            width: 100
            height: 100
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                property int i: parent.i
                Label {
                    text: "Krosnis " + parent.i
                    Layout.alignment: Qt.AlignLeft
                }
                HalLed {
                    name: "k" + parent.i + "_comm_ok"
                    onColor: "#00c000"
                }
                Label {
                    text: qsTr("Ryšys")
                }
            }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                property int i: parent.i
                HalButton {
                    text: qsTr("Startuoti\nprogramą Nr.")
                    implicitHeight: c.gheight * 2.5
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    name: "k" + parent.i + "_start"
                }
                HalSpinBox {
                    name: "k" + parent.i + "_program"
                    enabled: !k2_runs.value
                    Layout.maximumWidth: c.gwidth
                    halPin.direction: HalPin.IO
                    halPin.type: HalPin.U32
                    decimals: 0
                    stepSize: 1
                    maximumValue: c.maxprog
                }
            }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                property int i: parent.i
                HalLed {
                    id: k2_runs
                    name: "k" + parent.i + "_runs"
                    onColor: "#ff8000"
                }
                Label {
                    text: qsTr("Programa")
                }
                HalLed {
                    name: "k" + parent.i + "_waiting"
                    onColor: "#0066ff"
                }
                Label {
                    text: qsTr("Laukiama\ntemp.")
                }
            }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                property int i: parent.i
                HalButton {
                    text: qsTr("Pristabdyti")
                    Layout.alignment: Qt.AlignHCenter
                    name: "k" + parent.i + "_stay"
                    checkable: true
                }
                HalButton {
                    text: qsTr("Stabdyti")
                    Layout.alignment: Qt.AlignRight
                    name: "k" + parent.i + "_stop"
                }
            }
            GridLayout {
                property int i: parent.i
                rows: 3
                flow: GridLayout.TopToBottom
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.columnSpan: 2
                Layout.alignment: Qt.AlignCenter | Qt.AlignVCenter

                Label {
                    text: qsTr("Temp., °C")
                    Layout.alignment: Qt.AlignHCenter
                    horizontalAlignment: Text.AlignHCenter
                    Layout.columnSpan: 3
                }

                HalGauge {
                    name: "k" + parent.i + "_pv1"
                    decimals: c.decY
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                    Layout.minimumWidth: c.gaugeMinWidth
                    fancy: c.fancy
                    z2Color: c.z2Color
                    z1Color: c.z1Color
                    z0Color: c.z0Color
                    z1BorderValue: c.z1BorderValue
                    z0BorderValue: c.z0BorderValue
                    maximumValue: c.maxY
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("Esama")
                    Layout.fillHeight: false
                    Layout.columnSpan: 2
                    Layout.alignment: Qt.AlignCenter
                }
                HalGauge {
                    name: "k" + parent.i + "_pv2"
                    decimals: c.decY
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                    Layout.minimumWidth: c.gaugeMinWidth
                    minimumValueVisible: false
                    maximumValueVisible: false
                    fancy: c.fancy
                    z2Color: c.z2Color
                    z1Color: c.z1Color
                    z0Color: c.z0Color
                    z1BorderValue: c.z1BorderValue
                    z0BorderValue: c.z0BorderValue
                    maximumValue: c.maxY
                    orientation: Qt.Vertical
                }
                HalGauge {
                    name: "k" + parent.i + "_sp"
                    decimals: c.decY
                    Layout.fillHeight: true
                    invert: false
                    Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                    Layout.minimumWidth: c.gaugeMinWidth
                    minimumValueVisible: false
                    maximumValueVisible: false
                    minimumValue: 0
                    maximumValue: c.maxY
                    fancy: c.fancy
                    z2Color: c.z2Color
                    z1Color: c.z1Color
                    z0Color: c.z0Color
                    z1BorderValue: c.z1BorderValue
                    z0BorderValue: c.z0BorderValue
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("Užduota")
                    Layout.alignment: Qt.AlignCenter
                }
                Label {
                    text: qsTr("Laikas,\nh")
                    horizontalAlignment: Text.AlignHCenter
                }
                HalSlider {
                    name: "k" + parent.i + "_elapsed"
                    enabled: k2_runs.value
                    property int i: parent.i
                    orientation: Qt.Vertical
                    updateValueWhileDragging: true
                    tickmarksEnabled: true
                    minimumValueVisible: false
                    maximumValueVisible: false
                    valueVisible: false
                    value: 0
                    decimals: c.decX
                    stepSize: 0.01
                    minimumValue: 0
                    maximumValue: k2_duration.value // #exception
                    Layout.fillHeight: true
                    halPin.direction: HalPin.IO
                    Label {
                        text: parent.value.toFixed(c.decX)
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.bottom
                    }
                }
            }
        }
        ColumnLayout {
            property int i: itemIndex(this) + 1
            width: 100
            height: 100
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                property int i: parent.i
                Label {
                    text: "Krosnis " + parent.i
                    Layout.alignment: Qt.AlignLeft
                }
                HalLed {
                    name: "k" + parent.i + "_comm_ok"
                    onColor: "#00c000"
                }
                Label {
                    text: qsTr("Ryšys")
                }
            }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                property int i: parent.i
                HalButton {
                    text: qsTr("Startuoti\nprogramą Nr.")
                    implicitHeight: c.gheight * 2.5
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    name: "k" + parent.i + "_start"
                }
                HalSpinBox {
                    name: "k" + parent.i + "_program"
                    enabled: !k3_runs.value
                    Layout.maximumWidth: c.gwidth
                    halPin.direction: HalPin.IO
                    halPin.type: HalPin.U32
                    decimals: 0
                    stepSize: 1
                    maximumValue: c.maxprog
                }
            }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                property int i: parent.i
                HalLed {
                    id: k3_runs
                    name: "k" + parent.i + "_runs"
                    onColor: "#ff8000"
                }
                Label {
                    text: qsTr("Programa")
                }
                HalLed {
                    name: "k" + parent.i + "_waiting"
                    onColor: "#0066ff"
                }
                Label {
                    text: qsTr("Laukiama\ntemp.")
                }
            }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                property int i: parent.i
                HalButton {
                    text: qsTr("Pristabdyti")
                    Layout.alignment: Qt.AlignHCenter
                    name: "k" + parent.i + "_stay"
                    checkable: true
                }
                HalButton {
                    text: qsTr("Stabdyti")
                    Layout.alignment: Qt.AlignRight
                    name: "k" + parent.i + "_stop"
                }
            }
            GridLayout {
                property int i: parent.i
                rows: 3
                flow: GridLayout.TopToBottom
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.columnSpan: 2
                Layout.alignment: Qt.AlignCenter | Qt.AlignVCenter

                Label {
                    text: qsTr("Temp., °C")
                    Layout.alignment: Qt.AlignHCenter
                    horizontalAlignment: Text.AlignHCenter
                    Layout.columnSpan: 3
                }

                HalGauge {
                    name: "k" + parent.i + "_pv1"
                    decimals: c.decY
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                    Layout.minimumWidth: c.gaugeMinWidth
                    fancy: c.fancy
                    z2Color: c.z2Color
                    z1Color: c.z1Color
                    z0Color: c.z0Color
                    z1BorderValue: c.z1BorderValue
                    z0BorderValue: c.z0BorderValue
                    maximumValue: c.maxY
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("Esama")
                    Layout.fillHeight: false
                    Layout.columnSpan: 2
                    Layout.alignment: Qt.AlignCenter
                }
                HalGauge {
                    name: "k" + parent.i + "_pv2"
                    decimals: c.decY
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                    Layout.minimumWidth: c.gaugeMinWidth
                    minimumValueVisible: false
                    maximumValueVisible: false
                    fancy: c.fancy
                    z2Color: c.z2Color
                    z1Color: c.z1Color
                    z0Color: c.z0Color
                    z1BorderValue: c.z1BorderValue
                    z0BorderValue: c.z0BorderValue
                    maximumValue: c.maxY
                    orientation: Qt.Vertical
                }
                HalGauge {
                    name: "k" + parent.i + "_sp"
                    decimals: c.decY
                    Layout.fillHeight: true
                    invert: false
                    Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                    Layout.minimumWidth: c.gaugeMinWidth
                    minimumValueVisible: false
                    maximumValueVisible: false
                    minimumValue: 0
                    maximumValue: c.maxY
                    fancy: c.fancy
                    z2Color: c.z2Color
                    z1Color: c.z1Color
                    z0Color: c.z0Color
                    z1BorderValue: c.z1BorderValue
                    z0BorderValue: c.z0BorderValue
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("Užduota")
                    Layout.alignment: Qt.AlignCenter
                }
                Label {
                    text: qsTr("Laikas,\nh")
                    horizontalAlignment: Text.AlignHCenter
                }
                HalSlider {
                    name: "k" + parent.i + "_elapsed"
                    enabled: k3_runs.value
                    property int i: parent.i
                    orientation: Qt.Vertical
                    updateValueWhileDragging: true
                    tickmarksEnabled: true
                    minimumValueVisible: false
                    maximumValueVisible: false
                    valueVisible: false
                    value: 0
                    decimals: c.decX
                    stepSize: 0.01
                    minimumValue: 0
                    maximumValue: k3_duration.value // #exception
                    Layout.fillHeight: true
                    halPin.direction: HalPin.IO
                    Label {
                        enabled: true
                        text: parent.value.toFixed(c.decX)
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.bottom
                    }
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
