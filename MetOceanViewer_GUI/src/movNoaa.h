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

#ifndef MOV_NOAA_H
#define MOV_NOAA_H

#include <QChartView>
#include <QNetworkInterface>
#include <QPrinter>
#include <QQuickWidget>
#include <QUrl>
#include <QVector>
#include <QWebEngineView>
#include <QtCharts>
#include <QtNetwork>
#include <QtWebEngine/QtWebEngine>
#include "movErrors.h"
#include "stationmodel.h"
#include "timezone.h"

//...Forward declare classes
class MovQChartView;
class MovImeds;

using namespace QtCharts;

class MovNoaa : public QObject {
  Q_OBJECT

 public:
  //...Constructor
  explicit MovNoaa(QQuickWidget *inMap, MovQChartView *inChart,
                   QDateEdit *inStartDateEdit, QDateEdit *inEndDateEdit,
                   QComboBox *inNoaaProduct, QComboBox *inNoaaUnits,
                   QComboBox *inNoaaDatum, QStatusBar *inStatusBar,
                   QComboBox *inNoaaTimezoneLocation, QComboBox *inNoaaTimezone,
                   StationModel *m_stationModel, QString *m_selectedStation,
                   QObject *parent = nullptr);

  //...Destructor
  ~MovNoaa();

  //...Public Functions
  int plotNOAAStation();
  int saveNOAAImage(QString filename, QString filter);
  int saveNOAAData(QString filename, QString PreviousDirectory, QString format);
  int getLoadedNOAAStation();
  int getClickedNOAAStation();
  QString getNOAAErrorString();
  int replotChart(Timezone *newTimezone);
  void setActiveMarker(QString marker);
  static void addStationsToModel(StationModel *model);

 signals:
  void noaaError(QString);

 private:
  //...Private Functions
  int formatNOAAResponse(QVector<QByteArray> input, QString &error, int index);
  void readNOAAResponse(QNetworkReply *reply, int index, int index2);
  int fetchNOAAData();
  int prepNOAAResponse();
  int getNoaaProductId(QString &product1, QString &product2);
  int getNoaaProductLabel(QString &product);
  int getNoaaProductSeriesNaming(QString &product1, QString &product2);
  QString getDatumLabel();
  QString getUnitsLabel();
  int getDataBounds(double &ymin, double &ymax);
  int generateLabels();
  int plotChart();

  //...Private Variables
  QVector<QVector<QByteArray>> m_webData;
  int m_productIndex;

  QString m_datum;
  QString m_units;
  QString m_ylabel;
  QString m_plotTitle;
  QString m_errorString;

  QDateTime m_startDate;
  QDateTime m_endDate;

  QVector<MovImeds *> m_currentStationData;
  QVector<QString> m_errorStringVec;

  Timezone *tz;
  int m_offsetSeconds;
  int m_priorOffsetSeconds;
  int m_loadedStationId;

  //...Pointers to GUI elements
  QQuickWidget *m_quickMap;
  MovQChartView *m_chartView;
  QDateEdit *m_startDateEdit, *m_endDateEdit;
  QComboBox *m_comboProduct, *m_comboUnits, *m_comboDatum,
      *m_comboTimezoneLocation, *m_comboTimezone;
  QStatusBar *m_statusBar;
  StationModel *m_stationModel;
  Station m_station;
  QString *m_selectedStation;
};

#endif  // MOV_NOAA_H
