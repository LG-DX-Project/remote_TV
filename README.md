remote_controller_app/
├── assets/
│   └── ...                # 이미지, 아이콘 등
│
├── ios/
├── android/
├── macos/
├── linux/
├── windows/
├── web/
│
├── lib/
│   ├── main.dart
│   │
│   ├── features/
│   │   ├── home/
│   │   │   └── home_page.dart //그냥 띵큐 메인 사진
│   │   │
│   │   ├── remote/
│   │   │   ├── remote_home_page.dart
│   │   │   ├── remote_page.dart //실제 기능들
│   │   │   └── shake_mode.dart //폰 흔들면 생기는 로직들 구현할려고 만들어 두긴 함
│   │   │
│   │   ├── settings/
│   │   │   └── setting_page.dart //사실 환경설정 할거 같아서 만들어두긴 했지만 비워둠
│   │   │
│   │   └── turn_on/
│   │       └── ... (turn on TV 관련 페이지)
│   │
│   └── utils/
│       └── ...            # 레이아웃, 공용 함수 등(있다면)
│
├── test/
│   └── ...                # Flutter test 코드
│
├── pubspec.yaml
├── .gitignore
└── README.md

