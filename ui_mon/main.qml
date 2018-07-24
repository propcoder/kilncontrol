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
import Machinekit.Application 1.0
import Machinekit.Application.Controls 1.0
import Machinekit.Service 1.0

ApplicationWindow {
    id: applicationWindow

    visibility: (Qt.platform.os == "android") ? "FullScreen" : "AutomaticVisibility"
    visible: true
    width: 800
    height: 600
    title: connectionWindow.title

    ConnectionWindow {
        id: connectionWindow

        anchors.fill: parent
        defaultTitle: "ui"
        autoSelectInstance: false
        autoSelectApplication: false
        localVisible: true
        remoteVisible: true
        lookupMode: ServiceDiscovery.MulticastDNS
        mode: "local"
        applications: [
            ApplicationDescription {
                sourceDir: "qrc:/ui/"
            }
        ]
        instanceFilter: ServiceDiscoveryFilter{ name: "" }
    }
}
