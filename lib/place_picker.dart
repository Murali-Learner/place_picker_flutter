import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:place_piker/api_key.dart';

class GoogleMapsPlacePicker extends StatelessWidget {
  static const routeName = '/google-search-map';
  // Light Theme
  final ThemeData lightTheme = ThemeData.light().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.white,
    buttonTheme: const ButtonThemeData(
      // Select here's button color
      buttonColor: Colors.black,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  // Dark Theme
  final ThemeData darkTheme = ThemeData.dark().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.grey,
    buttonTheme: const ButtonThemeData(
      // Select here's button color
      buttonColor: Colors.yellow,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  GoogleMapsPlacePicker({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Map Place Picker Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String selectedPlace = "";
  getAddress(LatLng coordinates) async {
    var addresses = await Geocoder2.getDataFromCoordinates(
      latitude: coordinates.latitude,
      longitude: coordinates.longitude,
      googleMapApiKey: apiKey,
    );
    setState(() {
      selectedPlace = addresses.address;
    });

    log(selectedPlace.toString());
  }

  final initialPosition = const LatLng(78.392253, 17.444259);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: PlacePicker(
                  automaticallyImplyAppBarLeading: false,
                  hintText: "select location",
                  autocompleteLanguage: "en",
                  hidePlaceDetailsWhenDraggingPin: true,
                  apiKey: apiKey,
                  onCameraIdle: (p0) {
                    getAddress(p0.cameraPosition!.target);
                  },
                  myLocationButtonCooldown: 0,
                  enableMyLocationButton: true,
                  onPlacePicked: (result) {
                    // Navigator.of(context).pop();
                    log(result.addressComponents.toString());
                  },
                  initialPosition: initialPosition,
                  useCurrentLocation: true,
                  enableMapTypeButton: true,
                  resizeToAvoidBottomInset: true,
                ),
              ),
              Container(
                height: 80,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Text(selectedPlace.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
