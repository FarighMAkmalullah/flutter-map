import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/mapview.dart';
// import 'package:here_sdk/mapview.dart';

void main() {
  // Usually, you need to initialize the HERE SDK only once during the lifetime of an application.
  _initializeHERESDK();
  runApp(const MyApp());
}

void _initializeHERESDK() async {
  // Needs to be called before accessing SDKOptions to load necessary libraries.
  SdkContext.init(IsolateOrigin.main);

  // Set your credentials for the HERE SDK.
  String accessKeyId = "D_UUikHC1he6iHjVbi972Q";
  String accessKeySecret =
      "1phwkBxQ2_iXJuAMuUM3obv9Ot-gc6kut0ZODot1QnXWpJg_Y5jRHM6MMyWLKM29dioF3ZhwEOcKEv6j1a_pPA";
  SDKOptions sdkOptions =
      SDKOptions.withAccessKeySecret(accessKeyId, accessKeySecret);

  try {
    await SDKNativeEngine.makeSharedInstance(sdkOptions);
  } on InstantiationException {
    throw Exception("Failed to initialize the HERE SDK.");
  }
}

void _disposeHERESDK() async {
  // Free HERE SDK resources before the application shuts down.
  await SDKNativeEngine.sharedInstance?.dispose();
  SdkContext.release();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HERE SDK for Flutter - Hello Map!',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Aplikasi Percobaan'),
          centerTitle: true,
          elevation: 4,
          backgroundColor: Colors.white,
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: HereMap(onMapCreated: _onMapCreated)),
      ),
    );
  }

  void _onMapCreated(HereMapController hereMapController) {
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
        (MapError? error) {
      if (error != null) {
        print('Map scene not loaded. MapError: ${error.toString()}');
        return;
      }

      const double distanceToEarthInMeters = 4000;
      MapMeasure mapMeasureZoom =
          MapMeasure(MapMeasureKind.distance, distanceToEarthInMeters);
      hereMapController.camera.lookAtPointWithMeasure(
          GeoCoordinates(-7.8229657, 110.3703988), mapMeasureZoom);
    });
  }
}

// //Bisa Container 200x200 dan peta taruh di dalam container juga bisa

// class MyMap extends StatefulWidget {
//   const MyMap({super.key});

//   @override
//   State<MyMap> createState() => _MyMapState();
// }

// class _MyMapState extends State<MyMap> {
//   @override
//   Widget build(BuildContext context) {
//     //lakukan onMapCreated
//     //Ketika Map Created kita mau melakukan ap
//     //
//     return HereMap(
//       onMapCreated: onMapCreated,
//     );
//   }

//   void onMapCreated(HereMapController hereMapController) {
//     //Pertama tentukan Map Sceme nya mau sedang siang malam atau ap
//     hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
//         (error) {
//       if (error != null) {
//         print("Error :" + error.toString());
//         //return untuk berhenti
//         return;
//       }
//     });

//     double distanceToEarthInMeter = 8000;
//     hereMapController.camera.lookAtPointWithMeasure(
//         GeoCoordinates(-7.8229657, 110.3703988),
//         MapMeasure(MapMeasureKind.distance, distanceToEarthInMeter));
//   }
// }
