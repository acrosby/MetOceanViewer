/*-------------------------------GPL-------------------------------------//
//
// MetOcean Viewer - A simple interface for viewing hydrodynamic model data
// Copyright (C) 2015  Zach Cobell
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//-----------------------------------------------------------------------*/
#ifndef MOV_KEYHANDLER_H
#define MOV_KEYHANDLER_H

#include <QObject>

class MovKeyhandler : public QObject {
  Q_OBJECT

public:
  MovKeyhandler(QObject *parent = nullptr);

protected:
  bool eventFilter(QObject *obj, QEvent *event);

signals:
  void enterKeyPressed();
};

#endif // MOV_KEYHANDLER_H
