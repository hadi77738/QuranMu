import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class AudioState {
  final bool isPlaying;
  final bool isLoading;
  final String? currentTitle;
  final String? currentSubtitle;
  final Duration position;
  final Duration duration;

  const AudioState({
    this.isPlaying = false,
    this.isLoading = false,
    this.currentTitle,
    this.currentSubtitle,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  AudioState copyWith({
    bool? isPlaying,
    bool? isLoading,
    String? currentTitle,
    String? currentSubtitle,
    Duration? position,
    Duration? duration,
  }) {
    return AudioState(
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      currentTitle: currentTitle ?? this.currentTitle,
      currentSubtitle: currentSubtitle ?? this.currentSubtitle,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }
}

class AudioNotifier extends Notifier<AudioState> {
  final AudioPlayer _player = AudioPlayer();

  @override
  AudioState build() {
    _player.playerStateStream.listen((playerState) {
      state = state.copyWith(
        isPlaying: playerState.playing,
        isLoading: playerState.processingState == ProcessingState.loading ||
            playerState.processingState == ProcessingState.buffering,
      );
    });

    _player.positionStream.listen((pos) {
      state = state.copyWith(position: pos);
    });

    _player.durationStream.listen((dur) {
      if (dur != null) {
        state = state.copyWith(duration: dur);
      }
    });

    ref.onDispose(() {
      _player.dispose();
    });

    return const AudioState();
  }

  Future<void> playAudio(String url, {required String title, required String subtitle}) async {
    try {
      state = state.copyWith(
        isLoading: true,
        currentTitle: title,
        currentSubtitle: subtitle,
      );
      if (url.startsWith('assets/')) {
        await _player.setAsset(url);
      } else {
        await _player.setUrl(url);
      }
      await _player.play();
    } catch (e) {
      state = state.copyWith(isLoading: false, isPlaying: false);
    }
  }

  Future<void> togglePlay() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> stop() async {
    await _player.stop();
    state = const AudioState();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> seekRelative(Duration offset) async {
    final current = _player.position;
    final total = _player.duration ?? Duration.zero;
    var target = current + offset;
    if (target < Duration.zero) target = Duration.zero;
    if (target > total && total > Duration.zero) target = total;
    await _player.seek(target);
  }

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }
}

final audioPlayerProvider =
    NotifierProvider<AudioNotifier, AudioState>(AudioNotifier.new);
