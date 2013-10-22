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
        spacing: 6;
        anchors { left: parent.left; right: parent.right }

        QIconItem {
            icon: QIcon('accessories-dictionary');
            width: 22;
            height: 22;
        }

        PlasmaComponents.TextField {
            id: inputEntry;
            placeholderText: i18n('<i>Enter word(s) here</i>');
            width: parent.width - 22 - headrow.spacing;//22:QIconItem's width
            maximumLength: 140; //Limit the maximum length
            //font.pointSize: 10; //Use plasma theme settings
            clearButtonShown: true;
            focus: true;
            onTextChanged: autoClear();
            
            Keys.onPressed: {
                if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return)
                    if (inputEntry.text != '') {
                        displayText.text = i18n('Loading...');//it's not instantaneous!
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
                        }
                    }
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

    function autoClear() {//clear once text input changed
        var ac = plasmoid.readConfig('autoClear') + 1 - 1;//stupid QML!!! Can't tolerate it longer!
        if( ac )
            displayText.text = "";
    }
    
    //Beginning of QQ Dictionary
    function queryQQ(words) {
        var qqurl = 'http://dict.qq.com/dict?q=' + words;
        var resText;
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                resText = doc.responseText;
                parseQQdict(resText);
            }
        }
        doc.open('GET', qqurl, true);
        doc.send();
    }
    
    function parseQQdict(resText) {
        var jsonObj = JSON.parse(resText);//Generate JSON Object
        var desresult = '';
        
        if (typeof jsonObj == 'object') {
            var localdes = jsonObj.local;
            var netdes = jsonObj.netdes[0];
            
            if (typeof localdes == 'object' && typeof localdes[0] == 'object') {
                
                if(typeof localdes[0].pho == 'object') {
                    desresult += '<b>发音:</b> ' + '<i>/' + localdes[0].pho[0] + '/</i><br /><br />';//TODO i18n
                }
                
                if(typeof localdes[0].des == 'object') {
                desresult += '<b>本地释义:</b> ' + '<br />';//TODO i18n
                    for (var i=0 ; i<10 ; i++){
                        if(typeof localdes[0].des[i] != 'object')       break;
                        desresult += '<b>' + localdes[0].des[i].p + '</b> '+ localdes[0].des[i].d + '<br />';
                    }
                }
                
                if(typeof localdes[0].sen == 'object') {
                    desresult += '<br /><b>例句:</b> ' + '<br />';//TODO i18n
                    for (var i=0 ; i<3 ; i++){//TODO maximum number could be set by user
                        if(typeof localdes[0].sen[0].s[i] != 'object')      break;
                        desresult += localdes[0].sen[0].s[i].es + '<br />' + localdes[0].sen[0].s[i].cs + '<br />';
                    }
                }
                
                desresult += '<br />';
            }
            else    console.log ('localdes is not an object. Its type is:' + typeof localdes);
            
            if (typeof netdes == 'object') {
                desresult += '<b>网络释义:</b>' + '<br />';//TODO i18n
                for (var i=0 ; i<5 ; i++) {
                    if(typeof netdes.des[i] != 'object')       break;
                    desresult += netdes.des[i].d + ' ; ';
                }
            }
            else    console.log ('netdes is not an object. Its type is:' + typeof netdes);
            
        }
        else    console.log ('jsonObj is not an object. Its type is:' + typeof jsonObj);
        
        if (desresult != '')    displayText.text = desresult;
        else    displayText.text = i18n('No result.');
    }
    
    //End of QQ Dictionary
    
    //Beginning of YOUDAO Fanyi
    XmlListModel {
        id: ydModel;
        query: '/youdao-fanyi';
        
        XmlRole { name: 'translation'; query: 'translation/string()' }//YOUDAO Translation
        XmlRole { name: 'phonetic'; query: 'basic/phonetic/string()' }//YOUDAO Basic Dictionary
        XmlRole { name: 'explains'; query: 'basic/explains/string()' }
        XmlRole { name: 'webkey' ; query: 'web/explain[1]/key/string() '}//YOUDAO Web Dictionary
        XmlRole { name: 'web'; query: 'web/explain[1]/value/string()' }
        XmlRole { name: 'webkey2' ; query: 'web/explain[2]/key/string() '}
        XmlRole { name: 'web2'; query: 'web/explain[2]/value/string()' }
        XmlRole { name: 'webkey3' ; query: 'web/explain[3]/key/string() '}
        XmlRole { name: 'web3'; query: 'web/explain[3]/value/string()' }
        
        onCountChanged: getYD();
    }
    
    function queryYD(words) {
        var ydkey = '&key=' + plasmoid.readConfig('youdao_key');//Ensure it's string
        var ydname = '?keyfrom=' + plasmoid.readConfig('youdao_name');//Ensure it's string
        
        if( ydkey == '' || ydname == '' )       displayText.text = i18n('API key is empty.<br />Please follow instructions in <u>kdictionary/contents/code/youdaoapi.js</u>');
        else {
            var ydurl = 'http://fanyi.youdao.com/openapi.do' + ydname + ydkey+ '&type=data&doctype=xml&version=1.1&q=' + words;
            console.log(ydurl);
            ydModel.source = ydurl;
        }
    }
    
    function getYD() {
        var yddes = '';
        if( ydModel.get(0).phonetic != '' )     yddes += '<b>发音:</b> <i>/' + ydModel.get(0).phonetic + '/</i><br /><br />'//TODO i18n
        if( ydModel.get(0).explains != '' )     yddes += '<b>基本词典:</b><br />' + ydModel.get(0).explains + '<br /><br />';//TODO i18n
        if( ydModel.get(0).translation != '')   yddes += '<b>有道翻译:</b><br />' + ydModel.get(0).translation + '<br /><br />';//TODO i18n
        if( ydModel.get(0).webkey != '' )       yddes += '<b>网络释义:</b><br />' + ydModel.get(0).webkey + ': ' + ydModel.get(0).web + '<br />' + ydModel.get(0).webkey2 + ': ' + ydModel.get(0).web2 + '<br />' + ydModel.get(0).webkey3 + ': ' + ydModel.get(0).web3;//TODO i18n
        displayText.text = yddes;
    }
    //End of YOUDAO Fanyi
}