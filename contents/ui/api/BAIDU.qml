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
    id: baiduAPI;

    function queryBD(words) {
        if(baidu_key == '')  displayText.text = i18n('Baidu API key is empty.') + '<br /><a href="https://github.com/librehat/kdictionary#baidu">' + i18n('Help?') + '</a>';
            else {
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
    }

    function parseBD(resText) {
        var jsonObj = JSON.parse(resText);

        if (typeof jsonObj == 'object') {
            if (typeof jsonObj.trans_result == 'object')// if something went wrong it won't be an object.
                mainWindow.desresult += '<b>' + i18n('Baidu Translation:') + '</b><br /><br />' + i18n('Original: ') + jsonObj.trans_result[0].src + '<br /><br />' + i18n('Translation: ') + jsonObj.trans_result[0].dst;
            else {
                switch (jsonObj.error_code) {
                    case '52001':  { mainWindow.desresult += i18n('Timeout.'); break; }
                    case '52002':  { mainWindow.desresult += i18n('Remote server error.'); break; }
                    case '52003':  { mainWindow.desresult += i18n('Invalid key.'); break; }
                    default: { mainWindow.desresult += i18n('Unknown error.'); break; }
                }
            }
        }
        mainWindow.parseDone();
    }
}
