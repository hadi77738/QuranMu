import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/prayer_service.dart';
import '../theme/app_theme.dart';

class QiblaPage extends ConsumerStatefulWidget {
  const QiblaPage({super.key});

  @override
  ConsumerState<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends ConsumerState<QiblaPage> {
  bool _hasVibrated = false;

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(userLocationProvider);
    final qiblaBearing = ref.read(prayerServiceProvider).calculateQibla(
          location.latitude,
          location.longitude,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Arah Kiblat',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: location.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  )
                : const Icon(Icons.my_location_rounded, color: AppColors.primary),
            tooltip: 'Perbarui Lokasi GPS',
            onPressed: location.isLoading
                ? null
                : () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mendeteksi koordinat GPS perangkat...'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    await ref.read(userLocationProvider.notifier).refreshLocation();
                    if (context.mounted) {
                      final updated = ref.read(userLocationProvider);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Lokasi terkini: ${updated.locationName}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Info Lokasi Terkini
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorderLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location.locationName,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          Text(
                            '${location.latitude.toStringAsFixed(4)}°, ${location.longitude.toStringAsFixed(4)}°',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    if (location.isLoading)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Derajat Kiblat Highlight
              Column(
                children: [
                  const Text(
                    'Sudut Derajat Kiblat Ka\'bah',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        qiblaBearing.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '° Barat Laut',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Kompas Dinamis Berbasis Sensor Magnetometer
              StreamBuilder<CompassEvent>(
                stream: FlutterCompass.events,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _buildSensorFallback(qiblaBearing, 'Gagal membaca sensor: ${snapshot.error}');
                  }

                  final heading = snapshot.data?.heading;
                  if (heading == null) {
                    // Fallback jika device tidak memiliki sensor magnetometer
                    return _buildSensorFallback(
                      qiblaBearing,
                      'Sensor magnetometer tidak terdeteksi atau sedang dikalibrasi.\nPutar perangkat membentuk angka 8 untuk mengkalibrasi.',
                    );
                  }

                  // Hitung selisih derajat antara arah hadap HP dengan Ka'bah
                  final diff = ((qiblaBearing - heading + 180) % 360) - 180;
                  final isFacingKaabah = diff.abs() <= 3.0;

                  if (isFacingKaabah && !_hasVibrated) {
                    _hasVibrated = true;
                    HapticFeedback.lightImpact();
                  } else if (!isFacingKaabah && _hasVibrated) {
                    _hasVibrated = false;
                  }

                  return Column(
                    children: [
                      // Status Align Alert
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isFacingKaabah ? const Color(0xFFE2F3ED) : const Color(0xFFF6F8F7),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isFacingKaabah ? AppColors.primary : AppColors.cardBorderLight,
                            width: isFacingKaabah ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isFacingKaabah ? Icons.check_circle_rounded : Icons.explore_rounded,
                              color: isFacingKaabah ? AppColors.primary : AppColors.secondary,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isFacingKaabah
                                  ? 'Tepat Menghadap Ka\'bah!'
                                  : 'Arahkan jarum ke garis atas (${heading.round()}°)',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: isFacingKaabah ? AppColors.primary : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Lingkaran Kompas Interaktif
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // 1. Fixed Device Pointer Marker (Top Arrow)
                          Positioned(
                            top: 0,
                            child: Icon(
                              Icons.arrow_drop_down_rounded,
                              size: 38,
                              color: isFacingKaabah ? AppColors.primary : AppColors.secondary,
                            ),
                          ),

                          // 2. Dial Kompas Berputar Mengikuti Heading Fisik (Utara Magnetik)
                          Transform.rotate(
                            angle: (-heading) * (pi / 180.0),
                            child: Container(
                              width: 260,
                              height: 260,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: isFacingKaabah ? AppColors.primary : AppColors.cardBorderLight,
                                  width: isFacingKaabah ? 3 : 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isFacingKaabah
                                        ? AppColors.primary.withValues(alpha: 0.2)
                                        : Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Cardinal directions (U, T, S, B)
                                  const Positioned(
                                    top: 12,
                                    child: Text('U', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.red, fontSize: 16)),
                                  ),
                                  const Positioned(
                                    bottom: 12,
                                    child: Text('S', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textSecondary, fontSize: 14)),
                                  ),
                                  const Positioned(
                                    right: 12,
                                    child: Text('T', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textSecondary, fontSize: 14)),
                                  ),
                                  const Positioned(
                                    left: 12,
                                    child: Text('B', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textSecondary, fontSize: 14)),
                                  ),
                                  // Tick marks
                                  for (int i = 0; i < 12; i++)
                                    Transform.rotate(
                                      angle: (i * 30.0) * (pi / 180.0),
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 32),
                                          width: 1.5,
                                          height: 8,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),

                          // 3. Jarum Penunjuk Kiblat (Menghadap Ka'bah Secara Relatif)
                          Transform.rotate(
                            angle: (qiblaBearing - heading) * (pi / 180.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Ka'bah Emblem Icon
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isFacingKaabah ? AppColors.primary : AppColors.secondary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: (isFacingKaabah ? AppColors.primary : AppColors.secondary)
                                            .withValues(alpha: 0.4),
                                        blurRadius: isFacingKaabah ? 14 : 8,
                                        spreadRadius: isFacingKaabah ? 2 : 0,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.mosque_rounded, color: Colors.white, size: 24),
                                ),
                                Container(
                                  width: 4,
                                  height: 75,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: isFacingKaabah
                                          ? [AppColors.primary, const Color(0xFF043327)]
                                          : [AppColors.secondary, AppColors.primary],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(height: 35),
                              ],
                            ),
                          ),

                          // 4. Center Axis Dot
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: isFacingKaabah ? AppColors.primary : AppColors.secondary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 36),

              // Petunjuk Kalibrasi & Penggunaan
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 22),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Posisikan ponsel mendatar di tempat terbuka jauh dari casing bermagnet atau benda logam untuk akurasi terbaik sensor.',
                        style: TextStyle(fontSize: 12, height: 1.5, color: AppColors.onPrimaryContainer),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSensorFallback(double qiblaBearing, String message) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7E6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFFD591)),
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Color(0xFFD46B08), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF873800), height: 1.4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: AppColors.cardBorderLight, width: 2),
              ),
              child: const Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(top: 12, child: Text('U', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.red, fontSize: 16))),
                  Positioned(bottom: 12, child: Text('S', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textSecondary, fontSize: 14))),
                  Positioned(right: 12, child: Text('T', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textSecondary, fontSize: 14))),
                  Positioned(left: 12, child: Text('B', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textSecondary, fontSize: 14))),
                ],
              ),
            ),
            Transform.rotate(
              angle: (qiblaBearing) * (pi / 180.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mosque_rounded, color: Colors.white, size: 24),
                  ),
                  Container(
                    width: 4,
                    height: 75,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 35),
                ],
              ),
            ),
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
