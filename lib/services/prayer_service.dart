import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerTimeData {
  final String locationName;
  final double latitude;
  final double longitude;
  final DateTime subuh;
  final DateTime terbit;
  final DateTime dzuhur;
  final DateTime ashar;
  final DateTime maghrib;
  final DateTime isya;
  final String nextPrayerName;
  final DateTime nextPrayerTime;
  final Duration timeRemaining;

  const PrayerTimeData({
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.subuh,
    required this.terbit,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
    required this.nextPrayerName,
    required this.nextPrayerTime,
    required this.timeRemaining,
  });

  String formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class PrayerService {
  // Default coordinates (Jakarta, Indonesia)
  static const double defaultLat = -6.2088;
  static const double defaultLng = 106.8456;
  static const String defaultLocationName = 'Jakarta, Indonesia';

  Future<Position?> getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (_) {
      try {
        return await Geolocator.getLastKnownPosition();
      } catch (_) {
        return null;
      }
    }
  }

  Future<String> getAddressFromCoordinates(double lat, double lng) async {
    try {
      final geocoding = Geocoding();
      final placemarks = await geocoding.placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        String district = place.subLocality ?? place.locality ?? '';
        String regency = place.subAdministrativeArea ?? place.administrativeArea ?? '';

        if (district.isNotEmpty && regency.isNotEmpty) {
          return '$district, $regency';
        } else if (regency.isNotEmpty) {
          return regency;
        } else if (district.isNotEmpty) {
          return district;
        }
      }
    } catch (_) {}
    return 'Lat: ${lat.toStringAsFixed(2)}°, Lng: ${lng.toStringAsFixed(2)}°';
  }

  double calculateQibla(double lat, double lng) {
    const makkahLat = 21.4225 * pi / 180.0;
    const makkahLng = 39.8262 * pi / 180.0;
    final phi = lat * pi / 180.0;
    final lambda = lng * pi / 180.0;
    final deltaLambda = makkahLng - lambda;

    final y = sin(deltaLambda);
    final x = cos(phi) * tan(makkahLat) - sin(phi) * cos(deltaLambda);
    final qibla = atan2(y, x) * 180.0 / pi;
    return (qibla + 360.0) % 360.0;
  }

  PrayerTimeData getPrayerTimes({
    double? latitude,
    double? longitude,
    String? locationName,
    DateTime? date,
  }) {
    final lat = latitude ?? defaultLat;
    final lng = longitude ?? defaultLng;
    final loc = locationName ?? defaultLocationName;
    final now = date ?? DateTime.now();

    final times = _calculateAstronomicalTimes(lat, lng, now);
    final subuh = times['Subuh']!;
    final terbit = times['Terbit']!;
    final dzuhur = times['Dzuhur']!;
    final ashar = times['Ashar']!;
    final maghrib = times['Maghrib']!;
    final isya = times['Isya']!;

    // Tentukan waktu sholat berikutnya
    String nextName;
    DateTime nextTime;

    if (now.isBefore(subuh)) {
      nextName = 'Subuh';
      nextTime = subuh;
    } else if (now.isBefore(terbit)) {
      nextName = 'Syuruq/Terbit';
      nextTime = terbit;
    } else if (now.isBefore(dzuhur)) {
      nextName = 'Dzuhur';
      nextTime = dzuhur;
    } else if (now.isBefore(ashar)) {
      nextName = 'Ashar';
      nextTime = ashar;
    } else if (now.isBefore(maghrib)) {
      nextName = 'Maghrib';
      nextTime = maghrib;
    } else if (now.isBefore(isya)) {
      nextName = 'Isya';
      nextTime = isya;
    } else {
      // Melewati Isya, sholat berikutnya adalah Subuh esok hari
      final tomorrow = now.add(const Duration(days: 1));
      final tomorrowTimes = _calculateAstronomicalTimes(lat, lng, tomorrow);
      nextName = 'Subuh';
      nextTime = tomorrowTimes['Subuh']!;
    }

    final diff = nextTime.difference(now);

    return PrayerTimeData(
      locationName: loc,
      latitude: lat,
      longitude: lng,
      subuh: subuh,
      terbit: terbit,
      dzuhur: dzuhur,
      ashar: ashar,
      maghrib: maghrib,
      isya: isya,
      nextPrayerName: nextName,
      nextPrayerTime: nextTime,
      timeRemaining: diff.isNegative ? Duration.zero : diff,
    );
  }

  Map<String, DateTime> _calculateAstronomicalTimes(double latitude, double longitude, DateTime date) {
    final timezone = date.timeZoneOffset.inMinutes / 60.0;
    final dayOfYear = int.parse(date.difference(DateTime(date.year, 1, 1)).inDays.toString()) + 1;
    final gamma = 2 * pi / 365.0 * (dayOfYear - 1);

    // Equation of time (minutes)
    final eqTime = 229.18 * (0.000075 + 0.001868 * cos(gamma) - 0.032077 * sin(gamma) - 0.014615 * cos(2 * gamma) - 0.040849 * sin(2 * gamma));

    // Solar declination (radians)
    final decl = 0.006918 - 0.399912 * cos(gamma) + 0.070257 * sin(gamma) - 0.006758 * cos(2 * gamma) + 0.000907 * sin(2 * gamma) - 0.002697 * cos(3 * gamma) + 0.00148 * sin(3 * gamma);

    final latRad = latitude * pi / 180.0;
    final solarNoon = 12.0 + timezone - (longitude / 15.0) - (eqTime / 60.0);

    double hourAngle(double angleDeg, {bool isNegative = false}) {
      final angleRad = angleDeg * pi / 180.0;
      final val = (sin(angleRad) - sin(latRad) * sin(decl)) / (cos(latRad) * cos(decl));
      final clamped = val.clamp(-1.0, 1.0);
      final ha = acos(clamped) * 180.0 / pi / 15.0;
      return isNegative ? -ha : ha;
    }

    final subuhHours = solarNoon + hourAngle(-20.0, isNegative: true);
    final sunriseHours = solarNoon + hourAngle(-0.833, isNegative: true);
    final dzuhurHours = solarNoon;
    final asharAngle = atan(1.0 + tan((latitude * pi / 180.0 - decl).abs()));
    final asharHours = solarNoon + hourAngle(90.0 - (asharAngle * 180.0 / pi));
    final maghribHours = solarNoon + hourAngle(-0.833);
    final isyaHours = solarNoon + hourAngle(-18.0);

    DateTime toDateTime(double hours) {
      final h = hours.floor();
      final m = ((hours - h) * 60.0).round();
      return DateTime(date.year, date.month, date.day, h, m);
    }

    // Ditambahkan ikhtiyat +2 menit sesuai standar Kemenag RI
    return {
      'Subuh': toDateTime(subuhHours + 2.0 / 60.0),
      'Terbit': toDateTime(sunriseHours),
      'Dzuhur': toDateTime(dzuhurHours + 2.0 / 60.0),
      'Ashar': toDateTime(asharHours + 2.0 / 60.0),
      'Maghrib': toDateTime(maghribHours + 2.0 / 60.0),
      'Isya': toDateTime(isyaHours + 2.0 / 60.0),
    };
  }
}

