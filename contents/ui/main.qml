// -*- coding: utf-8 -*-
/*
 *   Copyright (C) 2013 by William Wong <librehat@outlook.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtras
import "api" as API

Item {
    id: mainWindow;
    property int minimumWidth: 200;
    property int minimumHeight: 200;
    property string desresult;//description result
    property bool clearCollapsed;
    property bool autoClear;
    property bool autoHide;
    property bool autoQuery;
    property bool showSentences;
    property bool showPhrases;
    property bool showWebdict;
    property bool showBaike;
    property int dictProvider;
    property string youdao_key;
    property string youdao_name;
    property string baidu_key;
    property string iciba_key;
    property string mwcd_key;
    property string mwsd_key;

    API.QQ {//Tencent QQ Dict
        id: qq;
    }

    API.ICB {//Kingsoft PowerWord iCiBa
        id: cb;
    }

    API.YOUDAO {//NetEase YOUDAO Dictionary/Translation
        id: yd;
    }

    API.BAIDU {//BAIDU Translation
        id: bd;
    }

    API.MWCD {//Merriam-Webster's Collegiate® Dictionary
        id: mwcd;
    }

    API.MWSD {//Merriam-Webster's Spanish-English Dictionary
        id: mwsd;
    }

    function configChanged() {
        autoClear = plasmoid.readConfig('autoClear');
        clearCollapsed = plasmoid.readConfig('clearCollapsed');
        autoQuery = plasmoid.readConfig('autoQuery');
        showSentences = plasmoid.readConfig('showSentences');
        showPhrases = plasmoid.readConfig('showPhrases');
        showWebdict = plasmoid.readConfig('showWebdict');
        showBaike = plasmoid.readConfig('showBaike');
        dictProvider = plasmoid.readConfig('dictProvider');
        youdao_key = plasmoid.readConfig('youdao_key');
        youdao_name = plasmoid.readConfig('youdao_name');
        baidu_key = plasmoid.readConfig('baidu_key');
        iciba_key = plasmoid.readConfig('iciba_key');
        mwcd_key = plasmoid.readConfig('mwcd_key');
        mwsd_key = plasmoid.readConfig('mwsd_key');
        autoHide = plasmoid.readConfig('autoHide');
        plasmoid.passivePopup =  !autoHide;

        if (dictProvider == 4 || dictProvider == 5)
            displayText.logoVisible = true;
        else
            displayText.logoVisible = false;
    }

    function popupEventSlot(popped) {
        if (!popped && clearCollapsed) {//reset content when collapsed
            displayText.text = '';
            inputEntry.text = '';
        }
        else if (autoQuery) {
            inputEntry.forceActiveFocus();
            inputEntry.paste();
            enterTriggered();
        }
    }

    function enterTriggered() {
        if (inputEntry.text != '') {
            displayText.text = '<i>' + i18n('Loading...') + '</i>';//it's not instantaneous!
            switch(dictProvider) {
                case 0: { qq.queryQQ(inputEntry.text); break; }
                case 1: { yd.queryYD(inputEntry.text); break; }
                case 2: { bd.queryBD(inputEntry.text); break; }
                case 3: { cb.queryCB(inputEntry.text); break; }
                case 4: { mwcd.queryMWCD(inputEntry.text); break; }
                case 5: { mwsd.query(inputEntry.text); break; }
                default: { console.log('No such provider. Use QQDict instead.');    qq.queryQQ(inputEntry.text); }
            }
        }
    }

    function parseDone() {//use this function to change displayText.text, never change displayText.text directly!
        if (desresult != '')    displayText.text = desresult;
        else    displayText.text = '<i>' + i18n('No result.') + '</i>';
        desresult = '';
    }

    Row {
        id: headrow;
        spacing: 4;
        anchors { left: parent.left; right: parent.right }

        QIconItem {
            id: topIcon;
            icon: QIcon('accessories-dictionary');
            width: 28;
            height: 28;

            MouseArea {//Make a hovering effect just like the original Dictionary plasmoid in Plasma Addons
                anchors.fill: topIcon;
                hoverEnabled: true;
                onEntered: topIcon.state = QIconItem.ActiveState;
                onExited: topIcon.state = QIconItem.DisabledState;
            }
        }

        PlasmaComponents.TextField {
            id: inputEntry;
            placeholderText: '<i>' + i18n('Enter word(s) here') + '</i>';
            width: parent.width - 28 - headrow.spacing;//22:QIconItem's width
            maximumLength: 140; //Limit the maximum length
            clearButtonShown: true;
            focus: true;

            onTextChanged: if (autoClear)  displayText.text = '';
            Keys.onPressed: if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) enterTriggered();
        }
    }

    DictArea {//Modified from PlasmaComponents.TextArea
        id: displayText;
        anchors { top: headrow.bottom; left: mainWindow.left; right: mainWindow.right; bottom: mainWindow.bottom; topMargin: 2 }
        contentMaxHeight: text.height + 1;//QML says text.height type is 'undefined', so let it plus 1
        contentMaxWidth: width - font.pointSize * 2.2;
        readOnly: true;
        textFormat: Text.RichText;
        wrapMode: TextEdit.Wrap;
    }

    Component.onCompleted: {
        configChanged();
        plasmoid.popupIcon = 'accessories-dictionary';
        var toolTip = new Object;
        toolTip['image'] = 'accessories-dictionary';
        toolTip['mainText'] = i18n('KDictionary');
        plasmoid.popupIconToolTip = toolTip;
        plasmoid.aspectRatioMode = IgnoreAspectRatio;
        plasmoid.addEventListener('configChanged', mainWindow.configChanged);
        plasmoid.popupEvent.connect(popupEventSlot);
    }
}