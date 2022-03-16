import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tetris/constants/app_style.dart';
import 'package:tetris/managers/app_settings.dart';
import 'package:tetris/managers/gameplay_manager.dart';
import 'package:tetris/screens/intro/intro_screen.dart';

// Done GameStart dialog 화면
// Done 가로크기를 11로 했을 때 블록 생성이 잘 못되는 문제 수정
// Done 점수 계산하기
// Done Game End 처리
// Done Next 블록 표시
// Done Hold 기능 처리
// done 조작 버튼 간격 조정
// Done 블록 생성 통계 정보 표시
// Done 둥근 버튼의 횡 패딩 공간 최소화
// Done 같은 블록 연속으로 나오는것 방지
// Done Drop 기능
// Done HOLD Change는 블록당 한번만 가능
// Done 마지막 생성된 블록이 기존 블록을 겹치는 문제 (게임종료 조건에서..)
// Done Dialog에 흰색 테두리 추가
// Done 드랍위치 가이드 블록 표시
// Done 상수 파일 분리
// Done Drop시 화면 흔들림
// Done 레벨 구현
// Done 레벨처리를 TTBlock 클래스 내부에 구현
// Done Drop을 연타하면 블록이 무한 재생성되는 문제 수정
// Done 게임시간 불일치 문제 (현재 레벨과 전체 진행시간 차이)
// Done 미리보기 블록 구현 방식을 column x row로 변경
// Done game end 블록 생성 시 기존 블록과 겹치는 문제 수정
// Done 제스처로 블록 이동
// Done 제스처 강도에 따른 블록 이동
// Done Intro 화면 구현
// Done 전체 레이아웃 다시 잡기
// Done 배경 이미지 추가
// Done 스와이프 동작의 반응성 개선
// Done SwipeDown을 연속으로 하는 경우 빠르게 불록이 나타났다 사라지는 현상 수정
// Done pause 구현
// Done 뒤로가기 버튼 비활성화
// Done 앱 아이콘 제작
// Done (오류수정) Hold 후 그림자 블록이 예전 모양으로 잠시 나타나는 문제 수정
// Done (개선) 스와이프 반응성 개선
// Done App에 github 연결 아이콘 추가
// Done (설정화면) 컬러테마 선택
// Done (설정화면) 블록모양 선택
// Done (설정화면) 배경이미지 선택
// Done (설정화면) github 연결 페이지
// Done 타일을 더 이쁘게 그리기 위해 별도 위젯(TTTile)으로 분리
// Done 설정 내용을 기기에 저장
// Done (설정화면) 가이드라인, 그림자 블록
// Done 효과음 추가 - 일단 소리는 난다
// Done 마지막으로 봤던 설정화면 유지
// Done 배경음악 추가
// Done 타일 디자인 새로하기
// Done 배경음악 변경
// Done 효과음 추가 - clearning, hold, game-end, level-up
// Done Firestore에 scoreboard db 생성
// Done Scoreboard 보기 화면
// Done 새로운 개인 기록 갱신 시에만 점수 업데이트
// Done 기기UUID, platform 정보 획득하여 scoreboard db에 저장
// Done Scoreboard에서 이름 변경
// Done Web 버전에서 firestore 작동하도록 하기
// Done Scoreboard의 내 점수 위치로 자동 스크롤
// Done Scoreboard를 stream으로 변경
// Done Scoreboard 화면 처음 접근 시 이름 물어보기
// Done 타일의 명암표현 개선
// Done About 페이지 완성 (lottie 애니메이션 사용)
// Done 피드백 보내기 기능
// Done sound effect 옵션 처리
// Done (문제해결) 배경화면이 늦게 나타나는 문제  -- release 모드 사용시 해결됨
// Done 타일의 모양 개선
// Done (문제해결) 낮은 터치 감도와 자연스러운 스와이프 추적
// Done (문제해결) SwipeDrop, SwipeUp이 자주 발생함
// Done (설정화면) 스와이프 감도 설정 화면 구현
// Done (문제해결) lottie 이미지가 깨져서 gif로 교체
// Done (문제해결) 미세한 스와이프 이동 감지
// Done gameend dialog에서 scoreboard 바로가기 추가
// Done 새로운 기록 달성 시 toast 메시지로 안내
// Done (문제해결) 이동거리가 2칸 미만인 경우 drop이 되지 않음
// Done (문제해결) flutter 2.10 미대응으로 soundpool을 audio_play로 변경
// Done Fixing 사운드 추가
// Done 앱 아이콘 변경
// Done 인트로 화면의 로고 변경 및 타일 색상 고정
// Done 로고 변경 (인트로 화면의 로고와 맞춤)
// Done 모든 한글을 영어로 변경
// Done 게임종료 다이얼로그에 현재 순위 보이기
// Done setState => Provider 변경
// Done 점수, 레벨을 ttboard에서 분리
// Done kIsWeb인 경우 사운드 미사용을 기본값으로
// Done newplay_screen을 gameplay_screen으로 이름 변경
// Done 설정이 바뀌면 즉시 반영되어야 해 (특히 배경화면)
// Done 효과음을 soundpool 패키지로 변경
// Done 레고 타일을 좀 더 산뜻하게 개선
// Done (오류) swipeUp 착오 감지
// Done (오류) scoreboard 등록 오류
// Done (문제) iOS PWA에서 레벨4 정도 진행하면 멈추는 문제 -> release 모드로 빌드 후 해결
// Done 새로운 기록 달성 시 toast 메시지로 안내
// Done (오류) 드랍 사운드 중첩 문제
// Done (문제) Pause 버튼과 rotate 기능이 겹치는 문제 -> pause 버튼 위치 이동
// Done 세팅에서 타일 타입 변경 즉시 반영
// Done 그림자 블록 모양 개선
// Done (오류) 드랍다운을 연속으로 하면 여러 블록이 연속으로 재생성
// Done (오류) new record가 0점일때도 나오고, 계속 반복해서 나타남
// Done mail을 개인 메일로 수신하도록 변경 (emailjs 서비스 이용)
// Done about 페이지에 lottie 이미지로 교체 테스트
// Done lottie 배경 이미지
// Done 레고타일인 경우 타일사이 간격 제거
// Done scoreboard 로딩 이미지에 lottie 사용
// Done Fixing 애니메이션 추가
// Done 좌우 이동에 대한 사운드 추가
// Done 저작권 문제없는 배경화면으로 변경
// Done 피드백 전송 중 로딩 이미지 보이기
// Done (오류) FlashingWidget dispose 오류 발생
// Done 왼쪽 상단에 사용자 이름 보이기
// Done 점수판에서 이름 바꾸는 로직 변경
// Done (문제) 로딩이미지가 너무 작게 나오는 문제
// Done 플레이 화면 크기를 반응형으로 조정
// todo (개선) 이름 등록없이도 점수표 볼 수 있도록 변경
// todo (문제) 점수표 최초 등록 후 점수판에서 하단 이름 변경 진행중 버튼이 나타남
// todo (문제) 가끔 pause 버튼이 작동하지 않음
// todo (문제) Drop, clearning 사운드가 겹칩
// todo (품질) 배경음과 효과음 레벨 조정 (배경음을 작게 하거나 효과음을 크게)
// todo (품질) 좌우로 스와이프가 길어지면 드랍의 트리거 길이도 늘려서 오작동을 줄여야 해
// todo (신기능) 네트워크 플레이
// todo github 프로젝트 분리
// todo github page에 배포
// todo credit 페이지 (이미지, lottie 저작권 표시)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyD58BWL2DUmhOxrA9FnmH1xvfnN0i0woco',
        appId: '1:652156923882:web:cf16fcdec83661f4724c93',
        messagingSenderId: '652156923882',
        projectId: 'tetris-2022',
      ),
    );
  } else {
    Firebase.initializeApp();
  }

  // return runApp(TestScreen());

  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppSettings>(create: (_) => AppSettings()),
        ChangeNotifierProvider<GamePlayManager>(create: (_) => GamePlayManager()),
      ],
      child: TetrisApp(),
    ),
  );
}

class TetrisApp extends StatelessWidget {
  const TetrisApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AppSettings>().loadSettings(); // 설정 정보 읽어오기
    return MaterialApp(
      title: 'Tetris',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppStyle.bgColor,
      ),
      home: IntroScreen(),
    );
  }
}
