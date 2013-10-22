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
    property int minimumWidth: 200;
    property int minimumHeight: 100;
    property string desresult;//description result

    Row {
        id: headrow;
        spacing: 4;
        anchors { left: parent.left; right: parent.right }

        QIconItem {
            icon: QIcon('accessories-dictionary');
            width: 26;
            height: 26;
        }

        PlasmaComponents.TextField {
            id: inputEntry;
            placeholderText: i18n('<i>Enter word(s) here</i>');
            width: parent.width - 26 - headrow.spacing;//22:QIconItem's width
            maximumLength: 140; //Limit the maximum length
            clearButtonShown: true;
            focus: true;

            onTextChanged: autoClear();
            Keys.onPressed: if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) enterTriggered();
        }
    }

    DictArea {//Modified from PlasmaComponents.TextArea
        id: displayText;
        anchors { top: headrow.bottom; left: main.left; right: main.right; bottom: main.bottom; topMargin: 2 }
        contentMaxHeight: text.height + 1;//QML says text.height type is 'undefined', so let it plus 1
        contentMaxWidth: width - font.pointSize * 2.2;
        readOnly: true;
        textFormat: Text.RichText;
        wrapMode: TextEdit.Wrap;
    }

    function autoClear() {//clear once text input changed
        var ac = plasmoid.readConfig('autoClear') + 1 - 1;//stupid QML!!! Can't tolerate it longer!
        if(ac)
            displayText.text = '';
    }

    function enterTriggered() {
        if (inputEntry.text != '') {
            displayText.text = i18n('<i>Loading...</i>');//it's not instantaneous!
            var p = plasmoid.readConfig('dictProvider') - 1 + 1;//ensure its type is number instead of object
            switch(p) {
                case 0:
                {console.log('Quering with QQDict');queryQQ(inputEntry.text);break;}
                case 1:
                {console.log('Quering with YOUDAO');queryYD(inputEntry.text);break;}
                case 2:
                {displayText.text='Baidu is in TO-DO list';break;}
                case 3:
                {displayText.text='iCiBa is in TO-DO list';break;}
                default:
                {console.log('No such provider. Use QQDict instead.');queryQQ(inputEntry.text);}
        }}
    }

    function parseDone() {
        if (desresult != '')    displayText.text = desresult;
        else    displayText.text = i18n('No result.');
        desresult = '';
    }

    //Beginning of QQ Dictionary
    function queryQQ(words) {
        var qqurl = 'http://dict.qq.com/dict?q=' + words;
        var resText;
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                resText = doc.responseText;
                parseQQ(resText);
            }
        }
        doc.open('GET', qqurl, true);
        doc.send();
    }

    function parseQQ(resText) {
        var jsonObj = JSON.parse(resText);//Generate JSON Object

        if (typeof jsonObj == 'object') {
            var localdes = jsonObj.local;
            var netdes = jsonObj.netdes;
            var baike = jsonObj.baike;

            if (typeof localdes == 'object' && typeof localdes[0] == 'object') {
                if(typeof localdes[0].pho == 'object') {
                    desresult += '<b>发音:</b> ' + '<i>/' + localdes[0].pho[0] + '/</i><br /><br />';//TODO i18n
                }

                if(typeof localdes[0].des == 'object' && typeof localdes[0].des[0] == 'object') {
                desresult += '<b>本地释义:</b>' + '<br />';//TODO i18n
                    for (var i=0;;i++){//get all of them
                        if(typeof localdes[0].des[i] != 'object') {desresult += '<br />';break;}
                        desresult += localdes[0].des[i].p + ' ' + localdes[0].des[i].d + '<br />';//don't bold it, make it the same style as YOUDAO
                }}

                if(typeof localdes[0].sen == 'object' && typeof localdes[0].sen[0] == 'object') {
                    desresult += '<b>例句:</b>' + '<br />';//TODO i18n
                    for (var i=0;;i++){
                        if(typeof localdes[0].sen[0].s[i] != 'object') {desresult += '<br />';break;}
                        desresult += localdes[0].sen[0].s[i].es + '<br />' + localdes[0].sen[0].s[i].cs + '<br />';
                }}

                if(typeof localdes[0].mor == 'object' && typeof localdes[0].mor[0] == 'object') {
                    desresult += '<b>词形变化:</b>' + '<br />';//TODO i18n
                    for (var i=0;;i++){//get all of them
                        if(typeof localdes[0].mor[i] != 'object') {desresult += '<br />';break;}
                        desresult += localdes[0].mor[i].c + ' ' + localdes[0].mor[i].m + '<br />';
                }}

                if(typeof localdes[0].syn == 'object' && typeof localdes[0].syn[0] == 'object') {
                    desresult += '<b>同义词:</b>' + '<br />';//TODO i18n
                    for (var i=0;;i++){//get all of them
                        if(typeof localdes[0].syn[i] != 'object') {desresult += '<br />';break;}
                        desresult += localdes[0].syn[i].p + ' ' + localdes[0].syn[i].c + '<br />';
                }}

                if(typeof localdes[0].ph == 'object' && typeof localdes[0].ph[0] == 'object') {
                    desresult += '<b>短语:</b>' + '<br />';//TODO i18n
                    for (var i=0;;i++){//get all of them
                        if(typeof localdes[0].ph[i] != 'object') {desresult += '<br />';break;}
                        desresult += localdes[0].ph[i].phs + '<br />' + localdes[0].ph[i].phd + '<br />';
                }}
            }

            if (typeof netdes == 'object' && typeof netdes[0] == 'object' && typeof netdes[0].des == 'object') {
                desresult += '<b>网络释义:</b>' + '<br />';//TODO i18n
                for (var i=0 ; i<5 ; i++) {//5 is enough for netdes for it's often ridiculous
                    if(typeof netdes[0].des[i] != 'object') {desresult += '<br />';break;}
                    desresult += netdes[0].des[i].d + ' ; ';
            }}

            if (typeof baike == 'object' && typeof baike[0] == 'object' && baike[0].link != '') {
                desresult += '<br /><a href="' + baike[0].link + '">SOSO百科词条</a>';
            }
        }
        parseDone();
    }
    //End of QQ Dictionary

    //Beginning of YOUDAO Fanyi
    XmlListModel {
        id: ydModel;
        query: '/youdao-fanyi';

        XmlRole { name: 'translation'; query: 'translation/string()' }//YOUDAO Translation
        XmlRole { name: 'phonetic'; query: 'basic/phonetic/string()' }//YOUDAO Basic Dictionary
        XmlRole { name: 'explains'; query: 'basic/explains/string()' }
        XmlRole { name: 'webkey' ; query: 'web/explain[1]/key/string()' }//YOUDAO Web Dictionary
        XmlRole { name: 'web'; query: 'web/explain[1]/value/string()' }
        XmlRole { name: 'webkey2' ; query: 'web/explain[2]/key/string()' }
        XmlRole { name: 'web2'; query: 'web/explain[2]/value/string()' }
        XmlRole { name: 'webkey3' ; query: 'web/explain[3]/key/string()' }
        XmlRole { name: 'web3'; query: 'web/explain[3]/value/string()' }

        onCountChanged: parseYD();
    }

    function queryYD(words) {
        var ydkey = '&key=' + plasmoid.readConfig('youdao_key');//Ensure it's string
        var ydname = '?keyfrom=' + plasmoid.readConfig('youdao_name');//Ensure it's string

        if(ydkey == '&key=' || ydname == '?keyfrom=')       displayText.text = i18n('API key is empty.<br /><a href="https://github.com/librehat/kdictionary#advanced-usage">Help?</a>');
        else {
            var ydurl = 'http://fanyi.youdao.com/openapi.do' + ydname + ydkey+ '&type=data&doctype=xml&version=1.1&q=' + words;
            console.log(ydurl);
            ydModel.source = ydurl;
        }
    }

    function parseYD() {
        if(ydModel.get(0).phonetic != '')  desresult += '<b>发音:</b> <i>/' + ydModel.get(0).phonetic + '/</i><br /><br />'//TODO i18n
        if(ydModel.get(0).explains != '')  desresult += '<b>基本词典:</b><br />' + ydModel.get(0).explains + '<br /><br />';//TODO i18n
        if(ydModel.get(0).translation != '')  desresult += '<b>有道翻译:</b><br />' + ydModel.get(0).translation + '<br /><br />';//TODO i18n
        if(ydModel.get(0).webkey != '')  desresult += '<b>网络释义:</b><br />' + ydModel.get(0).webkey + ': ' + ydModel.get(0).web + '<br />' + ydModel.get(0).webkey2 + ': ' + ydModel.get(0).web2 + '<br />' + ydModel.get(0).webkey3 + ': ' + ydModel.get(0).web3;//TODO i18n
        parseDone();
    }
    //End of YOUDAO Fanyi
}