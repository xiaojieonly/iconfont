name: example
version: 1.0.0+1
description: A new Flutter project.
publish_to: none

dependencies:
  cupertino_icons: ^0.1.3
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  iconfont:
    path: ../

environment:
  sdk: ">=2.7.0 <3.0.0"

flutter:
  uses-material-design: true
  fonts:
    -
          family: myiconfont
          fonts:
            -
                  asset: assets/fonts/my_icon/iconfont.ttf
