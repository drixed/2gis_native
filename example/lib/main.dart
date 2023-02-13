import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';
import 'package:two_gis_flutter/two_gis_flutter.dart';
import 'package:two_gis_flutter_example/assets_constant.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GisScreen(),
    );
  }
}

class GisScreen extends StatefulWidget {
  const GisScreen({Key? key}) : super(key: key);

  @override
  State<GisScreen> createState() => _GisScreenState();
}

class _GisScreenState extends State<GisScreen> {
  final GisMapController controller = GisMapController();

  late final Future<List<GisMapMarker>> icons;
  List<GisMapMarker> list = [];

  @override
  void initState() {
    icons = Future.wait([getPngFromAsset(context, AssetPath.iconsPointGrey, 80)]).then(
        (value) => [GisMapMarker(icon: value[0], latitude: 52.29778, longitude: 104.29639, zIndex: 0, id: "123456")]);
    super.initState();
  }

  Future<Uint8List> getPngFromAsset(
    BuildContext context,
    String path,
    int width,
  ) async {
    ByteData data = await DefaultAssetBundle.of(context).load(path);
    Codec codec = await instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ButtonMapWidget(
          controller: controller,
          child: FutureBuilder<List<GisMapMarker>>(
            future: icons,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              list = snapshot.data!;
              return GisMap(
                directoryKey: 'rusvou2177',
                mapKey: 'd3d010dd-e6d7-4e24-b156-fb09fd27a6c3',
                useHybridComposition: true,
                controller: controller,
                onTapMarker: (marker) {
                  // ignore: avoid_print
                  print(marker.id);
                },
                startCameraPosition: const GisCameraPosition(
                  latitude: 52.29778,
                  longitude: 104.29639,
                  bearing: 85.0,
                  tilt: 25.0,
                  zoom: 14.0,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ButtonMapWidget extends StatelessWidget {
  final Widget child;
  final GisMapController controller;

  const ButtonMapWidget({Key? key, required this.child, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  child: const Icon(Icons.gps_fixed),
                  backgroundColor: Colors.red,
                  onPressed: () async {
                    final status = await controller.setCameraPosition(latitude: 51.1701, longitude: 71.4014);
                    
                    log(status);
                  },
                ),
                FloatingActionButton(
                  child: const Icon(Icons.zoom_in_outlined),
                  onPressed: () async {
                    final status = await controller.increaseZoom(duration: 200);
                    log(status);
                  },
                ),
                FloatingActionButton(
                  child: const Icon(Icons.zoom_out_outlined),
                  onPressed: () async {
                    final status = await controller.reduceZoom(duration: 200);
                    log(status);
                  },
                ),
                FloatingActionButton(
                  child: const Icon(Icons.navigation),
                  backgroundColor: Colors.green,
                  onPressed: () async {
                    final status = await controller.setRoute(RoutePosition(
                        finishLatitude: 51.145835,
                        finishLongitude: 71.412695,
                        startLatitude: 51.184114,
                        startLongitude: 71.395197));
                    log(status);
                  },
                ),
                FloatingActionButton(
                  child: const Icon(Icons.stop),
                  backgroundColor: Colors.red,
                  onPressed: () async {
                    final status = await controller.removeRoute();
                    log(status);
                  },
                ),
              ],
            )),
      ],
    );
  }
}
