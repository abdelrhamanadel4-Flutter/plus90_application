import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:plus90_application/utils/app_color.dart';

class ChooseLocationScreen extends StatefulWidget {
  const ChooseLocationScreen({super.key});

  @override
  State<ChooseLocationScreen> createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  LatLng? selectedLocation;

  bool loading = false;

  final MapController mapController = MapController();

  final TextEditingController searchController = TextEditingController();

  List<dynamic> suggestions = [];

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    getCurrentLocation();
  }

  /// 📍 CURRENT LOCATION
  Future<void> getCurrentLocation() async {
    setState(() => loading = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        setState(() => loading = false);
        return;
      }

      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => loading = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final pos = LatLng(position.latitude, position.longitude);

      setState(() {
        selectedLocation = pos;
        loading = false;
      });

      mapController.move(pos, 15);

      await getAddressFromLatLng(position.latitude, position.longitude);
    } catch (e) {
      setState(() => loading = false);
    }
  }

  /// 🔎 SEARCH DEBOUNCE
  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 350), () {
      fetchSuggestions(value.trim());
    });
  }

  /// 🔎 SEARCH IN EGYPT ONLY
  Future<void> fetchSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() => suggestions = []);
      return;
    }

    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/search"
      "?q=$query"
      "&format=json"
      "&addressdetails=1"
      "&limit=10"
      "&dedupe=1"
      "&countrycodes=eg"
      "&viewbox=24.7,31.7,36.9,21.8"
      "&bounded=1",
    );

    final response = await http.get(url, headers: {"User-Agent": "plus90-app"});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        suggestions = data.where((item) {
          final name = item['display_name'];

          return name != null && name.toString().length > 3;
        }).toList();
      });
    }
  }

  /// 📍 GET ADDRESS FROM LAT LNG
  Future<void> getAddressFromLatLng(double lat, double lng) async {
    try {
      final url = Uri.parse(
        "https://nominatim.openstreetmap.org/reverse"
        "?lat=$lat"
        "&lon=$lng"
        "&format=json",
      );

      final response = await http.get(
        url,
        headers: {"User-Agent": "plus90-app"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final address = data["display_name"];

        setState(() {
          searchController.text = address ?? "";
        });
      }
    } catch (e) {
      print(e);
    }
  }

  /// 💾 SAVE LOCATION
  void saveLocation() {
    if (selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select location first")),
      );

      return;
    }

    Navigator.pop(context, {
      "address": searchController.text,
      "lat": selectedLocation!.latitude,
      "lng": selectedLocation!.longitude,
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();

    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🗺️ MAP
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(30.0444, 31.2357),

              initialZoom: 13,

              onTap: (tapPosition, point) async {
                setState(() {
                  selectedLocation = point;
                });

                await getAddressFromLatLng(point.latitude, point.longitude);
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",

                subdomains: const ['a', 'b', 'c', 'd'],
              ),

              MarkerLayer(
                markers: [
                  if (selectedLocation != null)
                    Marker(
                      point: selectedLocation!,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.location_pin,
                        color: AppColor.orange,
                        size: 40,
                      ),
                    ),
                ],
              ),
            ],
          ),

          /// 🔎 SEARCH BAR
          Positioned(
            top: 120,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                decoration: const InputDecoration(
                  hintText: "Search Egypt locations...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
          ),

          /// 📍 SUGGESTIONS
          if (suggestions.isNotEmpty)
            Positioned(
              top: 180,
              left: 20,
              right: 20,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 250),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10),
                  ],
                ),
                child: ListView.builder(
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    final item = suggestions[index];

                    return ListTile(
                      leading: const Icon(
                        Icons.location_on,
                        color: AppColor.orange,
                      ),
                      title: Text(
                        item['display_name'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () async {
                        final lat = double.parse(item['lat']);

                        final lon = double.parse(item['lon']);

                        final pos = LatLng(lat, lon);

                        setState(() {
                          selectedLocation = pos;

                          searchController.text = item['display_name'];

                          suggestions = [];
                        });

                        mapController.move(pos, 15);

                        await getAddressFromLatLng(lat, lon);
                      },
                    );
                  },
                ),
              ),
            ),

          /// 🔝 HEADER
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 15),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.location_on, color: AppColor.orange),

                  SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      "Choose Location",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 📍 MY LOCATION
          Positioned(
            bottom: 140,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: AppColor.orange,
              onPressed: getCurrentLocation,
              child: const Icon(Icons.my_location, color: AppColor.whiteColor),
            ),
          ),

          /// 💾 SAVE
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: GestureDetector(
              onTap: saveLocation,
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: AppColor.orange,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text(
                    "Save Location",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// 🔄 LOADING
          if (loading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(color: AppColor.orange),
              ),
            ),
        ],
      ),
    );
  }
}
