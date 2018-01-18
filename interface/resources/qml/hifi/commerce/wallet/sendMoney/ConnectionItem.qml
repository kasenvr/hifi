//
//  ConnectionItem.qml
//  qml/hifi/commerce/wallet/sendMoney
//
//  ConnectionItem
//
//  Created by Zach Fox on 2018-01-09
//  Copyright 2018 High Fidelity, Inc.
//
//  Distributed under the Apache License, Version 2.0.
//  See the accompanying file LICENSE or http://www.apache.org/licenses/LICENSE-2.0.html
//

import Hifi 1.0 as Hifi
import QtQuick 2.5
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../../../styles-uit"
import "../../../../controls-uit" as HifiControlsUit
import "../../../../controls" as HifiControls
import "../../wallet" as HifiWallet

Item {
    HifiConstants { id: hifi; }

    id: root;
    property bool isSelected: false;
    property string userName;
    property string profilePicUrl;

    height: 65;
    width: parent.width;

    Rectangle {
        id: mainContainer;
        // Style
        color: root.isSelected ? hifi.colors.faintGray : hifi.colors.white;
        // Size
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.top: parent.top;
        height: root.height;
        
        Item {
            id: avatarImage;
            visible: profileUrl !== "" && userName !== "";
            // Size
            anchors.verticalCenter: parent.verticalCenter;
            anchors.left: parent.left;
            anchors.leftMargin: 36;
            height: root.height - 15;
            width: visible ? height : 0;
            clip: true;
            Image {
                id: userImage;
                source: root.profilePicUrl !== "" ? ((0 === root.profilePicUrl.indexOf("http")) ?
                    root.profilePicUrl : (Account.metaverseServerURL + root.profilePicUrl)) : "";
                mipmap: true;
                // Anchors
                anchors.fill: parent
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Item {
                        width: userImage.width;
                        height: userImage.height;
                        Rectangle {
                            anchors.centerIn: parent;
                            width: userImage.width; // This works because userImage is square
                            height: width;
                            radius: width;
                        }
                    }
                }
            }
            AnimatedImage {
                source: "../../../../../icons/profilePicLoading.gif"
                anchors.fill: parent;
                visible: userImage.status != Image.Ready;
            }
        }

        RalewaySemiBold {
            id: userName;
            anchors.left: avatarImage.right;
            anchors.leftMargin: 16;
            anchors.top: parent.top;
            anchors.bottom: parent.bottom;
            anchors.right: chooseButton.visible ? chooseButton.left : parent.right;
            anchors.rightMargin: chooseButton.visible ? 10 : 0;
            // Text size
            size: 20;
            // Style
            color: hifi.colors.baseGray;
            text: root.userName;
            elide: Text.ElideRight;
            // Alignment
            horizontalAlignment: Text.AlignLeft;
            verticalAlignment: Text.AlignVCenter;
        }

        // "Choose" button
        HifiControlsUit.Button {
            id: chooseButton;
            visible: root.isSelected;
            color: hifi.buttons.blue;
            colorScheme: hifi.colorSchemes.dark;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.right: parent.right;
            anchors.rightMargin: 24;
            height: root.height - 20;
            width: 110;
            text: "CHOOSE";
            onClicked: {
                var msg = { method: 'chooseConnection', userName: root.userName, profilePicUrl: root.profilePicUrl };
                sendToSendMoney(msg);
            }
        }
    }

    //
    // FUNCTION DEFINITIONS START
    //
    signal sendToSendMoney(var msg);
    //
    // FUNCTION DEFINITIONS END
    //
}
