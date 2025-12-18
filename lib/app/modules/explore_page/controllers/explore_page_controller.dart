import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xnusa_mobile/app/modules/explore_page/models/island_location.dart';
import 'package:xnusa_mobile/constant/constant.dart';

class ExplorePageController extends GetxController {
  final MapController mapController = MapController();
  final RxString selectedIsland = ''.obs;
  final _baseUrl = dotenv.env['BASE_URL'] ?? '';

  var dynamic_islands = <IslandLocation>[].obs;
  var isLoading = true.obs;

  static const LatLng centerIndonesia = LatLng(-2.5489, 118.0149);

  final List<IslandLocation> islands = [
    IslandLocation(
      name: 'Sumatera',
      position: LatLng(-0.5897, 101.3431),
      description: 'Pulau terbesar ke-6 di dunia dengan 50 juta+ penduduk',
      info: 'Terkenal dengan Danau Toba, kopi Gayo, dan hutan tropis',
      color: Colors.green,
    ),
    IslandLocation(
      name: 'Jawa',
      position: LatLng(-7.6145, 110.7122),
      description: 'Pulau terpadat di dunia dengan 145 juta+ penduduk',
      info: 'Pusat ekonomi dan pemerintahan Indonesia',
      color: Colors.orange,
    ),
    IslandLocation(
      name: 'Kalimantan',
      position: LatLng(-1.6815, 113.3824),
      description: 'Pulau terbesar ke-3 di dunia',
      info: 'Kaya akan tambang batubara dan hutan hujan tropis',
      color: Colors.brown,
    ),
    IslandLocation(
      name: 'Sulawesi',
      position: LatLng(-1.4300, 121.4456),
      description: 'Pulau berbentuk unik seperti huruf K',
      info: 'Terkenal dengan Tana Toraja dan Bunaken',
      color: Colors.purple,
    ),
    IslandLocation(
      name: 'Papua',
      position: LatLng(-4.2699, 138.0804),
      description: 'Pulau terbesar ke-2 di dunia',
      info: 'Memiliki Puncak Jaya (Carstensz Pyramid) 4.884 mdpl',
      color: Colors.red,
    ),
    IslandLocation(
      name: 'Bali',
      position: LatLng(-8.4095, 115.1889),
      description: 'Pulau Dewata - Destinasi wisata dunia',
      info: 'Terkenal dengan pantai, budaya Hindu, dan pura',
      color: Colors.pink,
    ),
    IslandLocation(
      name: 'NTT',
      position: LatLng(-8.6573, 117.3616),
      description: 'Lombok, Sumbawa, Flores, Komodo',
      info: 'Terkenal dengan Komodo, pantai pink, dan Raja Ampat',
      color: Colors.cyan,
    ),
    IslandLocation(
      name: 'Maluku',
      position: LatLng(-3.2385, 130.1453),
      description: 'Kepulauan Rempah-rempah',
      info: 'Penghasil cengkeh dan pala terbaik dunia',
      color: Colors.teal,
    ),
  ];

  List<Marker> buildMarkers() {
    final allIslands = [...islands, ...dynamic_islands];
    return allIslands.map((island) {
      return Marker(
        point: island.position,
        width: 80,
        height: 90,
        child: GestureDetector(
          onTap: () => onMarkerTapped(island),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: island.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  island.name,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: island.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Future<void> fetchDynamicIslands(String location) async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse('https://${_baseUrl}/nusaai/api/location'),
        headers: {'Content-Type': 'application/json', 'LOCATION': location},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final location = IslandLocation.fromJson(data);
        dynamic_islands.value = [location];
        onMarkerTapped(dynamic_islands.first);
      } else {
        Get.snackbar("Error", "Failed to fetch data.");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Failed to connect.");
    } finally {
      isLoading.value = false;
    }
  }

  void onMarkerTapped(IslandLocation island) {
    selectedIsland.value = island.name;
    mapController.move(island.position, 7);

    Get.bottomSheet(
      IslandBottomSheet(island: island),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void resetCamera() {
    mapController.move(centerIndonesia, 5);
    selectedIsland.value = '';
  }

  void clearSelected() => selectedIsland.value = '';

  Future<void> openWebAR(IslandLocation island) async {
    final url = Uri.parse('https://mywebar.com/pi/822004');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Tidak bisa membuka browser: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[700],
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
    }
  }

  void showLegend() {
    Get.dialog(
      AlertDialog(
        backgroundColor: ColorApp.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        alignment: Alignment.center,
        title: Text(
          'Panduan Peta',
          style: TypographyApp.headline1.copyWith(fontSize: 22),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _legendItem('📍', 'Tap marker untuk info pulau'),
              _legendItem('🔍', 'Pinch zoom untuk perbesar/kecil'),
              _legendItem('👆', 'Drag untuk geser peta'),
              _legendItem('🔄', 'Tap refresh untuk reset view'),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Pulau yang tersedia:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              ...islands.map(
                (island) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: island.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(island.name, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [TextButton(onPressed: Get.back, child: const Text('OK'))],
      ),
    );
  }

  Widget _legendItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

/// BottomSheet widget (boleh satu file biar cepat)
class IslandBottomSheet extends GetView<ExplorePageController> {
  final IslandLocation island;
  const IslandBottomSheet({super.key, required this.island});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: island.color.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_on,
                          size: 32,
                          color: island.color,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              island.name,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Pulau di Indonesia',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _descCard(),
                  const SizedBox(height: 12),
                  _infoCard(),
                  const SizedBox(height: 20),
                  _coordCard(),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.article),
                          label: const Text('Detail Lengkap'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: island.color,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            controller.openWebAR(island);
                          },
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Lihat AR'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _descCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            island.color.withOpacity(0.1),
            island.color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: island.color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: island.color, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Deskripsi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            island.description,
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.blue[700], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              island.info,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _coordCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Icon(Icons.navigation, size: 20),
              const SizedBox(height: 4),
              const Text(
                'Latitude',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Text(
                island.position.latitude.toStringAsFixed(4),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(height: 40, width: 1, color: Colors.grey[300]),
          Column(
            children: [
              const Icon(Icons.explore, size: 20),
              const SizedBox(height: 4),
              const Text(
                'Longitude',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Text(
                island.position.longitude.toStringAsFixed(4),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
