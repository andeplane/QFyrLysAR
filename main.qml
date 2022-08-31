import QtQuick
import QtSensors
import QtMultimedia
import QtPositioning
import QtCharts

Item {
    id: root
    width: 640
    height: 480
    onWidthChanged: {
        console.log(width, height)
    }

    property real targetDirection: 190
    property real direction: compass.azimuth + accelerometer.theta
    property real fovL: 69
    property real fovP: 38
    property real smoothingN: 3
    property real earthRadius: 6371009 // meters

    function deg2rad(deg) {
        return deg / 180 * Math.PI
    }

    function calculateDistance(lat1, lon1, lat2, lon2) {
      lat1 = deg2rad(lat1)
      lat2 = deg2rad(lat2)
      lon1 = deg2rad(lon1)
      lon2 = deg2rad(lon2)

      const dLat = lat2 - lat1
      const dLon = lon2 - lon1
      const a = (Math.pow(Math.sin(dLat / 2), 2) +
        Math.pow(Math.sin(dLon / 2), 2) *
        Math.cos(lat1) * Math.cos(lat2));
      return earthRadius * 2 * Math.asin(Math.sqrt(a))
    }

    function calculateAngle(lat1, lon1, lat2, lon2) {
      lat1 = deg2rad(lat1)
      lat2 = deg2rad(lat2)
      lon1 = deg2rad(lon1)
      lon2 = deg2rad(lon2)

      const dLon = (lon2 - lon1);

      const y = Math.sin(dLon) * Math.cos(lat2);
      const x = Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1)
        * Math.cos(lat2) * Math.cos(dLon);

      return Math.atan2(y, x)
    }

    PositionSource {
        id: src
        updateInterval: 250
        active: true

        onPositionChanged: {
            var coord = src.position.coordinate;

            var otherCoord = QtPositioning.coordinate(59.92756178642623, 10.67633625088176, 10)
            var angle = coord.azimuthTo(otherCoord)
            targetDirection = angle
        }
    }

    CaptureSession {
        id: captureSession
        camera: Camera {
            id: camera
            active: true
        }
        videoOutput: viewfinder
    }

    VideoOutput {
        id: viewfinder
        visible: true
//        orientation: 90
        anchors.fill: parent
    }

    Rectangle {
        width: 200
        height: 180
        color: Qt.rgba(1.0, 1.0, 1.0, 0.5)
        radius: 20
        Column {
            Text {
                text: "xx: "+accelerometer.xx.toFixed(3)
            }
            Text {
                text: "yy: "+accelerometer.yy.toFixed(3)
            }
            Text {
                text: "zz: "+accelerometer.zz.toFixed(3)
            }
            Text {
                text: "gx: "+accelerometer.x.toFixed(3)
            }
            Text {
                text: "gy: "+accelerometer.y.toFixed(3)
            }
            Text {
                text: "gz: "+accelerometer.z.toFixed(3)
            }
            Text {
                text: "az: "+compass.azimuth.toFixed(3)
            }
            Text {
                text: "target: "+targetDirection
            }
        }
    }

    Accelerometer {
        id: accelerometer
        active: true
        dataRate: 25

        property real x: 0
        property real y: 0
        property real z: 0
        property real xx: 0
        property real yy: 0
        property real zz: 0
        property real theta: 0
        property real phi: 0
        property real xyAngle: 0
        property var rotationMatrix

        onReadingChanged: {
            x = reading.x
            y = reading.y
            z = reading.z

            const g = Qt.vector3d(0, 0, 1)
            let gp = Qt.vector3d(x, y, -z).normalized()

            const angle = Math.acos(gp.dotProduct(g))
            const gCrossGp = gp.crossProduct(g).normalized()

            const U = Qt.matrix4x4()
            U.rotate(compass.azimuth, g )

            const V = Qt.matrix4x4()
            V.rotate(angle * 180 / Math.PI, gCrossGp)

            const R = V.times(U)

            const coords = Qt.vector3d(Math.sin(targetDirection / 180 * Math.PI), Math.cos(targetDirection / 180 * Math.PI), 0)
            const coordsPrime = R.times(coords)
            xx -= xx / smoothingN
            xx += coordsPrime.x / smoothingN
            yy -= yy / smoothingN
            yy += coordsPrime.y / smoothingN
            zz -= zz / smoothingN
            zz += coordsPrime.z / smoothingN
            rotationMatrix = R
            const newAngle = Math.atan2(x, y)
            xyAngle -= xyAngle / smoothingN
            xyAngle += newAngle / smoothingN
//            const xxx = xx
//            const yyy = yy
//            xx = Math.cos(xyAngle*2)*xxx - Math.sin(xyAngle*2)*yyy
//            yy = Math.sin(xyAngle*2)*xxx + Math.cos(xyAngle*2)*yyy
//            console.log(xyAngle)
        }
    }

    Compass {
        id: compass
        active: true
        dataRate: 7
        property real azimuth: 0
        onReadingChanged: {
            azimuth = reading.azimuth
        }

    }

    Rectangle {
        x: 180 / Math.PI * Math.atan2(accelerometer.xx, accelerometer.zz)/fovP * root.width + root.width/2
        y: 180 / Math.PI * Math.atan2(accelerometer.yy, accelerometer.zz)/fovL * root.height + root.height/2

        color: Qt.rgba(1.0, 0.0, 0.0, 1.0)
        width: 20
        height: 20
        radius: 10
    }

//    Timer {
//        running: true
//        repeat: true
//        interval: 1000
//        onTriggered: {
//            console.log(accelerometer.rotationMatrix.column(0), accelerometer.rotationMatrix.column(1), accelerometer.rotationMatrix.column(2))
//        }
//    }
}
