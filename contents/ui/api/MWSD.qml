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
    id: mwsdAPI;

    XmlListModel {
        id: mwsdModel;
        query: '/entry_list/entry';

        XmlRole { name: 'pho'; query: 'pr/string()' }
        XmlRole { name: 'fl'; query: 'fl/string()' }
        XmlRole { name: 'def'; query: 'def/string()' }

        onCountChanged: parseMWSD();
    }

    function query(words) {
        if (mwsd_key == '') displayText.text = i18n("Merriam-Webster's Spanish-English Dictionary API key is empty.") + '<br /><a href="https://github.com/librehat/kdictionary#merriam-websters-spanish-dictionary">' + i18n('Help?') + '</a>';
        else {
            var mwsdurl = 'http://www.dictionaryapi.com/api/v1/references/spanish/xml/' + words + '?key=' + mwsd_key;
            mwsdModel.source = mwsdurl;
        }
    }

    function parseMWSD() {
        for(var i=0; i<mwsdModel.count; i++) {
            mainWindow.desresult += '<h4>' + i18n('Definition') + ' ' + (i+1) + '</h4>';
            if (mwsdModel.get(i).pho != '')
                mainWindow.desresult += '<b>' + i18n('Phonetic:') + '</b> <i>/' + mwsdModel.get(i).pho + '/</i><br />';
            if (mwsdModel.get(i).fl != '')
                mainWindow.desresult += mwsdModel.get(i).fl;
            mainWindow.desresult += '<br />';
            if (mwsdModel.get(i).def != '')
                //definition output is a mess. do the best to adjust it.
                mainWindow.desresult+= '<b>' + i18n('Definitions:') + '</b><br />' + mwsdModel.get(i).def.replace(/\s1\s+:?/, "✒ ").replace(/\s\d\s+:?/g, "<br />✒ ").replace(/\s+:\s?\b/g, ": ") + '<br />';
            mainWindow.desresult += '<br />';
        }
        mainWindow.desresult += '<i>' + i18n("Powered by Merriam-Webster's Spanish-English Dictionary") + '</i>';
        mainWindow.parseDone();
    }
}
