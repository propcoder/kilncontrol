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
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import Machinekit.Controls 1.0
import Machinekit.HalRemote.Controls 1.0
import Machinekit.HalRemote 1.0
import Machinekit.Application 1.0
import Machinekit.Application.Controls 1.0
//import Machinekit.PathView 1.0
//import Machinekit.Service 1.0

HalApplicationWindow {
    id: main
    name: "ui_prog"
    title: "Programų valdymas"
    color: "#678f8f"
    border.width: 0
    anchors.fill: parent
    anchors.margins: 0


    Item { // Configuration
        id: c
        property int kiln: 1 // kiln number
        property int pts: 10 // point count
        property real maxX: 168
        property real stepX: 0.25
        property int decDx: 2
        property real maxY: 1100
        property real stepY: 10
        property int decY: 0
        property int maxprog: 9
        property int fs: Math.min(38, main.width / 50) // fontsize
    }

//    HalRemoteComponent.halrcmdUri: "tcp://10.10.10.117:5001"
//    HalRemoteComponent.halrcompUri: "tcp://10.10.10.117:5002"

    function itemIndex(item) {
        if (item.parent === null) {
            console.log("nieko")
            return -100 }
        var siblings = item.parent.children
        for (var i = 0; i < siblings.length; i++)
            if (siblings[i] === item)
                return i
        return -100 //will never happen
    }

    HalPin {
        id: k1_actual_program
        name: "k1_actual_program"
        direction: HalPin.In
        type: HalPin.U32
    }
    HalPin {
        id: k2_actual_program
        name: "k2_actual_program"
        direction: HalPin.In
        type: HalPin.U32
    }
    HalPin {
        id: k3_actual_program
        name: "k3_actual_program"
        direction: HalPin.In
        type: HalPin.U32
    }
    HalPin {
        id: k1_runs
        name: "k1_runs"
        direction: HalPin.In
        type: HalPin.Bit
    }
    HalPin {
        id: k2_runs
        name: "k2_runs"
        direction: HalPin.In
        type: HalPin.Bit
    }
    HalPin {
        id: k3_runs
        name: "k3_runs"
        direction: HalPin.In
        type: HalPin.Bit
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Math.max(5, parent.width / 200)

        // Almost identical ColumnLayout's for each Kiln below vvv

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            property int kiln: itemIndex(this) + 1

            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                property int kiln: parent.kiln
                Label {
                    text: "Krosnies Nr. " + parent.kiln + " programa Nr."
                    font.pixelSize: c.fs
                }
                HalSpinBox {
                    id: k1_program
                    enabled: !k1_runs.value
                    name: "k" + parent.kiln + "_program"
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    halPin.type: HalPin.U32
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: 0
                    stepSize: 1
                    maximumValue: c.maxprog
                }
                Item {
                    Layout.fillWidth: true
                }
            }
            GridLayout {
                enabled: k1_program.value === k1_actual_program.value
                layoutDirection: Qt.LeftToRight
                columns: 2 * (c.pts + 1)
                columnSpacing: 0
                property string kiln: "k" + parent.kiln
                Label {
                    text: "Trukmės,\nh"
                    font.pixelSize: c.fs
                    Layout.alignment: Qt.AlignHCenter
                }
                property int dx0idx: 1

                // Identical HalSpinBox'es below vvv

                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }

                // Identical HalSpinBox'es above ^^^

                Item {
                }
                Label {
                    text: "Taškai:\nTemp.,\n°C"
                    Layout.fillWidth: true
                    font.pixelSize: c.fs
                    Layout.columnSpan: 2
                    Layout.alignment: Qt.AlignHCenter
                }
                property int y0idx: dx0idx + 1 * (c.pts + 1)
                // Identical HalSpinBox'es below vvv

                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                // Identical HalSpinBox'es above ^^^

                Label {
                    text: ""
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    Layout.columnSpan: 2
                }
                property int y0gidx: y0idx + c.pts
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            property int kiln: itemIndex(this) + 1

            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                property int kiln: parent.kiln
                Label {
                    text: "Krosnies Nr. " + parent.kiln + " programa Nr."
                    font.pixelSize: c.fs
                }
                HalSpinBox {
                    id: k2_program
                    enabled: !k2_runs.value
                    name: "k" + parent.kiln + "_program"
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    halPin.type: HalPin.U32
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: 0
                    stepSize: 1
                    maximumValue: c.maxprog
                }
                Item {
                    Layout.fillWidth: true
                }
            }
            GridLayout {
                enabled: k2_program.value === k2_actual_program.value
                layoutDirection: Qt.LeftToRight
                columns: 2 * (c.pts + 1)
                columnSpacing: 0
                property string kiln: "k" + parent.kiln
                Label {
                    text: "Trukmės,\nh"
                    font.pixelSize: c.fs
                    Layout.alignment: Qt.AlignHCenter
                }
                property int dx0idx: 1

                // Identical HalSpinBox'es below vvv

                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }

                // Identical HalSpinBox'es above ^^^

                Item {
                }
                Label {
                    text: "Taškai:\nTemp.,\n°C"
                    Layout.fillWidth: true
                    font.pixelSize: c.fs
                    Layout.columnSpan: 2
                    Layout.alignment: Qt.AlignHCenter
                }
                property int y0idx: dx0idx + 1 * (c.pts + 1)
                // Identical HalSpinBox'es below vvv

                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                // Identical HalSpinBox'es above ^^^

                Label {
                    text: ""
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    Layout.columnSpan: 2
                }
                property int y0gidx: y0idx + c.pts
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            property int kiln: itemIndex(this) + 1

            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                property int kiln: parent.kiln
                Label {
                    text: "Krosnies Nr. " + parent.kiln + " programa Nr."
                    font.pixelSize: c.fs
                }
                HalSpinBox {
                    id: k3_program
                    enabled: !k3_runs.value
                    name: "k" + parent.kiln + "_program"
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    halPin.type: HalPin.U32
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: 0
                    stepSize: 1
                    maximumValue: c.maxprog
                }
                Item {
                    Layout.fillWidth: true
                }
            }
            GridLayout {
                enabled: k3_program.value === k3_actual_program.value
                layoutDirection: Qt.LeftToRight
                columns: 2 * (c.pts + 1)
                columnSpacing: 0
                property string kiln: "k" + parent.kiln
                Label {
                    text: "Trukmės,\nh"
                    font.pixelSize: c.fs
                    Layout.alignment: Qt.AlignHCenter
                }
                property int dx0idx: 1

                // Identical HalSpinBox'es below vvv

                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }
                HalSpinBox {
                    name: parent.kiln + "_dx" + (itemIndex(this) - parent.dx0idx)
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    decimals: c.decDx
                    stepSize: c.stepX
                    maximumValue: c.maxX
                }

                // Identical HalSpinBox'es above ^^^

                Item {
                }
                Label {
                    text: "Taškai:\nTemp.,\n°C"
                    Layout.fillWidth: true
                    font.pixelSize: c.fs
                    Layout.columnSpan: 2
                    Layout.alignment: Qt.AlignHCenter
                }
                property int y0idx: dx0idx + 1 * (c.pts + 1)
                // Identical HalSpinBox'es below vvv

                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                HalSpinBox {
                    property int idx: itemIndex(this) - parent.y0idx
                    name: parent.kiln + "_y" + idx
                    font.pixelSize: c.fs
                    halPin.direction: HalPin.IO
                    Layout.fillWidth: true
                    Layout.maximumWidth: main.width / (c.pts + 2)
                    Layout.alignment: Qt.AlignCenter
                    Layout.columnSpan: 2
                    maximumValue: c.maxY
                    stepSize: c.stepY
                    decimals: c.decY
                    Label {
                        text: parent.idx
                        font.pixelSize: c.fs
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.top
                    }
                }
                // Identical HalSpinBox'es above ^^^

                Label {
                    text: ""
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    Layout.columnSpan: 2
                }
                property int y0gidx: y0idx + c.pts
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
        }

        // Almost identical ColumnLayout's for each Kiln above ^^^
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
