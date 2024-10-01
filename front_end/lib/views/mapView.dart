import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

const mapbox_access_token =
    'pk.eyJ1IjoiamhhbmRyeS1jaGltYm8iLCJhIjoiY2xzNnB0OHd5MHRtbjJqbXJrMHpkeGZ4MCJ9.r1HKgPunHG6XaBDrmuKLpw';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late LatLng myPosition = const LatLng(0, 0);
  List<String> selectedCategories = [];

  // Lista de lugares
  Map<String, List<Map<String, dynamic>>> categories = {
    'HOTEL': [
      {'nombre': 'Hotel Libertador', 'pos': LatLng(-4.005713, -79.202572)},
      {'nombre': 'Hotel Zamorano Real', 'pos': LatLng(-4.010162, -79.207312)},
    ],
    'PLAZA': [
      {'nombre': 'Plaza Central de Loja', 'pos': LatLng(-4.007845, -79.205128)},
      {
        'nombre': 'Plaza de San Sebastián',
        'pos': LatLng(-4.010470, -79.210005)
      },
    ],
    'PARQUE': [
      {'nombre': 'Parque Jipiro', 'pos': LatLng(-3.990560, -79.204716)},
      {
        'nombre': 'Parque Recreacional La Tebaida',
        'pos': LatLng(-4.013673, -79.205398)
      },
    ],
    'MUSEO': [
      {
        'nombre': 'Museo de la Cultura Lojana',
        'pos': LatLng(-4.004354, -79.205778)
      },
      {'nombre': 'Museo de Arte Moderno', 'pos': LatLng(-4.011243, -79.211421)},
    ],
    'RESTAURANTE': [
      {
        'nombre': 'Big Bang Restaurante',
        'pos': LatLng(-4.031794685516373, -79.20240385670203)
      },
      {
        'nombre': 'Restaurante La Ronda',
        'pos': LatLng(-4.031712584343075, -79.19865476698477)
      },
      {
        'nombre': 'Cafetería Universitaria',
        'pos': LatLng(-4.032000, -79.204000),
      },
    ],
    'SALUD': [
      {
        'nombre': 'San Pablo Clínica',
        'pos': LatLng(-4.02633447050724, -79.20322600896219)
      },
      {
        'nombre': 'Farmacia Cruz Azul',
        'pos': LatLng(-4.031500, -79.202800),
      },
    ],
    'EDUCATIVO': [
      {
        'nombre': 'Universidad Nacional de Loja',
        'pos': LatLng(-4.03288296049623, -79.20255155369874)
      },
      {
        'nombre': 'Instituto Tecnológico Superior Loja',
        'pos': LatLng(-4.014678, -79.214850)
      },
      {
        'nombre': 'Parada de buses UNL',
        'pos': LatLng(-4.033200, -79.203700),
      },
    ],
    'COMERCIAL': [
      {
        'nombre': 'Centro Comercial El Valle',
        'pos': LatLng(-4.030100, -79.203300),
      },
    ],
  };

  List<Map<String, dynamic>> selectedPoints = [];

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await _obtenerUbicacionActual();
  }

  Future<void> _obtenerUbicacionActual() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      setState(() {
        myPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Excepción al obtener la ubicación: $e');
    }
  }

  void _onCategoryChanged(bool? value, String category) {
    setState(() {
      if (value == true) {
        selectedCategories.add(category);
      } else {
        selectedCategories.remove(category);
      }
      _updateSelectedPoints();
    });
  }

  void _updateSelectedPoints() {
    selectedPoints.clear();
    for (var category in selectedCategories) {
      selectedPoints.addAll(categories[category]!);
    }
  }

  void _showPlaceInfo(Map<String, dynamic> place) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(place['nombre']),
          content: Text(
              'Coordenadas: ${place['pos'].latitude}, ${place['pos'].longitude}'),
          actions: [
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Lugares'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView(
              children: categories.keys.map((category) {
                return CheckboxListTile(
                  title: Text(category),
                  value: selectedCategories.contains(category),
                  onChanged: (value) => _onCategoryChanged(value, category),
                );
              }).toList(),
            ),
          ),
          Expanded(
            flex: 3,
            child: myPosition != const LatLng(0, 0)
                ? _buildMapa()
                : _buildLoading(),
          ),
        ],
      ),
    );
  }

  Widget _buildMapa() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: myPosition,
        minZoom: 5,
        maxZoom: 100,
        initialZoom: 18,
      ),
      children: [
        TileLayer(
          maxZoom: 19,
          urlTemplate:
              'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
          additionalOptions: const {
            'accessToken': mapbox_access_token,
            'id': 'mapbox/streets-v12'
          },
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: myPosition,
              width: 80,
              height: 80,
              child: const Icon(
                Icons.person_pin_circle,
                color: Colors.green,
                size: 40,
              ),
            ),
            ...selectedPoints.map(
              (place) => Marker(
                point: place['pos'],
                width: 80,
                height: 80,
                child: GestureDetector(
                  onTap: () => _showPlaceInfo(place),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
