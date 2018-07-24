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
    title: qsTr("ui_mon")

    function itemIndex(item) {
        if (item.parent === null)
            return -1
        var siblings = item.parent.children
        for (var i = 0; i < siblings.length; i++)
            if (siblings[i] === item)
                return i
        return -1 //will never happen
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
//            visible: kiln_checkboxes.children[i].checked
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 5

            RowLayout {
                Layout.fillWidth: true

                Label {
                    text: "" + parent.parent.i
                    font.pointSize: 16
                }
                HalLed {
                    name: "k" + parent.parent.i + "_comm_ok"
                    onColor: "#00C000"
                    smooth: false
                }
                Label {
                    text: qsTr("Ryšys ")
                }
                HalLed {
                    name: "k" + parent.parent.i + "_ser_run"
                    onColor: "#00C000"
                    smooth: false
                }
                Label {
                    text: qsTr("Kompiuterio\nprograma")
                }
                Label {
                    text: qsTr("Momentinis\ngalingumas:")
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_op1"
                    suffix: "%"
                    minimumValueVisible: false
                    maximumValueVisible: false
                    smooth: false
                    decimals: 1
                    Layout.fillWidth: true
                    fancy: false
                    maximumValue: 100
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_op2"
                    suffix: "%"
                    minimumValueVisible: false
                    maximumValueVisible: false
                    smooth: false
                    decimals: 1
                    Layout.fillWidth: true
                    fancy: false
                    maximumValue: 100
                }
                Label {
                    text: qsTr("Temperatūros,\n°C:")
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            GridLayout {
                rows: 2
                flow: GridLayout.TopToBottom
                Layout.fillHeight: true
                Layout.fillWidth: true

                LogChart {
                    value: parent.children[itemIndex(this) + 2].value
                    smooth: false
                    leftTextVisible: false
                    decimals: 1
                    changeGraphEnabled: true
                    autoSampling: true
                    maximumValue: 1000
                    rightTextVisible: false
                    suffix: "°C"
                    yGrid: 100
                    xGrid: 1000
                    timeSpan: 30000
                    sampleInterval: 1000
                    maximumLogSize: 600
                    targetValue: 1000
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
                Item {
                    Layout.fillWidth: true
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_pv1"
                    maximumValueVisible: false
                    minimumValueVisible: false
                    smooth: false
                    decimals: 0
                    Layout.fillHeight: true
                    Layout.minimumWidth: 35
                    fancy: true
                    z0BorderValue: 200
                    z1BorderValue: 600
                    maximumValue: 1000
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("dav.") + " 1"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillHeight: false
                    Layout.preferredHeight: 22
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_pv2"
                    maximumValueVisible: false
                    minimumValueVisible: false
                    smooth: false
                    decimals: 0
                    Layout.fillHeight: true
                    Layout.minimumWidth: 35
                    fancy: true
                    z0BorderValue: 200
                    z1BorderValue: 600
                    maximumValue: 1000
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("dav.") + " 2"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillHeight: false
                    Layout.preferredHeight: 22
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_ser_sp"
                    minimumValueVisible: false
                    maximumValueVisible: false
                    smooth: false
                    decimals: 0
                    Layout.fillHeight: true
                    invert: false
                    Layout.minimumWidth: 35
                    minimumValue: 0
                    maximumValue: 1000
                    fancy: false
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("Užduota")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredHeight: 22
                }
            }
        }
        ColumnLayout {
            property int i: itemIndex(this)
//            visible: kiln_checkboxes.children[i].checked
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 5

            RowLayout {
                Layout.fillWidth: true

                Label {
                    text: "" + parent.parent.i
                    font.pointSize: 16
                }
                HalLed {
                    name: "k" + parent.parent.i + "_comm_ok"
                    onColor: "#00C000"
                    smooth: false
                }
                Label {
                    text: qsTr("Ryšys ")
                }
                HalLed {
                    name: "k" + parent.parent.i + "_ser_run"
                    onColor: "#00C000"
                    smooth: false
                }
                Label {
                    text: qsTr("Kompiuterio\nprograma")
                }
                Label {
                    text: qsTr("Momentinis\ngalingumas:")
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_op1"
                    suffix: "%"
                    minimumValueVisible: false
                    maximumValueVisible: false
                    smooth: false
                    decimals: 1
                    Layout.fillWidth: true
                    fancy: false
                    maximumValue: 100
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_op2"
                    suffix: "%"
                    minimumValueVisible: false
                    maximumValueVisible: false
                    smooth: false
                    decimals: 1
                    Layout.fillWidth: true
                    fancy: false
                    maximumValue: 100
                }
                Label {
                    text: qsTr("Temperatūros,\n°C:")
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            GridLayout {
                rows: 2
                flow: GridLayout.TopToBottom
                Layout.fillHeight: true
                Layout.fillWidth: true

                LogChart {
                    value: parent.children[itemIndex(this) + 2].value
                    smooth: false
                    leftTextVisible: false
                    decimals: 1
                    changeGraphEnabled: true
                    autoSampling: true
                    maximumValue: 1000
                    rightTextVisible: false
                    suffix: "°C"
                    yGrid: 100
                    xGrid: 1000
                    timeSpan: 30000
                    sampleInterval: 1000
                    maximumLogSize: 600
                    targetValue: 1000
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
                Item {
                    Layout.fillWidth: true
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_pv1"
                    maximumValueVisible: false
                    minimumValueVisible: false
                    smooth: false
                    decimals: 0
                    Layout.fillHeight: true
                    Layout.minimumWidth: 35
                    fancy: true
                    z0BorderValue: 200
                    z1BorderValue: 600
                    maximumValue: 1000
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("dav.") + " 1"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillHeight: false
                    Layout.preferredHeight: 22
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_pv2"
                    maximumValueVisible: false
                    minimumValueVisible: false
                    smooth: false
                    decimals: 0
                    Layout.fillHeight: true
                    Layout.minimumWidth: 35
                    fancy: true
                    z0BorderValue: 200
                    z1BorderValue: 600
                    maximumValue: 1000
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("dav.") + " 2"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillHeight: false
                    Layout.preferredHeight: 22
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_ser_sp"
                    minimumValueVisible: false
                    maximumValueVisible: false
                    smooth: false
                    decimals: 0
                    Layout.fillHeight: true
                    invert: false
                    Layout.minimumWidth: 35
                    minimumValue: 0
                    maximumValue: 1000
                    fancy: false
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("Užduota")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredHeight: 22
                }
            }
        }
        ColumnLayout {
            property int i: itemIndex(this)
//            visible: kiln_checkboxes.children[i].checked
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 5

            RowLayout {
                Layout.fillWidth: true

                Label {
                    text: "" + parent.parent.i
                    font.pointSize: 16
                }
                HalLed {
                    name: "k" + parent.parent.i + "_comm_ok"
                    onColor: "#00C000"
                    smooth: false
                }
                Label {
                    text: qsTr("Ryšys ")
                }
                HalLed {
                    name: "k" + parent.parent.i + "_ser_run"
                    onColor: "#00C000"
                    smooth: false
                }
                Label {
                    text: qsTr("Kompiuterio\nprograma")
                }
                Label {
                    text: qsTr("Momentinis\ngalingumas:")
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_op1"
                    suffix: "%"
                    minimumValueVisible: false
                    maximumValueVisible: false
                    smooth: false
                    decimals: 1
                    Layout.fillWidth: true
                    fancy: false
                    maximumValue: 100
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_op2"
                    suffix: "%"
                    minimumValueVisible: false
                    maximumValueVisible: false
                    smooth: false
                    decimals: 1
                    Layout.fillWidth: true
                    fancy: false
                    maximumValue: 100
                }
                Label {
                    text: qsTr("Temperatūros,\n°C:")
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            GridLayout {
                rows: 2
                flow: GridLayout.TopToBottom
                Layout.fillHeight: true
                Layout.fillWidth: true

                LogChart {
                    value: parent.children[itemIndex(this) + 2].value
                    smooth: false
                    leftTextVisible: false
                    decimals: 1
                    changeGraphEnabled: true
                    autoSampling: true
                    maximumValue: 1000
                    rightTextVisible: false
                    suffix: "°C"
                    yGrid: 100
                    xGrid: 1000
                    timeSpan: 30000
                    sampleInterval: 1000
                    maximumLogSize: 600
                    targetValue: 1000
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
                Item {
                    Layout.fillWidth: true
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_pv1"
                    maximumValueVisible: false
                    minimumValueVisible: false
                    smooth: false
                    decimals: 0
                    Layout.fillHeight: true
                    Layout.minimumWidth: 35
                    fancy: true
                    z0BorderValue: 200
                    z1BorderValue: 600
                    maximumValue: 1000
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("dav.") + "1"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillHeight: false
                    Layout.preferredHeight: 22
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_pv2"
                    maximumValueVisible: false
                    minimumValueVisible: false
                    smooth: false
                    decimals: 0
                    Layout.fillHeight: true
                    Layout.minimumWidth: 35
                    fancy: true
                    z0BorderValue: 200
                    z1BorderValue: 600
                    maximumValue: 1000
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("dav.") + "2"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillHeight: false
                    Layout.preferredHeight: 22
                }
                HalGauge {
                    name: "k" + parent.parent.i + "_ser_sp"
                    minimumValueVisible: false
                    maximumValueVisible: false
                    smooth: false
                    decimals: 0
                    Layout.fillHeight: true
                    invert: false
                    Layout.minimumWidth: 35
                    minimumValue: 0
                    maximumValue: 1000
                    fancy: false
                    orientation: Qt.Vertical
                }
                Label {
                    text: qsTr("Užduota")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredHeight: 22
                }
            }
        }
        // Identical above ^^^
    }
}
