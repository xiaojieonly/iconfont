import 'dart:convert';
import 'dart:io';

import 'package:iconfont/src/iconfont_data.dart';
import 'package:iconfont/src/pub.dart';
import 'package:iconfont/src/temp/icon_temp.dart';
import 'package:iconfont/src/utils.dart';

class IconFontIcon {
  static saveIconClass(
    String ttfPath,
    String jsonPath,
    String savePath,
    String className,
  ) {
    final data =
        IconFontData.fromJson(jsonDecode(File(jsonPath).readAsStringSync()));

    String tmp = IconTemp.build(Utils.formatName(className), data);

    if (data.fontFamily!.isNotEmpty) Pub.addAssert(data.fontFamily!, ttfPath);

    Utils.writeToFile(savePath, tmp);

    print("build $savePath from $ttfPath and $jsonPath");
  }
}
