import 'package:audioplayers/audioplayers.dart';
import 'package:tetris/managers/app_settings.dart';

class SoundEffect {
  late AudioCache _audioPlayer;
  final rotateSoundFile = 'sound/rotate.wav'; // 블록 회전
  final fixingSoundFile = 'sound/fixing.wav'; // 블록 위치 확정
  final dropSoundFile = 'sound/drop.wav'; // 블록 떨어뜨리기
  final clearningSoundFile = 'sound/clearning.wav'; // 완성줄 삭제
  final holdSoundFile = 'sound/hold.wav'; // 블록 보관
  final gameEndSoundFile = 'sound/game-end.wav'; // 게임종료
  final levelUpSoundFile = 'sound/level-up.wav'; // 현재 레벨 완료

  AppSettings settings = AppSettings();

  Future<void> init() async {
    _audioPlayer = AudioCache();
    await _audioPlayer.loadAll([
      rotateSoundFile,
      fixingSoundFile,
      dropSoundFile,
      clearningSoundFile,
      holdSoundFile,
      gameEndSoundFile,
      levelUpSoundFile,
    ]);
    print('SoundEffect loaded ok');
  }

  void dispose() {
    _audioPlayer.clearAll();
  }

  Future<bool> _sound(String soundFile) async {
    if (!settings.soundEffect) {
      return false;
    }
    await _audioPlayer.play(soundFile, mode: PlayerMode.LOW_LATENCY);
    return true;
  }

  Future<bool> rotateSound() async => _sound(rotateSoundFile);

  Future<bool> fixingSound() async => _sound(fixingSoundFile);

  Future<bool> dropSound() async => _sound(dropSoundFile);

  Future<bool> clearningSound() async => _sound(clearningSoundFile);

  Future<bool> holdSound() async => _sound(holdSoundFile);

  Future<bool> gameEndSound() async => _sound(gameEndSoundFile);

  Future<bool> levelUpSound() async => _sound(levelUpSoundFile);
}
