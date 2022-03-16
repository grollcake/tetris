const int kTetrisMatrixWidth = 10; // 테트리스 게임판의 타일 개수 (넓이)
const int kTetrisMatrixHeight = 20; // 테트리스 게임판의 타일 개수 (높이)
const bool kShowShadowBlock = true; // 드랍 위치 가이드 블록 표시여부
const int kCleansForStage = 10; // 한 단계당 지워야 할 줄 수
const Duration kInitalSpeed = Duration(milliseconds: 1000); // 초기 게임 속도
const double kSpeedUpForLevel = 0.2; // 레벨업 할때마다 증가시킬 속도값 %
const String kGithubUrl = 'https://github.com/grollcake/DanceWithFlutter/tree/master/Era/_210104_tetris';
