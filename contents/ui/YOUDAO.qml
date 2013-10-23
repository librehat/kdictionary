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
        if (ydModel.get(0).phonetic != '')  main.desresult += i18n('<b>Phonetic:</b> <i>/') + ydModel.get(0).phonetic + '/</i><br /><br />'
            if (ydModel.get(0).explains != '')  main.desresult += i18n('<b>Definitions:</b><br />') + ydModel.get(0).explains + '<br /><br />';
            if (ydModel.get(0).translation != '')  main.desresult += i18n('<b>Translation:</b><br />') + ydModel.get(0).translation + '<br /><br />';
            if (showWebdict && ydModel.get(0).webkey != '')  main.desresult += i18n('<b>Web Definitions:</b><br />') + ydModel.get(0).webkey + ': ' + ydModel.get(0).web + '<br />' + ydModel.get(0).webkey2 + ': ' + ydModel.get(0).web2 + '<br />' + ydModel.get(0).webkey3 + ': ' + ydModel.get(0).web3;
            main.parseDone();
    }
}