// Service Provider
final prayerServiceProvider = Provider<PrayerService>((ref) {
  return PrayerService();
});

class UserLocationState {
  final double latitude;
  final double longitude;
  final String locationName;
  final bool isLiveGps;
  final bool isLoading;

  const UserLocationState({
    required this.latitude,
    required this.longitude,
    required this.locationName,
    this.isLiveGps = false,
    this.isLoading = false,
  });
}

class UserLocationNotifier extends Notifier<UserLocationState> {
  @override
  UserLocationState build() {
    _initLocation();
    return const UserLocationState(
      latitude: PrayerService.defaultLat,
      longitude: PrayerService.defaultLng,
      locationName: PrayerService.defaultLocationName,
      isLiveGps: false,
      isLoading: true,
    );
  }

  Future<void> _initLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLat = prefs.getDouble('user_lat');
    final savedLng = prefs.getDouble('user_lng');
    final savedName = prefs.getString('user_loc_name');

    if (savedLat != null && savedLng != null && savedName != null) {
      state = UserLocationState(
        latitude: savedLat,
        longitude: savedLng,
        locationName: savedName,
        isLiveGps: true,
        isLoading: false,
      );
    }

    // Refresh secara otomatis saat startup aplikasi
    await refreshLocation();
  }

  Future<void> refreshLocation() async {
    state = UserLocationState(
      latitude: state.latitude,
      longitude: state.longitude,
      locationName: state.locationName,
      isLiveGps: state.isLiveGps,
      isLoading: true,
    );

    final prayerService = ref.read(prayerServiceProvider);
    final pos = await prayerService.getCurrentPosition();
    if (pos != null) {
      final locName = await prayerService.getAddressFromCoordinates(pos.latitude, pos.longitude);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('user_lat', pos.latitude);
      await prefs.setDouble('user_lng', pos.longitude);
      await prefs.setString('user_loc_name', locName);

      state = UserLocationState(
        latitude: pos.latitude,
        longitude: pos.longitude,
        locationName: locName,
        isLiveGps: true,
        isLoading: false,
      );
    } else {
      state = UserLocationState(
        latitude: state.latitude,
        longitude: state.longitude,
        locationName: state.locationName,
        isLiveGps: state.isLiveGps,
        isLoading: false,
      );
    }
  }
}

final userLocationProvider =
    NotifierProvider<UserLocationNotifier, UserLocationState>(UserLocationNotifier.new);

// Stream Provider yang mengalirkan waktu sholat & hitung mundur dinamis setiap detik
final dynamicPrayerTimesProvider = StreamProvider.autoDispose<PrayerTimeData>((ref) {
  final service = ref.watch(prayerServiceProvider);
  final location = ref.watch(userLocationProvider);

  final controller = StreamController<PrayerTimeData>();
  controller.add(service.getPrayerTimes(
    latitude: location.latitude,
    longitude: location.longitude,
    locationName: location.locationName,
  ));

  final timer = Timer.periodic(const Duration(seconds: 1), (_) {
    if (!controller.isClosed) {
      controller.add(service.getPrayerTimes(
        latitude: location.latitude,
        longitude: location.longitude,
        locationName: location.locationName,
      ));
    }
  });

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});
