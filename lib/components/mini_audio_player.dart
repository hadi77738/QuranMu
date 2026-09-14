import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';

class MiniAudioPlayer extends ConsumerWidget {
  const MiniAudioPlayer({super.key});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      final hours = duration.inHours.toString();
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioPlayerProvider);

    if (state.currentTitle == null) {
      return const SizedBox.shrink();
    }

    final posMs = state.position.inMilliseconds.toDouble();
    final durMs = state.duration.inMilliseconds.toDouble();
    final progress = (durMs > 0) ? (posMs / durMs).clamp(0.0, 1.0) : 0.0;

    return InkWell(
      onTap: () => _showFullPlayerSheet(context, ref),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Slim Progress Bar at Top of Mini Bar
            LinearProgressIndicator(
              value: progress,
              minHeight: 2.5,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: SafeArea(
                top: false,
                bottom: false,
                child: Row(
                  children: [
                    IconButton(
                      icon: state.isLoading
                          ? const SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.secondary),
                            )
                          : Icon(
                              state.isPlaying
                                  ? Icons.pause_circle_filled_rounded
                                  : Icons.play_circle_fill_rounded,
                              color: AppColors.secondary,
                              size: 38,
                            ),
                      onPressed: () {
                        ref.read(audioPlayerProvider.notifier).togglePlay();
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.currentTitle ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  state.currentSubtitle ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFFBCE3D6),
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '• ${_formatDuration(state.position)} / ${_formatDuration(state.duration)}',
                                style: const TextStyle(
                                  color: Color(0xFFE2F3ED),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                      tooltip: 'Tutup Pemutar',
                      onPressed: () {
                        ref.read(audioPlayerProvider.notifier).stop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullPlayerSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(audioPlayerProvider);
            final notifier = ref.read(audioPlayerProvider.notifier);

            final posMs = state.position.inMilliseconds.toDouble();
            final durMs = state.duration.inMilliseconds.toDouble();
            final maxMs = (durMs > 0) ? durMs : 1.0;
            final currentSliderVal = posMs.clamp(0.0, maxMs);

            return Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              decoration: const BoxDecoration(
                color: Color(0xFF0B231B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Emblem Artwork
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryDark,
                      border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4), width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary.withValues(alpha: state.isPlaying ? 0.25 : 0.08),
                          blurRadius: 28,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.mosque_rounded, size: 60, color: AppColors.secondary),
                  ),
                  const SizedBox(height: 20),

                  // Title & Subtitle
                  Text(
                    state.currentTitle ?? 'Pemutar Murottal',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.currentSubtitle ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFBCE3D6),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Seek Slider (Bisa digeser ke menit/detik yang diinginkan)
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.secondary,
                      inactiveTrackColor: Colors.white.withValues(alpha: 0.15),
                      thumbColor: Colors.white,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                      overlayColor: AppColors.secondary.withValues(alpha: 0.2),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: currentSliderVal,
                      min: 0.0,
                      max: maxMs,
                      onChanged: (val) {
                        notifier.seek(Duration(milliseconds: val.round()));
                      },
                    ),
                  ),

                  // Timestamp Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(state.position),
                          style: const TextStyle(color: Color(0xFFBCE3D6), fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          _formatDuration(state.duration),
                          style: const TextStyle(color: Color(0xFFBCE3D6), fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Main Controls: Rewind 10s, Play/Pause, Forward 10s
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 32,
                        icon: const Icon(Icons.replay_10_rounded, color: Colors.white),
                        tooltip: 'Mundur 10 Detik',
                        onPressed: () {
                          notifier.seekRelative(const Duration(seconds: -10));
                        },
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.secondary,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondary.withValues(alpha: 0.4),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          iconSize: 44,
                          color: AppColors.onSecondary,
                          icon: state.isLoading
                              ? const SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.onSecondary),
                                )
                              : Icon(state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                          onPressed: () {
                            notifier.togglePlay();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        iconSize: 32,
                        icon: const Icon(Icons.forward_10_rounded, color: Colors.white),
                        tooltip: 'Maju 10 Detik',
                        onPressed: () {
                          notifier.seekRelative(const Duration(seconds: 10));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Speed Control Options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [0.75, 1.0, 1.25, 1.5].map((spd) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () => notifier.setSpeed(spd),
                          child: Text('${spd}x', style: const TextStyle(fontSize: 11)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
