import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';

import 'crops.dart';

final ApiService apiService = ApiService._privateConstructor();

late Box _box;
final Dio _dio = Dio();

Future<void> initHive() async {
  await Hive.initFlutter();
  _box = await Hive.openBox('apiBox');
  if (_box.get('money') == null) {
    _box.put('money', 1000);
  }
  if (_box.get('experience') == null) {
    _box.put('experience', 0);
  }
  if (_box.get('seeds') == null) {
    _box.put('seeds', {});
  }
}

class ApiService {
  static const String baseUrl = 'https://your-api-url.com';

  ApiService._privateConstructor();

  Future<bool> login(String username) async {
    await _box.put('username', username);
    // final response = await _dio.post('$baseUrl/login');
    // if (response.statusCode == 200) {
    //   _box.put('username', response.data['username']);
    //   return true;
    // } else {
    //   return false;
    // }
    return true;
  }

  String? getUsername() {
    return _box.get('username');
  }

  Future<void> plantCrop(int plotNumber, int cropId, DateTime plantTime) async {
    _box.put('plot_$plotNumber', {
      'cropId': cropId,
      'plantTime': plantTime.toIso8601String(),
    });
  }

  Map<String, dynamic>? getCropState(int plotNumber) {
    final cropState = _box.get('plot_$plotNumber');
    if (cropState != null) {
      return Map<String, dynamic>.from(cropState);
    }
    return null;
  }

  int getMoney() {
    return _box.get('money', defaultValue: 1000);
  }

  Future<void> setMoney(int amount) async {
    await _box.put('money', amount);
  }

  int getExperience() {
    return _box.get('experience', defaultValue: 0);
  }

  Future<void> setExperience(int amount) async {
    await _box.put('experience', amount);
  }

  Map<int, int> getSeeds() {
    return Map<int, int>.from(_box.get('seeds', defaultValue: {}));
  }

  Future<void> setSeeds(Map<int, int> seeds) async {
    await _box.put('seeds', seeds);
  }

  Future<void> buySeed(int cropId, int price) async {
    final money = getMoney();
    if (money >= price) {
      setMoney(money - price);
      final seeds = getSeeds();
      seeds[cropId] = (seeds[cropId] ?? 0) + 1;
      setSeeds(seeds);
    }
  }

  Future<void> harvestCrops() async {
    int totalMoney = getMoney();
    int totalExperience = getExperience();
    final random = Random();

    for (int plotNumber = 1; plotNumber <= 4; plotNumber++) {
      final cropState = getCropState(plotNumber);
      if (cropState != null) {
        final cropId = cropState['cropId'];
        final crop = crops.firstWhere((crop) => crop.level == cropId);
        final plantTime = DateTime.parse(cropState['plantTime']);
        final elapsedTime = DateTime.now().difference(plantTime).inHours;

        if (elapsedTime >= crop.stepHours[2]) {
          final fruits = random.nextInt(crop.fruitsMax - crop.fruitsMin + 1) + crop.fruitsMin;
          totalMoney += crop.fruitPrice * fruits;
          totalExperience += crop.fruitExp * fruits;
          _box.delete('plot_$plotNumber');
        }
      }
    }

    await setMoney(totalMoney);
    await setExperience(totalExperience);
  }
}
