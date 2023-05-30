PRODUCT_NAME = $$TARGET

INFOPLIST = \
   "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" \
   "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">" \
   "<plist version=\"1.0\">" \
   "<dict>" \
    "    <key>CFBundleIconFile</key>" \
    "    <string></string>" \
    "    <key>CFBundlePackageType</key>" \
    "    <string>APPL</string>" \
    "    <key>CFBundleGetInfoString</key>" \
    "    <string>Created by Qt/QMake</string>" \
    "    <key>CFBundleSignature</key>" \
    "    <string>????</string>" \
    "    <key>CFBundleExecutable</key>" \
    "    <string>$$TARGET</string>" \
    "    <key>CFBundleIdentifier</key>" \
    "    <string>com.digia.$${LITERAL_DOLLAR}{PRODUCT_NAME:rfc1034identifier}</string>" \
    "    <key>CFBundleDisplayName</key>" \
    "    <string>$$PRODUCT_NAME</string>" \
    "    <key>CFBundleName</key>" \
    "    <string>$$PRODUCT_NAME</string>" \
    "    <key>CFBundleShortVersionString</key>" \
    "    <string>1.0</string>" \
    "    <key>CFBundleVersion</key>" \
    "    <string>1.0</string>" \
    "    <key>LSRequiresIPhoneOS</key>" \
    "    <true/>" \
    "    <key>UILaunchStoryboardName</key>" \
    "    <string>LaunchScreen</string>" \
    "    <key>UISupportedInterfaceOrientations</key>" \
    "    <array>" \
    "            <string>UIInterfaceOrientationPortrait</string>" \
    "    </array>" \
    "    <key>NSCameraUsageDescription</key>" \
    "    <string>Qt Multimedia Example</string>" \
    "    <key>NSLocationWhenInUseUsageDescription</key>" \
    "    <string>Qt Multimedia Example</string>" \
    "    <key>NSMicrophoneUsageDescription</key>" \
    "    <string>Qt Multimedia Example</string>" \
    "    <key>NOTE</key>" \
    "    <string>This file was generated by Qt/QMake.</string>" \
    "</dict>" \
    "</plist>"
write_file($$OUT_PWD/Info.plist, INFOPLIST)|error()
QMAKE_INFO_PLIST = $$OUT_PWD/Info.plist

QT += quick qml multimedia sensors positioning charts

SOURCES += \
        main.cpp

resources.files = main.qml
resources.prefix = /$${TARGET}
RESOURCES += resources \
  qml.qrc

#QMAKE_INFO_PLIST = info.plist

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
  Lighthouse.qml \
  Lighthouses.qml \
  SettingsView.qml \
  resources/gear.avif
