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
    id: mwcdAPI;

    XmlListModel {//Merriam-Webster's Collegiate® Dictionary XML Model
        id: mwcdModel;
        query: '/entry_list/entry';

        XmlRole { name: 'pho'; query: 'pr/string()' }
        XmlRole { name: 'fl'; query: 'fl/string()' }
        XmlRole { name: 'lb'; query: 'lb/string()' }
        XmlRole { name: 'origin'; query: 'et/string()' }//Origin
        //XmlRole { name: 'date'; query: 'def/date/string()' }//why keep date under def?
        XmlRole { name: 'def'; query: 'def/string()' }

        onCountChanged: parseMWCD();
    }

    function queryMWCD(words) {
        mwcdModel.source = 'http://www.dictionaryapi.com/api/v1/references/collegiate/xml/' + words + '?key=51027fa3-3ded-4e50-b572-a0f1ed89de41';
    }

    function parseMWCD() {
        for(var i=0; i<mwcdModel.count; i++) {
            mainWindow.desresult += '<h4>' + i18n('Definition') + ' ' + (i+1) + '</h4>';
            if (mwcdModel.get(i).pho != '')  mainWindow.desresult += '<b>' + i18n('Phonetic:') + '</b> <i>/' + mwcdModel.get(i).pho + '/</i><br />';
            if (mwcdModel.get(i).fl != '')  mainWindow.desresult += mwcdModel.get(i).fl;
            if (mwcdModel.get(i).lb != '')  mainWindow.desresult += ', ' + mwcdModel.get(i).lb;
            mainWindow.desresult += '<br />';
            if (mwcdModel.get(i).def != '')  mainWindow.desresult+= '<b>' + i18n('Definitions:') + '</b><br />' + mwcdModel.get(i).def.replace(/\s\d\s+:?/g, "<br />✒ ").replace(/\b(a|b|c)\s+:/g, " ✽ ").replace(/\s+:\b/g, ": ") + '<br />';
            if (mwcdModel.get(i).origin != '')  mainWindow.desresult += '<b>' + i18n('Origin:') + '</b><br />' + mwcdModel.get(i).origin + '<br />';
            mainWindow.desresult += '<br />';
        }
        mainWindow.parseDone();
    }
}
