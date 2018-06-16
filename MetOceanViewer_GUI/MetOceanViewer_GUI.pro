#-------------------------------GPL-------------------------------------#
#
# MetOcean Viewer - A simple interface for viewing hydrodynamic model data
# Copyright (C) 2018  Zach Cobell
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#-----------------------------------------------------------------------#

QT  += core gui network xml charts printsupport
QT  += qml quick positioning location quickwidgets

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = MetOceanViewer
TEMPLATE = app

SOURCES +=\
    src/stationmodel.cpp \
    src/station.cpp \
    src/colors.cpp \
    src/dflow.cpp \
    src/errors.cpp \
    src/filetypes.cpp \
    src/generic.cpp \
    src/hwm.cpp \
    src/keyhandler.cpp \
    src/noaa.cpp \
    src/session.cpp \
    src/usgs.cpp \
    src/xtide.cpp \
    src/chartview.cpp \
    src/aboutdialog.cpp \
    src/adcircstationoutput.cpp \
    src/uihwmtab.cpp \
    src/uinoaatab.cpp \
    src/uitimeseriestab.cpp \
    src/uiusgstab.cpp \
    src/updatedialog.cpp \
    src/usertimeseries.cpp \
    src/mainwindow.cpp \
    src/main.cpp \
    src/addtimeseriesdialog.cpp \
    src/uixtidetab.cpp \
    src/mapfunctions.cpp \
    src/mapfunctionsprivate.cpp

HEADERS  += \
    src/metoceanviewer.h \
    src/stationmodel.h \
    src/station.h \
    src/colors.h \
    src/dflow.h \
    src/errors.h \
    src/filetypes.h \
    src/generic.h \
    src/hwm.h \
    src/keyhandler.h \
    src/noaa.h \
    src/session.h \
    src/usgs.h \
    src/xtide.h \
    src/chartview.h \
    src/aboutdialog.h \
    src/adcircstationoutput.h \
    src/addtimeseriesdialog.h \
    src/mainwindow.h \
    src/updatedialog.h \
    src/usertimeseries.h \
    version.h \
    src/mapfunctions.h \
    src/mapfunctionsprivate.h

FORMS    += \
    ui/aboutdialog.ui \
    ui/addtimeseriesdialog.ui \
    ui/updatedialog.ui \
    ui/mainwindow.ui

OTHER_FILES +=

#...Compiler dependent options
DEFINES += MOV_ARCH=\\\"$$QT_ARCH\\\" 

win32{
    DEFINES += USE_ANGLE
}

#...Microsoft Visual C++ compilers
*msvc* {

    #...Location of the netCDF srcs
    INCLUDEPATH += $$PWD/../thirdparty/netcdf/include

    contains(QT_ARCH, i386){

        #...Microsoft Visual C++ 32-bit compiler
        message("Using MSVC-32 bit compiler...")
        LIBS += -L$$PWD/../thirdparty/netcdf/libs_vc32 -lnetcdf -lhdf5 -lzlib -llibcurl_imp

        #...Optimization flags
        QMAKE_CXXFLAGS_RELEASE +=
        QMAKE_CXXFLAGS_DEBUG += -DEBUG

        #...Define a variable for the about dialog
        DEFINES += MOV_COMPILER=\\\"msvc\\\"
    }else{

        #...Microsoft Visual C++ 64-bit compiler
        message("Using MSVC-64 bit compiler...")
        LIBS += -L$$PWD/../thirdparty/netcdf/libs_vc64 -lnetcdf -lhdf5 -lzlib -llibcurl_imp

        #...Optimization flags
        QMAKE_CXXFLAGS_RELEASE +=
        QMAKE_CXXFLAGS_DEBUG += -DEBUG

        #...Define a variable for the about dialog
        DEFINES += MOV_COMPILER=\\\"msvc\\\"
    }

}


#...Unix - We assume static library for NetCDF installed
#          in the system path already
unix:!macx{
    LIBS += -lnetcdf

    #...Optimization flags
    QMAKE_CXXFLAGS_RELEASE +=
    QMAKE_CXXFLAGS_DEBUG += -O0 -DEBUG

    #...The flag --no-pie is for linux systems to correctly
    #   recognize the output as an executable and not a shared lib
    #   Some versions of g++ don't require/have this option so check here
    #   for the configuration of the compiler
    GV = $$system(g++ --help --verbose 2>&1 >/dev/null | grep "enable-default-pie" | wc -l)
    greaterThan(GV, 0): QMAKE_LFLAGS += -no-pie

    #...Define a variable for the about dialog
    DEFINES += MOV_COMPILER=\\\"g++\\\"
}

#...Mac - Assume static libs for netCDF in this path
#         This, obviously, will vary by the machine
#         the code is built on
macx{
    LIBS += -L/Users/zcobell/Software/netCDF/lib -lnetcdf
    INCLUDEPATH += /Users/zcobell/Software/netCDF/src
    ICON = img/mov.icns

    #...Files to be srcd in the bundle
    XTIDEBIN.files = $$PWD/mov_libs/bin/tide \
                     $$PWD/mov_libs/bin/harmonics.tcd
    XTIDEBIN.path  = Contents/MacOS/XTide/bin

    XTIDELIB.files = $$PWD/mov_libs/lib/libtcd.dylib \
                     $$PWD/mov_libs/lib/libxtide.dylib
    XTIDELIB.path  = Contents/MacOS/XTide/lib

    QMAKE_BUNDLE_DATA += XTIDEBIN XTIDELIB

    #...Optimization flags
    QMAKE_CXXFLAGS_RELEASE +=
    QMAKE_CXXFLAGS_DEBUG += -O0 -DEBUG

    #...Define a variable for the about dialog
    DEFINES += MOV_COMPILER=\\\"xcode\\\"
}

