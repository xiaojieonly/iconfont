import 'dart:convert';

import 'package:iconfont/src/utils.dart';

import 'constants.dart';

import 'iconfont_data.dart';

import 'package:path/path.dart' as path;

class IconFontCss {
  final String cssUrl;
  final String dirPath;
  final String? fontPackage;
  const IconFontCss({
    required this.cssUrl,
    required this.dirPath,
    this.fontPackage,
  });

  downloadFromCss() async {
    if (cssUrl.isEmpty) return;

    final data = IconFontData.parse(await Utils.httpGet(cssUrl));
    data.fontPackage = fontPackage;
    Utils.writeToFile(
      path.joinAll([dirPath, Constants.ICONFONT_FILE_JSON]),
      jsonEncode(data),
    );

    Utils.writeToFile(
      path.joinAll([dirPath, Constants.ICONFONT_FILE_TEXT]),
      data.tffPath!,
    );

    await Utils.downloadToFile(
      path.joinAll([dirPath, Constants.ICONFONT_FILE_TTF]),
      data.tffPath!,
    );
  }
}
