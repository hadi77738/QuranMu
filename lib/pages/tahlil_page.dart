import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/doa_data.dart';
import '../models/doa.dart';
import '../theme/app_theme.dart';

class TahlilPage extends StatefulWidget {
  final int initialStep;
  const TahlilPage({super.key, this.initialStep = 0});

  @override
  State<TahlilPage> createState() => _TahlilPageState();
}

class _TahlilPageState extends State<TahlilPage> {
  late int _currentStep;
  bool _isContinuousMode = false;
  final Map<int, int> _counters = {};

  final List<DoaItem> _tahlilItems = DoaData.listTahlil;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep.clamp(0, _tahlilItems.length - 1);
  }

  void _incrementCounter(int stepIndex, int maxCount) {
    setState(() {
      final current = _counters[stepIndex] ?? 0;
      if (current < maxCount) {
        _counters[stepIndex] = current + 1;
        HapticFeedback.lightImpact();
      }
    });
  }

  void _resetCounter(int stepIndex) {
    setState(() {
      _counters[stepIndex] = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Susunan Bacaan Tahlil',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: _isContinuousMode ? 'Mode Langkah Berurutan' : 'Mode Gulir Lengkap',
            icon: Icon(_isContinuousMode ? Icons.view_carousel_rounded : Icons.view_agenda_rounded),
            onPressed: () {
              setState(() {
                _isContinuousMode = !_isContinuousMode;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _isContinuousMode
            ? _buildContinuousView(context)
            : _buildStepByStepView(context),
      ),
    );
  }

  // ==========================================
  // MODE 1: STEP-BY-STEP DENGAN DIGITAL TASBIH
  // ==========================================
  Widget _buildStepByStepView(BuildContext context) {
    final item = _tahlilItems[_currentStep];
    final progress = (_currentStep + 1) / _tahlilItems.length;
    final maxCount = item.count;
    final currentCount = _counters[_currentStep] ?? 0;
    final isCountFinished = maxCount != null && currentCount >= maxCount;

    return Column(
      children: [
        // Progress Header
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          color: AppColors.surface(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Urutan ${_currentStep + 1} dari ${_tahlilItems.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (maxCount != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isCountFinished
                                ? (AppColors.isDark(context) ? const Color(0xFF0D4738) : AppColors.primaryContainer)
                                : AppColors.secondary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isCountFinished ? AppColors.primary : AppColors.secondary,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Dibaca ${maxCount}x',
                            style: TextStyle(
                              color: isCountFinished ? AppColors.primary : AppColors.secondary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 20, color: AppColors.primary),
                    tooltip: 'Salin Bacaan Ini',
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: '${item.judul}\n\n${item.teksArab}\n\n${item.teksLatin}\n\n"${item.arti}"',
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${item.judul} berhasil disalin!'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: AppColors.cardBorder(context),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: AppColors.cardBorder(context)),

        // Body Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Step Title
                Text(
                  item.judul,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    color: AppColors.text(context),
                  ),
                ),
                const SizedBox(height: 16),

                // Arabic Text Container
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  decoration: BoxDecoration(
                    color: AppColors.surface(context),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cardBorder(context)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: AppColors.isDark(context) ? 0.25 : 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    item.teksArab,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 24,
                      height: 2.1,
                      fontWeight: FontWeight.w600,
                      color: AppColors.arabic(context),
                    ),
                  ),
                ),

                // Digital Tasbih Tap Button (for repeatable steps)
                if (maxCount != null) ...[
                  const SizedBox(height: 18),
                  Center(
                    child: InkWell(
                      onTap: () => _incrementCounter(_currentStep, maxCount),
                      borderRadius: BorderRadius.circular(24),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isCountFinished
                                ? [const Color(0xFF095A46), const Color(0xFF053B2E)]
                                : (AppColors.isDark(context)
                                    ? [const Color(0xFF1B3830), const Color(0xFF132A24)]
                                    : [const Color(0xFFE2F3ED), const Color(0xFFCEECE1)]),
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isCountFinished ? const Color(0xFF10B981) : AppColors.primary,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.18),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isCountFinished ? Icons.check_circle_rounded : Icons.fingerprint_rounded,
                              color: isCountFinished ? Colors.white : AppColors.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              isCountFinished
                                  ? 'Selesai: $currentCount / $maxCount'
                                  : 'Ketuk Penghitung: $currentCount / $maxCount',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isCountFinished ? Colors.white : AppColors.primary,
                              ),
                            ),
                            if (currentCount > 0) ...[
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () => _resetCounter(_currentStep),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.refresh_rounded,
                                    size: 14,
                                    color: isCountFinished ? Colors.white70 : AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 18),

                // Transliteration Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder(context)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.record_voice_over_rounded, size: 16, color: AppColors.secondary),
                          const SizedBox(width: 8),
                          Text(
                            'Transliterasi Latin',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.subText(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.teksLatin,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontStyle: FontStyle.italic,
                          color: AppColors.primary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Translation Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder(context)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.translate_rounded, size: 16, color: AppColors.secondary),
                          const SizedBox(width: 8),
                          Text(
                            'Arti & Penjelasan',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.subText(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.arti,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: AppColors.text(context),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom Navigation Buttons
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            border: Border(top: BorderSide(color: AppColors.cardBorder(context))),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (_currentStep > 0)
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: const Text('Sebelumnya'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.text(context),
                      side: BorderSide(color: AppColors.cardBorder(context)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      setState(() {
                        _currentStep--;
                      });
                    },
                  ),
                )
              else
                const Spacer(),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  icon: Icon(
                    _currentStep < _tahlilItems.length - 1 ? Icons.arrow_forward_rounded : Icons.check_circle_rounded,
                    size: 18,
                  ),
                  label: Text(_currentStep < _tahlilItems.length - 1 ? 'Langkah Lanjut' : 'Selesai'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    if (_currentStep < _tahlilItems.length - 1) {
                      setState(() {
                        _currentStep++;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Alhamdulillah, seluruh susunan tahlil telah selesai dibaca.'),
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // MODE 2: CONTINUOUS SCROLL SELURUH 17 URUTAN
  // ==========================================
  Widget _buildContinuousView(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      physics: const BouncingScrollPhysics(),
      itemCount: _tahlilItems.length,
      itemBuilder: (context, index) {
        final item = _tahlilItems[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder(context)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: AppColors.isDark(context) ? 0.2 : 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.isDark(context)
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.primaryContainer.withValues(alpha: 0.4),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '#${index + 1}',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.judul,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.text(context),
                        ),
                      ),
                    ),
                    if (item.count != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${item.count}x',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Body
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      item.teksArab,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        height: 2.0,
                        color: AppColors.arabic(context),
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.teksLatin,
                      style: const TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: AppColors.primary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.arti,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.text(context),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