INCLUDEPATH += src

RESOURCES += \
    movResource.qrc
    
RC_FILE = resources.rc

#...Ensure that git is in the system path. If not using GIT comment these two lines
GIT_VERSION = $$system(git --git-dir $$PWD/../.git --work-tree $$PWD/.. describe --always --tags)
DEFINES += GIT_VERSION=\\\"$$GIT_VERSION\\\"

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../libraries/libnetcdfcxx/release/ -lnetcdfcxx
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../libraries/libnetcdfcxx/debug/ -lnetcdfcxx
else:unix: LIBS += -L$$OUT_PWD/../libraries/libnetcdfcxx/ -lnetcdfcxx

INCLUDEPATH += $$PWD/../libraries/libnetcdfcxx $$PWD/../thirdparty/netcdf-cxx/cxx4
DEPENDPATH += $$PWD/../libraries/libnetcdfcxx

win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libnetcdfcxx/release/libnetcdfcxx.a
else:win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libnetcdfcxx/debug/libnetcdfcxx.a
else:win32:!win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libnetcdfcxx/release/netcdfcxx.lib
else:win32:!win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libnetcdfcxx/debug/netcdfcxx.lib
else:unix: PRE_TARGETDEPS += $$OUT_PWD/../libraries/libnetcdfcxx/libnetcdfcxx.a

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../libraries/libkdtree2/release/ -lmovKdtree2
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../libraries/libkdtree2/debug/ -lmovKdtree2
else:unix: LIBS += -L$$OUT_PWD/../libraries/libkdtree2/ -lmovKdtree2

INCLUDEPATH += $$PWD/../libraries/libkdtree2
DEPENDPATH += $$PWD/../libraries/libkdtree2

win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libkdtree2/release/libmovKdtree2.a
else:win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libkdtree2/debug/libmovKdtree2.a
else:win32:!win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libkdtree2/release/movKdtree2.lib
else:win32:!win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libkdtree2/debug/movKdtree2.lib
else:unix: PRE_TARGETDEPS += $$OUT_PWD/../libraries/libkdtree2/libmovKdtree2.a

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../libraries/libtimezone/release/ -ltimezone
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../libraries/libtimezone/debug/ -ltimezone
else:unix: LIBS += -L$$OUT_PWD/../libraries/libtimezone/ -ltimezone

INCLUDEPATH += $$PWD/../libraries/libtimezone
DEPENDPATH += $$PWD/../libraries/libtimezone

win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libtimezone/release/libtimezone.a
else:win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libtimezone/debug/libtimezone.a
else:win32:!win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libtimezone/release/timezone.lib
else:win32:!win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libtimezone/debug/timezone.lib
else:unix: PRE_TARGETDEPS += $$OUT_PWD/../libraries/libtimezone/libtimezone.a

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../libraries/libproj4/release/ -lmovProj4
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../libraries/libproj4/debug/ -lmovProj4
else:unix: LIBS += -L$$OUT_PWD/../libraries/libproj4/ -lmovProj4

INCLUDEPATH += $$PWD/../libraries/libproj4
DEPENDPATH += $$PWD/../libraries/libproj4

win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libproj4/release/libmovProj4.a
else:win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libproj4/debug/libmovProj4.a
else:win32:!win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libproj4/release/movProj4.lib
else:win32:!win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libproj4/debug/movProj4.lib
else:unix: PRE_TARGETDEPS += $$OUT_PWD/../libraries/libproj4/libmovProj4.a

DISTFILES += \
    qml/MovMapItem.qml \
    qml/MapViewer.qml \
    qml/InfoWindow.qml \
    qml/MapLegend.qml \
    qml/MapboxMapViewer.qml \
    qml/EsriMapViewer.qml \
    qml/OsmMapViewer.qml

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../libraries/libhmdf/release/ -lhmdf
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../libraries/libhmdf/debug/ -lhmdf
else:unix: LIBS += -L$$OUT_PWD/../libraries/libhmdf/ -lhmdf

INCLUDEPATH += $$PWD/../libraries/libhmdf
DEPENDPATH += $$PWD/../libraries/libhmdf

win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libhmdf/release/libhmdf.a
else:win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libhmdf/debug/libhmdf.a
else:win32:!win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libhmdf/release/hmdf.lib
else:win32:!win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libhmdf/debug/hmdf.lib
else:unix: PRE_TARGETDEPS += $$OUT_PWD/../libraries/libhmdf/libhmdf.a

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../libraries/libnoaacoops/release/ -lnoaacoops
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../libraries/libnoaacoops/debug/ -lnoaacoops
else:unix: LIBS += -L$$OUT_PWD/../libraries/libnoaacoops/ -lnoaacoops

INCLUDEPATH += $$PWD/../libraries/libnoaacoops
DEPENDPATH += $$PWD/../libraries/libnoaacoops

win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libnoaacoops/release/libnoaacoops.a
else:win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libnoaacoops/debug/libnoaacoops.a
else:win32:!win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libnoaacoops/release/noaacoops.lib
else:win32:!win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../libraries/libnoaacoops/debug/noaacoops.lib
else:unix: PRE_TARGETDEPS += $$OUT_PWD/../libraries/libnoaacoops/libnoaacoops.a
