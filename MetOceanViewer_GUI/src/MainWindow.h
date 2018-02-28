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

#ifndef MOV_MAINWINDOW_H
#define MOV_MAINWINDOW_H

#include <QColorDialog>
#include <QFileDialog>
#include <QMainWindow>
#include <QNetworkInterface>
#include <QUrl>
#include <QVector>
#include <QtCharts>
#include <QtNetwork>
#include <QtWebEngineWidgets>

//...Forward declarations of classes
class MovNoaa;
class MovUsgs;
class MovHwm;
class movXtide;
class MovUserTimeseries;
class MovQWebEnginePage;
class MovSession;

//-------------------------------------------//
// Main class used by the Qt program that holds
// the main set of functions used
//-------------------------------------------//
namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow {
  Q_OBJECT

public:
  explicit MainWindow(bool processCommandLine, QString commandLineFile,
                      QWidget *parent = nullptr);

  ~MainWindow();

  void setLoadSessionFile(bool toggle, QString sessionFile = QString());

  QString PreviousDirectory;

private slots:

  void throwErrorMessageBox(QString);

  void setupMetOceanViewerUI();

  void on_Button_FetchData_clicked();

  void on_Combo_NOAAPanTo_currentIndexChanged(int index);

  void on_button_noaasavechart_clicked();

  void on_button_noaasavedata_clicked();

  void on_button_saveTimeseriesImage_clicked();

  void on_check_TimeseriesYauto_toggled(bool checked);

  void on_browse_hwm_clicked();

  void on_button_processHWM_clicked();

  void on_check_manualHWM_toggled(bool checked);

  void on_button_saveHWMMap_clicked();

  void on_button_hwmcolor_clicked();

  void on_button_121linecolor_clicked();

  void on_button_reglinecolor_clicked();

  void on_button_boundlinecolor_clicked();

  void on_actionQuit_triggered();

  void on_button_TimeseriesDeleteRow_clicked();

  void on_button_TimeseriesAddRow_clicked();

  void on_button_TimeseriesCopyRow_clicked();

  void on_button_TimeseriesEditRow_clicked();

  void on_button_processTimeseriesData_clicked();

  void on_check_TimeseriesAllData_toggled(bool checked);

  void on_button_fitHWM_clicked();

  void on_button_fitTimeseries_clicked();

  void on_button_plotTimeseriesStation_clicked();

  void on_actionAbout_triggered();

  void on_actionLoad_Session_triggered();

  void on_actionSave_Session_triggered();

  void on_actionSave_Session_As_triggered();

  void on_combo_usgs_panto_currentIndexChanged(int index);

  void on_button_usgs_fetch_clicked();

  void on_button_usgssavemap_clicked();

  void on_button_usgssavedata_clicked();

  void on_combo_USGSProduct_currentIndexChanged(int index);

  void on_radio_usgsDaily_clicked();

  void on_radio_usgshistoric_clicked();

  void on_radio_usgs_instant_clicked();

  void on_check_regressionColorMatch_clicked(bool checked);

  void on_button_moveRowUp_clicked();

  void on_button_moveRowDown_clicked();

  void on_combo_NOAAProduct_currentIndexChanged(int index);

  void handleEnterKey();

  void on_button_saveHWMScatter_clicked();

  void on_button_noaaresetzoom_clicked();

  void on_button_usgsresetzoom_clicked();

  void on_button_usertimeseriesResetZoom_clicked();

  void on_button_hwmResetZoom_clicked();

  void on_actionCheck_For_Updates_triggered();

  void on_button_xtide_compute_clicked();

  void on_button_xtide_resetzoom_clicked();

  void on_combo_xtide_panto_activated(const QString &arg1);

  void on_button_xtide_savemap_clicked();

  void on_button_xtide_savedata_clicked();

  void on_pushButton_displayOptions_clicked();

  void on_button_noaaOptions_clicked();

  void on_button_usgsOptions_clicked();

  void on_button_xTideOptions_clicked();

  void on_button_hwmOptions_clicked();

private:
  Ui::MainWindow *ui;

  QList<QTableWidgetItem *> grabTableRow(int row);

  void setTableRow(int row, const QList<QTableWidgetItem *> &rowItems);

  void SetupTimeseriesTable();

  bool confirmClose();

  void plotNOAAStation();

  void plotXTideStation();

  QPointer<MovNoaa> thisNOAA;

  QPointer<MovUsgs> thisUSGS;

  QPointer<MovHwm> thisHWM;

  QPointer<movXtide> thisXTide;

  MovSession *sessionState;

  QPointer<MovUserTimeseries> thisTimeseries;

  QPointer<MovQWebEnginePage> noaa_page;

  QPointer<MovQWebEnginePage> usgs_page;

  QPointer<MovQWebEnginePage> xtide_page;

  QColor DotColorHWM, LineColorRegression, LineColor121Line, LineColorBounds;

  int LocalTimezoneOffset;

  QDateTime LocalTimeUTC;

  QString SessionFile;

  QVector<QColor> randomColors;

  QString commandLineFile;

  bool processCommandLine;
  bool timeseriesDisplayValues;
  bool timeseriesHideInfoWindows;
  bool noaaDisplayValues;
  bool usgsDisplayValues;
  bool xtideDisplayValues;
  bool hwmDisplayValues;

protected:
  void closeEvent(QCloseEvent *);
};

#endif // MOV_MAINWINDOW_H
