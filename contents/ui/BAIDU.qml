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
        if(baidu_key == '')  displayText.text = i18n('Baidu API key is empty.<br /><a href="https://github.com/librehat/kdictionary#advanced-usage">Help?</a>');
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
        
        if (typeof jsonObj == 'object' && typeof jsonObj.trans_result == 'object') {
            main.desresult += i18n('<b>Baidu Translation</b>:<br /><br />Original: ') + jsonObj.trans_result[0].src + i18n('<br /><br />Translation: ') + jsonObj.trans_result[0].dst;
        }
        main.parseDone();
    }
}
