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

Item {

    id: main;
    property int minimumWidth: 120;
    property int minimumHeight: 50;

    Row {
        id: headrow;
        spacing: 4;
        anchors { left: parent.left; right: parent.right}

        QIconItem {
            icon: QIcon("accessories-dictionary");
            width: 22;
            height: 22;
        }

        PlasmaComponents.TextField {
            id: inputEntry;
            placeholderText: i18n("<i>Enter word(s) here</i>");
            width: parent.width - 26; //26 = QIconItem's width + spacing
            maximumLength: 100; //Limit the maximum length //TODO: cutomisable
            font.pointSize: 10; //TODO: cutomisable
            clearButtonShown: true;
            focus: true;
            Keys.onPressed: {
                if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return)    query();
            }
        }
    }

    PlasmaExtras.ScrollArea {
        id: view;
        anchors { top: headrow.bottom; left: main.left; right: main.right; bottom: main.bottom; topMargin: 4}

        Flickable {
            id:display;
            interactive: false;//disable dragging the content
            contentWidth: displayText.width;
            contentHeight: displayText.height;
            
            PlasmaComponents.Label{
                id: displayText;
                width: view.width - font.pointSize * 1.5;//ensure there is no horizontal scrollbar
                wrapMode: TextEdit.Wrap;
                textFormat: Text.RichText;
            }
        }
    }
    
    function query() {
        if(inputEntry.text != "") {
            var url = "http://dict.qq.com/dict?q=" + inputEntry.text;
            getResult(url);
        }
        else    console.log("Please enter word(s) at first.");
    }
    
    function getResult(url) {
        var resText;
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                resText = doc.responseText;
                //console.log(typeof resText + resText);
                parseQQdict(resText);//TODO:add iciba, baidu translate, etc.
            }
        }
        doc.open('GET', url, true);
        doc.send();
    }
    
    function parseQQdict(resText) {
        var jsonObj = JSON.parse(resText);
        var desresult = "";
        
        if (typeof jsonObj == 'object') {
            var localdes = jsonObj.local;
            var netdes = jsonObj.netdes[0];
            
            if (typeof localdes == 'object') {
                if(typeof localdes[0].pho == 'object') {
                    desresult += "<b>发音:</b> " + "<i>/" + localdes[0].pho[0] + "/</i><br /><br />";
                }
                desresult += "<b>本地释义:</b> " + "<br />";
                for (var i=0 ; i<10 ; i++){
                    if(typeof localdes[0].des[i] != 'object')       break;
                    desresult += "<b>" + localdes[0].des[i].p + "</b> "+ localdes[0].des[i].d + "<br />";
                }
                desresult += "<br />";
            }
            else    console.log ("localdes is not an object. Its type is:" + typeof localdes);
            
            if (typeof netdes == 'object') {
                desresult += "<b>网络释义:</b>" + "<br />";
                for (var i=0 ; i<5 ; i++) {
                    if(typeof netdes.des[i] != 'object')       break;
                    desresult += netdes.des[i].d + " ; ";
                }
            }
            else    console.log ("netdes is not an object. Its type is:" + typeof netdes);
            
        }
        else    console.log ("jsonObj is not an object. Its type is:" + typeof jsonObj);
        
        if (desresult != '')    displayText.text = desresult;
        else    displayText.text = i18n("No result.");
    }
}