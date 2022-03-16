import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import 'package:tetris/managers/app_settings.dart';

class SoundEffect {
  Soundpool? _soundpool;
  int _rotateSoundId = 0; // 블록 회전
  int _movingSoundId = 0; // 블록 이동
  int _fixingSoundId = 0; // 블록 위치 확정
  int _dropSoundId = 0; // 블록 떨어뜨리기
  int _clearningSoundId = 0; // 완성줄 삭제
  int _holdSoundId = 0; // 블록 보관
  int _gameEndSoundId = 0; // 게임종료
  int _levelUpSoundId = 0; // 현재 레벨 완료

  AppSettings settings = AppSettings();

  Future<void> init() async {
    _soundpool = Soundpool(streamType: StreamType.alarm);

    var asset = await rootBundle.load('assets/sound/rotate.wav');
    _rotateSoundId = await _soundpool!.load(asset);

    asset = await rootBundle.load('assets/sound/moving.wav');
    _movingSoundId = await _soundpool!.load(asset);

    asset = await rootBundle.load('assets/sound/fixing.wav');
    _fixingSoundId = await _soundpool!.load(asset);

    asset = await rootBundle.load('assets/sound/drop.wav');
    _dropSoundId = await _soundpool!.load(asset);

    asset = await rootBundle.load('assets/sound/clearning.wav');
    _clearningSoundId = await _soundpool!.load(asset);

    asset = await rootBundle.load('assets/sound/hold.wav');
    _holdSoundId = await _soundpool!.load(asset);

    asset = await rootBundle.load('assets/sound/game-end.wav');
    _gameEndSoundId = await _soundpool!.load(asset);

    asset = await rootBundle.load('assets/sound/level-up.wav');
    _levelUpSoundId = await _soundpool!.load(asset);

    print('SoundEffect loaded ok');
  }

  void dispose() {
    if (_soundpool == null) {
      return;
    }
    _soundpool!.release();
    _soundpool!.dispose();
  }

  Future<int> _sound(int soundId) async {
    if (_soundpool != null && !settings.soundEffect) {
      return 0;
    }
    return await _soundpool!.play(soundId);
  }

  Future<int> rotateSound() async => _sound(_rotateSoundId);
  Future<int> movingSound() async => _sound(_movingSoundId);
  Future<int> fixingSound() async => _sound(_fixingSoundId);
  Future<int> dropSound() async => _sound(_dropSoundId);
  Future<int> clearningSound() async => _sound(_clearningSoundId);
  Future<int> holdSound() async => _sound(_holdSoundId);
  Future<int> gameEndSound() async => _sound(_gameEndSoundId);
  Future<int> levelUpSound() async => _sound(_levelUpSoundId);
}
