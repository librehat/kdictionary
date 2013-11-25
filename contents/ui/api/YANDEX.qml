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
    id: yandex_API;

    XmlListModel {//TODO maybe we need a nested list model to get child elements
        id: model;
        query: '/DicResult/def';
        
        XmlRole { name: 'pos'; query: '@pos/string()' }
        XmlRole { name: 'phonetic'; query: '@ts/string()' }
        XmlRole { name: 'tr1_pos'; query: 'tr[1]/@pos/string()' }
        XmlRole { name: 'tr1_txt'; query: 'tr[1]/text/string()' }
        //XmlRole { name: 'tr1_syn' ; query: 'tr[1]/syn/string()' }
        XmlRole { name: 'tr1_extx'; query: 'tr[1]/ex[1]/text/string()' }//Only get one sentence example until a more smart list model is used.
        XmlRole { name: 'tr1_extr'; query: 'tr[1]/ex[1]/tr/text/string()' }
        XmlRole { name: 'tr2_pos' ; query: 'tr[2]/@pos/string()' }
        XmlRole { name: 'tr2_txt'; query: 'tr[2]/text/string()' }
        //XmlRole { name: 'tr2_syn' ; query: 'tr[2]/syn/string()' }
        XmlRole { name: 'tr2_extx'; query: 'tr[2]/ex[1]/text/string()' }
        XmlRole { name: 'tr2_extr'; query: 'tr[2]/ex[1]/tr/text/string()' }
        XmlRole { name: 'tr3_pos' ; query: 'tr[3]/@pos/string()' }
        XmlRole { name: 'tr3_txt'; query: 'tr[3]/text/string()' }
        //XmlRole { name: 'tr3_syn' ; query: 'tr[3]/syn/string()' }
        XmlRole { name: 'tr3_extx'; query: 'tr[3]/ex[1]/text/string()' }
        XmlRole { name: 'tr3_extr'; query: 'tr[3]/ex[1]/tr/text/string()' }

        onCountChanged: parse();
    }

    function query(word, type) {
        var url="https://dictionary.yandex.net/api/v1/dicservice/lookup?key=" + mainWindow.yandex_key + "&text=" + word;
        switch(type) {
            case 0://Russian-English
            {
                url += "&lang=ru-en";
                break;
            }
            case 1://English-Russian
            default:
            {
                url += "&lang=en-ru";
                break;
            }
        }
        model.source = url;
    }

    function parse() {
        for (i=0; i<model.count; i++) {
            mainWindow.desresult += '<h4>' + i18n('Definition') + ' ' + (i+1) + '</h4>';
            if (model.get(i).pos != '')
                mainWindow.desresult += '[' + model.get(i).pos + ']  ';
            if (model.get(i).phonetic != '')
                mainWindow.desresult += '<i>/' + model.get(i).phonetic + '/</i>';
            mainWindow.desresult += '<br />'
            
            if (model.get(i).tr1_pos != '')
                mainWindow.desresult += '[' + model.get(i).tr1_pos + ']  ';
            if (model.get(i).tr1_txt != '')
                mainWindow.desresult += model.get(i).tr1_txt + '<br />';
            //if (model.get(i).tr1_syn != '')
                //mainWindow.desresult += '<b>' + i18n('Synonym:') + '</b><br />' + model.get(i).tr1_syn + '<br /><br />';
            if (mainWindow.showSentences && model.get(i).tr1_extx != '')
                mainWindow.desresult += '✒ ' + model.get(i).tr1_extx + '<br />✑ ' + model.get(i).tr1_extr + '<br />';
            mainWindow.desresult += '<br />'
            if (model.get(i).tr2_pos != '')
                mainWindow.desresult += '[' + model.get(i).tr2_pos + ']  ';
            if (model.get(i).tr2_txt != '')
                mainWindow.desresult += model.get(i).tr2_txt + '<br />';
            //if (model.get(i).tr2_syn != '')
                //mainWindow.desresult += '<b>' + i18n('Synonym:') + '</b><br />' + model.get(i).tr2_syn + '<br /><br />';
            if (mainWindow.showSentences && model.get(i).tr2_extx != '')
                mainWindow.desresult += '✒ ' + model.get(i).tr2_extx + '<br />✑ ' + model.get(i).tr2_extr + '<br />';
            mainWindow.desresult += '<br />'
            if (model.get(i).tr3_pos != '')
                mainWindow.desresult += '[' + model.get(i).tr3_pos + ']  ';
            if (model.get(i).tr3_txt != '')
                mainWindow.desresult += model.get(i).tr3_txt + '<br />';
            //if (model.get(i).tr3_syn != '')
                //mainWindow.desresult += '<b>' + i18n('Synonym:') + '</b><br />' + model.get(i).tr3_syn + '<br /><br />';
            if (mainWindow.showSentences && model.get(i).tr3_extx != '')
                mainWindow.desresult += '✒ ' + model.get(i).tr3_extx + '<br />✑ ' + model.get(i).tr3_extr + '<br />';
        }
        mainWindow.desresult += '<br /><a href="http://api.yandex.com/dictionary/">' + i18n('Powered by Yandex.Dictionary') + '</a>';
        mainWindow.parseDone();
    }
}