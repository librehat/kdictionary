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
        if (mwcd_key == '') displayText.text = i18n("Merriam-Webster's Collegiate® Dictionary API key is empty.<br /><a href='https://github.com/librehat/kdictionary#advanced-usage'>Help?</a>");
            else {
                var mwcdurl = 'http://www.dictionaryapi.com/api/v1/references/collegiate/xml/' + words + '?key=' + mwcd_key;
                mwcdModel.source = mwcdurl;
            }
    }

    function parseMWCD() {
        for(var i=0; i<mwcdModel.count; i++) {
            main.desresult += i18n('<b>Entry ') + (i+1) + ':</b><br />';
            if (mwcdModel.get(i).pho != '')  main.desresult += i18n('<b>Phonetic:</b> <i>/') + mwcdModel.get(i).pho + '/</i><br />';
            if (mwcdModel.get(i).fl != '')  main.desresult += mwcdModel.get(i).fl;
            if (mwcdModel.get(i).lb != '')  main.desresult += ', ' + mwcdModel.get(i).lb;
            main.desresult += '<br />';
            if (mwcdModel.get(i).def != '')  main.desresult+= i18n('<b>Definitions:</b><br />') + mwcdModel.get(i).def + '<br />';
            if (mwcdModel.get(i).origin != '')  main.desresult += i18n('<b>Origin:</b><br />') + mwcdModel.get(i).origin + '<br />';
            main.desresult += '<br />';
        }
        main.desresult += i18n("<i>Powered by Merriam-Webster's Collegiate® Dictionary</i>");
        main.parseDone();
    }
}
