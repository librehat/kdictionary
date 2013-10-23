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
    id: qqdictAPI;

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
                if (typeof localdes[0].pho == 'object') {
                    main.desresult += i18n('<b>Phonetic:</b> ') + '<i>/' + localdes[0].pho[0] + '/</i><br /><br />';
                }
                
                if (typeof localdes[0].des == 'object' && typeof localdes[0].des[0] == 'object') {
                    main.desresult += i18n('<b>Definitions:</b>') + '<br />';
                    for (var i=0;;i++){//get all of them
                        if (typeof localdes[0].des[i] != 'object') {main.desresult += '<br />';break;}
                        main.desresult += localdes[0].des[i].p + ' ' + localdes[0].des[i].d + '<br />';//don't bold it, make it the same style as YOUDAO
                    }}
                    
                    if (showSentences && typeof localdes[0].sen == 'object' && typeof localdes[0].sen[0] == 'object') {
                        main.desresult += i18n('<b>Examples:</b>') + '<br />';
                        for (var i=0;;i++){
                            if (typeof localdes[0].sen[0].s[i] != 'object') {main.desresult += '<br />';break;}
                            main.desresult += localdes[0].sen[0].s[i].es + '<br />' + localdes[0].sen[0].s[i].cs + '<br />';
                        }}
                        
                        if (typeof localdes[0].mor == 'object' && typeof localdes[0].mor[0] == 'object') {
                            main.desresult += i18n('<b>Morphology:</b>') + '<br />';
                            for (var i=0;;i++){//get all of them
                                if (typeof localdes[0].mor[i] != 'object') {main.desresult += '<br />';break;}
                                main.desresult += localdes[0].mor[i].c + ' ' + localdes[0].mor[i].m + '<br />';
                            }}
                            
                            if (typeof localdes[0].syn == 'object' && typeof localdes[0].syn[0] == 'object') {
                                main.desresult += i18n('<b>Synonym:</b>') + '<br />';
                                for (var i=0;;i++){//get all of them
                                    if (typeof localdes[0].syn[i] != 'object') {main.desresult += '<br />';break;}
                                    main.desresult += localdes[0].syn[i].p + ' ' + localdes[0].syn[i].c + '<br />';
                                }}
                                
                                if (showPhrases && typeof localdes[0].ph == 'object' && typeof localdes[0].ph[0] == 'object') {
                                    main.desresult += i18n('<b>Phrases:</b>') + '<br />';
                                    for (var i=0;;i++){//get all of them
                                        if (typeof localdes[0].ph[i] != 'object') {main.desresult += '<br />';break;}
                                        main.desresult += localdes[0].ph[i].phs + '<br />' + localdes[0].ph[i].phd + '<br />';
                                    }}
            }
            
            if (showWebdict &&  typeof netdes == 'object' && typeof netdes[0] == 'object' && typeof netdes[0].des == 'object') {
                main.desresult += i18n('<b>Web Definitions:</b>') + '<br />';
                for (var i=0 ; i<5 ; i++) {//5 is enough for netdes for it's often ridiculous
                    if (typeof netdes[0].des[i] != 'object') {main.desresult += '<br />';break;}
                    main.desresult += netdes[0].des[i].d + ' ; ';
                }}
                
                if (showBaike && typeof baike == 'object' && typeof baike[0] == 'object' && baike[0].link != '') {
                    main.desresult += '<br /><a href="' + baike[0].link + i18n('">SOSO Baike</a>');
                }
        }
        main.parseDone();
    }
}