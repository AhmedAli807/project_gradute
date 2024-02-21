import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:project_gradute/config/assets_data.dart';
import 'package:project_gradute/utils/color_assets.dart';

class MapViewBody extends StatefulWidget {
  const MapViewBody({Key? key}) : super(key: key);

  @override
  State<MapViewBody> createState() => _MapViewBodyState();
}

class _MapViewBodyState extends State<MapViewBody> {
  late GoogleMapController googleMapController;
  CameraPosition initialPosition =
      const CameraPosition(target: LatLng(30.033333, 31.233334), zoom: 14);
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> _markers = [];

  Future<List<Map<String, dynamic>>> fetchCSVData() async {
    final csvUrl =
        'https://firms.modaps.eosdis.nasa.gov/api/country/csv/7647fc3fc947d0bcd255c371869a22dd/VIIRS_SNPP_NRT/EGY/1';

    final response = await http.get(Uri.parse(csvUrl));
    if (response.statusCode == 200) {
      final csvData = response.body;
      final lines = csvData.split('\n');
      final headers = lines[0].split(',');

      List<Map<String, dynamic>> jsonData = [];

      for (var i = 1; i < lines.length; i++) {
        final values = lines[i].split(',');

        if (values.length == headers.length) {
          final entry = Map<String, dynamic>();
          for (var j = 0; j < headers.length; j++) {
            entry[headers[j]] = values[j];
          }
          jsonData.add(entry);
        }
      }

      return jsonData;
    } else {
      throw Exception('Failed to fetch CSV data');
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final Uint8List markerIcon =
        await getBytesFromAsset(AssetsData.fireMarker, 10);
    _controller.complete(controller);

    final jsonData = await fetchCSVData();

    setState(() {
      for (int i = 0; i < jsonData.length; i++) {
        _markers.add(Marker(
            markerId: const MarkerId('1'),
            position: LatLng(double.parse(jsonData[i]['latitude']),
                double.parse(jsonData[i]['longitude'])),
            onTap: () {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    // <-- SEE HERE
                    title: const Text('Fire info'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Text(
                                  "Latitude : ${jsonData[i]['latitude']}",
                                  style: TextStyle(color: ColorAssets.kColor),
                                ),
                                Text(
                                  "Longitude : ${jsonData[i]['longitude']}",
                                  style: TextStyle(color: ColorAssets.kColor),
                                ),
                                Text(
                                  "frp : ${jsonData[i]['frp']}",
                                  style: TextStyle(color: ColorAssets.kColor),
                                ),
                                Text(
                                  "acq_date : ${jsonData[i]['acq_date']}",
                                  style: TextStyle(color: ColorAssets.kColor),
                                ),
                                Text(
                                  "bright_ti5 : ${jsonData[i]['bright_ti5']}",
                                  style: TextStyle(color: ColorAssets.kColor),
                                ),
                                Text(
                                  "bright_ti4 : ${jsonData[i]['bright_ti4']}",
                                  style: TextStyle(color: ColorAssets.kColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: BitmapDescriptor.fromBytes(markerIcon)));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCSVData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchCSVData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching CSV data'),
            );
          } else if (snapshot.hasData) {
            final jsonData = snapshot.data!;

            return GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: initialPosition,
              markers: _markers.toSet(),
              mapType: MapType.normal,
            );
          } else {
            return Center(
              child: Text('No data available'),
            );
          }
        },
      ),
    ));
  }
}
