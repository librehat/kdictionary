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

Item {
    id: youdaoAPI;

    XmlListModel {
        id: ydModel;
        query: '/youdao-fanyi';

        XmlRole { name: 'errcode'; query: 'errorCode/string()' }
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
        if (youdao_key == '' || youdao_name == '')  displayText.text = i18n('YouDao API key is empty.') + '<br /><a href="https://github.com/librehat/kdictionary#youdao">' + i18n('Help?') + '</a>';
            else {
                var ydurl = 'http://fanyi.youdao.com/openapi.do?keyfrom=' + youdao_name + '&key=' + youdao_key + '&type=data&doctype=xml&version=1.1&q=' + words;
                ydModel.source = ydurl;
            }
    }

    function parseYD() {
        if (ydModel.get(0).errcode != '0') {
            switch (ydModel.get(0).errcode) {
                case '20': { mainWindow.desresult += i18n('The input text is too long.'); break; }
                case '30': { mainWindow.desresult += i18n('Cannot translate it correctly.'); break; }
                case '40': { mainWindow.desresult += i18n('Unsupported language.'); break; }
                case '50': { mainWindow.desresult += i18n('Invalid key.'); break; }
                default: mainWindow.desresult += i18n('Unknown error.');
            }
            mainWindow.parseDone();
            return;//stop it
        }
        
        if (ydModel.get(0).phonetic != '')
            mainWindow.desresult += '<b>' + i18n('Phonetic:') + '</b> <i>/' + ydModel.get(0).phonetic + '/</i><br /><br />'
        if (ydModel.get(0).explains != '')
            mainWindow.desresult += '<b>' + i18n('Definitions:') + '</b><br />' + ydModel.get(0).explains + '<br /><br />';
        if (ydModel.get(0).translation != '')
            mainWindow.desresult += '<b>' + i18n('Translation:') + '</b><br />'  + ydModel.get(0).translation + '<br /><br />';
        if (showWebdict && ydModel.get(0).webkey != '')
            mainWindow.desresult += '<b>' + i18n('Web Definitions:') + '</b><br />' + ydModel.get(0).webkey + i18n(': ') + ydModel.get(0).web + '<br />' + ydModel.get(0).webkey2 + i18n(': ') + ydModel.get(0).web2 + '<br />' + ydModel.get(0).webkey3 + i18n(': ') + ydModel.get(0).web3;
            mainWindow.parseDone();
    }
}
