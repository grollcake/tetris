import 'package:audioplayers/audioplayers.dart';

class BgmPlayer {
  static const _bgmFile = 'sound/background.wav';
  static const _bgmVolume = 0.3;

  late AudioPlayer _audioPlayer;
  late AudioCache _audioCache;
  PlayerState _bgmStatus = PlayerState.STOPPED;
  PlayerState get bgmStatus => _bgmStatus;

  void init() {
    _audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    _audioCache = AudioCache(fixedPlayer: _audioPlayer);
    _audioCache.loadAll([_bgmFile]);
  }

  void dispose() {
    _audioPlayer.release();
    _audioPlayer.dispose();
    _audioCache.clearAll();
  }

  Future<void> startBGM() async {
    await _audioCache.loop(_bgmFile, volume: _bgmVolume);
    _bgmStatus = PlayerState.PLAYING;
  }

  Future<void> stopBGM() async {
    await _audioPlayer.stop();
    _bgmStatus = PlayerState.STOPPED;
  }

  Future<void> pauseBGM() async {
    await _audioPlayer.pause();
    _bgmStatus = PlayerState.PAUSED;
  }

  Future<void> resumeBGM() async {
    await _audioPlayer.resume();
    _bgmStatus = PlayerState.PLAYING;
  }

  Future<int> muteBgm() async {
    return await _audioPlayer.setVolume(0);
  }

  Future<int> unmuteBgm() async {
    return await _audioPlayer.setVolume(_bgmVolume);
  }
}
