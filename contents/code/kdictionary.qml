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
    property bool autoClear;
    property bool showSentences;
    property bool showPhrases;
    property bool showWebdict;
    property bool showBaike;
    property int dictProvider;
    property string youdao_key;
    property string youdao_name;
    property string baidu_key;
    property string iciba_key;

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

            onTextChanged: if(autoClear)  displayText.text = '';
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

    Component.onCompleted: {
        plasmoid.addEventListener('configChanged', configChanged);
    }

    function configChanged() {
        autoClear = plasmoid.readConfig('autoClear');
        showSentences = plasmoid.readConfig('showSentences');
        showPhrases = plasmoid.readConfig('showPhrases');
        showWebdict = plasmoid.readConfig('showWebdict');
        showBaike = plasmoid.readConfig('showBaike');
        dictProvider = plasmoid.readConfig('dictProvider');
        youdao_key = plasmoid.readConfig('youdao_key');
        youdao_name = plasmoid.readConfig('youdao_name');
        baidu_key = plasmoid.readConfig('baidu_key');
        iciba_key = plasmoid.readConfig('iciba_key');
    }

    function enterTriggered() {
        if (inputEntry.text != '') {
            displayText.text = i18n('<i>Loading...</i>');//it's not instantaneous!
            switch(dictProvider) {
                case 0: {console.log('Quering with QQDict');queryQQ(inputEntry.text);break;}
                case 1: {console.log('Quering with YOUDAO');queryYD(inputEntry.text);break;}
                case 2: {console.log('Quering with Baidu');queryBD(inputEntry.text);break;}
                case 3: {console.log('Quering with iCiBa');queryCB(inputEntry.text);break;}
                default: {console.log('No such provider. Use QQDict instead.');queryQQ(inputEntry.text);}
        }}
    }

    function parseDone() {
        if (desresult != '')    displayText.text = desresult;
        else    displayText.text = i18n('<i>No result.</i>');
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

                if(showSentences && typeof localdes[0].sen == 'object' && typeof localdes[0].sen[0] == 'object') {
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

                if(showPhrases && typeof localdes[0].ph == 'object' && typeof localdes[0].ph[0] == 'object') {
                    desresult += '<b>短语:</b>' + '<br />';//TODO i18n
                    for (var i=0;;i++){//get all of them
                        if(typeof localdes[0].ph[i] != 'object') {desresult += '<br />';break;}
                        desresult += localdes[0].ph[i].phs + '<br />' + localdes[0].ph[i].phd + '<br />';
                }}
            }

            if (showWebdict &&  typeof netdes == 'object' && typeof netdes[0] == 'object' && typeof netdes[0].des == 'object') {
                desresult += '<b>网络释义:</b>' + '<br />';//TODO i18n
                for (var i=0 ; i<5 ; i++) {//5 is enough for netdes for it's often ridiculous
                    if(typeof netdes[0].des[i] != 'object') {desresult += '<br />';break;}
                    desresult += netdes[0].des[i].d + ' ; ';
            }}

            if (showBaike && typeof baike == 'object' && typeof baike[0] == 'object' && baike[0].link != '') {
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
        if(youdao_key == '' || youdao_name == '')  displayText.text = i18n('YOUDAO API key is empty.<br /><a href="https://github.com/librehat/kdictionary#advanced-usage">Help?</a>');
        else {
            var ydurl = 'http://fanyi.youdao.com/openapi.do?keyfrom=' + youdao_name + '&key=' + youdao_key + '&type=data&doctype=xml&version=1.1&q=' + words;
            ydModel.source = ydurl;
        }
    }

    function parseYD() {
        if(ydModel.get(0).phonetic != '')  desresult += '<b>发音:</b> <i>/' + ydModel.get(0).phonetic + '/</i><br /><br />'//TODO i18n
        if(ydModel.get(0).explains != '')  desresult += '<b>基本词典:</b><br />' + ydModel.get(0).explains + '<br /><br />';//TODO i18n
        if(ydModel.get(0).translation != '')  desresult += '<b>有道翻译:</b><br />' + ydModel.get(0).translation + '<br /><br />';//TODO i18n
        if(showWebdict && ydModel.get(0).webkey != '')  desresult += '<b>网络释义:</b><br />' + ydModel.get(0).webkey + ': ' + ydModel.get(0).web + '<br />' + ydModel.get(0).webkey2 + ': ' + ydModel.get(0).web2 + '<br />' + ydModel.get(0).webkey3 + ': ' + ydModel.get(0).web3;//TODO i18n
        parseDone();
    }
    //End of YOUDAO Fanyi

    //Beginning of Baidu
    function queryBD(words) {
        var bdurl = 'http://openapi.baidu.com/public/2.0/bmt/translate?client_id=' + baidu_key + '&q=' + words + '&from=auto&to=auto';
        var resText;
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                resText = doc.responseText;
                parseBD(resText);
            }
        }
        doc.open('GET', bdurl, true);
        doc.send();
    }

    function parseBD(resText) {
        var jsonObj = JSON.parse(resText);

        if(typeof jsonObj == 'object' && typeof jsonObj.trans_result == 'object') {
            desresult += '<b>百度翻译</b>:<br /><br />原文: ' + jsonObj.trans_result[0].src + '<br /><br />译文: ' + jsonObj.trans_result[0].dst;
        }
        parseDone();
    }
    //End of Baidu

    //Beginning of iCiBa
    XmlListModel {
        id: cbModel;
        query: '/dict';

        XmlRole { name: 'pho1'; query: 'ps[1]/string()' }
        XmlRole { name: 'pho2'; query: 'ps[2]/string()' }
        XmlRole { name: 'ex1'; query: 'acceptation[1]/string()' }
        XmlRole { name: 'ex2'; query: 'acceptation[2]/string()' }
        XmlRole { name: 'ex3'; query: 'acceptation[3]/string()' }
        XmlRole { name: 'pos1'; query: 'pos[1]/string()' }
        XmlRole { name: 'pos2'; query: 'pos[2]/string()' }
        XmlRole { name: 'pos3'; query: 'pos[3]/string()' }
        XmlRole { name: 'seno1'; query: 'sent[1]/orig/string()' }
        XmlRole { name: 'seno2'; query: 'sent[2]/orig/string()' }
        XmlRole { name: 'seno3'; query: 'sent[3]/orig/string()' }
        XmlRole { name: 'sent1'; query: 'sent[1]/trans/string()' }
        XmlRole { name: 'sent2'; query: 'sent[2]/trans/string()' }
        XmlRole { name: 'sent3'; query: 'sent[3]/trans/string()' }

        onCountChanged: parseCB();
    }

    function queryCB(words) {
        if(iciba_key == '')  displayText.text = i18n('iCiBa API key is empty.<br /><a href="https://github.com/librehat/kdictionary#advanced-usage">Help?</a>');
        else {
            var cburl = 'http://dict-co.iciba.com/api/dictionary.php?w=' + words + '&key=' + iciba_key;
            cbModel.source = cburl;
            console.log(cburl);
        }
    }

    function parseCB() {
        if(cbModel.get(0).pho1 != '')  desresult += '<b>发音:</b> <i>/' + cbModel.get(0).pho1 + '/   /' + cbModel.get(0).pho2 + '/</i><br /><br />'//TODO i18n
        if(cbModel.get(0).ex1 != '')  desresult += '<b>金山词霸:</b><br />' + cbModel.get(0).pos1 + ' ' + cbModel.get(0).ex1 + '<br />' + cbModel.get(0).pos2 + ' ' + cbModel.get(0).ex2 + '<br />' + cbModel.get(0).pos3 + ' ' + cbModel.get(0).ex3 + '<br /><br />';//TODO i18n
        if(showSentences && cbModel.get(0).seno1 != '')  desresult += '<b>例句:</b><br />' + cbModel.get(0).seno1 + '<br />' + cbModel.get(0).sent1 + '<br />' + cbModel.get(0).seno2 + '<br />' + cbModel.get(0).sent2 + '<br />' + cbModel.get(0).seno3 + '<br />' + cbModel.get(0).sent3;//TODO i18n
        parseDone();
    }
    //End of iCiBa
}