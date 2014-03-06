// -*- coding: utf-8 -*-
/*
 *   Copyright (C) 2013-2014 by William Wong <librehat@outlook.com>
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
    id: iCiBaAPI;

    XmlListModel {//Kingsoft PowerWord iCiBa
        id: cbModel;
        query: '/dict';

        XmlRole { name: 'pho1'; query: 'ps[1]/string()' }
        XmlRole { name: 'pho2'; query: 'ps[2]/string()' }
        XmlRole { name: 'ex1'; query: 'acceptation[1]/string()' }
        XmlRole { name: 'ex2'; query: 'acceptation[2]/string()' }
        XmlRole { name: 'ex3'; query: 'acceptation[3]/string()' }
        XmlRole { name: 'pos1'; query: 'pos[1]/string()' }
        XmlRole { name: 'pos2'; query: 'pos[2]/string()' }
        XmlRole { name: 'pos3'; query: 'pos[3]/string()' }
        XmlRole { name: 'seno1'; query: 'sent[1]/orig/string()' }
        XmlRole { name: 'seno2'; query: 'sent[2]/orig/string()' }
        XmlRole { name: 'seno3'; query: 'sent[3]/orig/string()' }
        XmlRole { name: 'sent1'; query: 'sent[1]/trans/string()' }
        XmlRole { name: 'sent2'; query: 'sent[2]/trans/string()' }
        XmlRole { name: 'sent3'; query: 'sent[3]/trans/string()' }

        onCountChanged: parseCB();
    }

    function queryCB(words) {
        cbModel.source = 'http://dict-co.iciba.com/api/dictionary.php?w=' + words + '&key=40AAB9CEFD02DA381C2DCB7A512BCB0F';
    }

    function parseCB() {
        if (cbModel.get(0).pho1 != '')
            mainWindow.desresult += '<b>' + i18n('Phonetic:') + '</b> <i>/' + cbModel.get(0).pho1 + '/   /' + cbModel.get(0).pho2 + '/</i><br /><br />'
        if (cbModel.get(0).ex1 != '')
            mainWindow.desresult += '<b>' + i18n('Definitions:') + '</b><br />' + cbModel.get(0).pos1 + ' ' + cbModel.get(0).ex1 + '<br />' + cbModel.get(0).pos2 + ' ' + cbModel.get(0).ex2 + '<br />' + cbModel.get(0).pos3 + ' ' + cbModel.get(0).ex3 + '<br /><br />';
        if (mainWindow.showSentences && cbModel.get(0).seno1 != '')
            mainWindow.desresult += '<b>' + i18n('Examples:') + '</b><br />✒ ' + cbModel.get(0).seno1 + '<br />✑ ' + cbModel.get(0).sent1 + '<br />✒ ' + cbModel.get(0).seno2 + '<br />✑ ' + cbModel.get(0).sent2 + '<br />✒ ' + cbModel.get(0).seno3 + '<br />✑ ' + cbModel.get(0).sent3;
            mainWindow.parseDone();
    }
}