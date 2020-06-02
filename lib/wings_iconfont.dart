import 'dart:convert';
import 'dart:io';

import 'config.dart';
import 'iconfont_model.dart';

import 'package:path/path.dart' as path;
import 'package:pubspec_yaml/pubspec_yaml.dart';

class WingsIconfont {
  /// pubspecYaml
  PubspecYaml pubspecYaml;

  /// <fontFamily,assetPaths>
  Map<String, List<String>> iconfontMap = {};

  WingsIconfont() {
    this.pubspecYaml =
        File(IconfontConfig.yamlPath).readAsStringSync().toPubspecYaml();

    _init();
  }

  /// init、
  _init() {
    _scanDir(IconfontConfig.readPath);

    iconfontMap.forEach((key, value) {
      _addYaml(key, value);
    });
  }

  /// 扫描文件夹
  _scanDir(String dir) {
    if (!Directory(dir).existsSync()) {
      print("not found $dir");
      return;
    }

    var ttfPath = '';
    var jsonPath = '';

    Directory(dir).listSync(recursive: false, followLinks: true).forEach((e) {
      if (FileSystemEntity.isFileSync(e.path)) {
        if (e.path.endsWith('.json')) {
          jsonPath = e.path;
        }
        if (e.path.endsWith('.ttf')) {
          ttfPath = e.path;
        }

        if (ttfPath.isNotEmpty && jsonPath.isNotEmpty) {
          var pathList =
              path.split(e.path.replaceFirst(IconfontConfig.readPath, ''));
          var className = (pathList..removeLast()).last;
          var savePath =
              '${path.joinAll([IconfontConfig.writePath, ...pathList])}.dart';
          _saveIcon(ttfPath, jsonPath, savePath, className);
        }
      }

      if (FileSystemEntity.isDirectorySync(e.path)) {
        _scanDir(e.path);
      }
    });
  }

  /// 保存字体文件
  _saveIcon(String ttfPath, String jsonPath, String savePath,
      String className) async {
    var iconFontModel =
        IconFontModel.fromJson(json.decode(File(jsonPath).readAsStringSync()));
    String tmp = IconfontConfig.getIconFontTemp(
        iconFontModel, IconfontConfig.formatName(className));

    if (iconfontMap.containsKey(iconFontModel.fontFamily)) {
      iconfontMap[iconFontModel.fontFamily].add(ttfPath);
    } else {
      iconfontMap.addAll({
        iconFontModel.fontFamily: [ttfPath]
      });
    }

    var file = File(savePath);
    bool exists = await file.exists();
    if (!exists) {
      file.createSync(recursive: true);
    }
    file.writeAsStringSync(tmp);

    print("build $savePath from $ttfPath and $jsonPath");
  }

  /// 添加字体到 pubspec.yaml 中
  _addYaml(String family, List<String> iconfontPath) {
    Map<String, dynamic> flutter =
        (pubspecYaml.customFields['flutter'] as Map<String, dynamic>);
    List<Map<String, String>> iconfontPathMap =
        iconfontPath.map((e) => {"asset": e}).toList();

    if (flutter.containsKey("fonts")) {
      List<dynamic> fonts = flutter['fonts'];

      List<dynamic> iconfont = fonts
          .where((e) => e.containsKey("family") && e["family"] == family)
          .toList();

      if (iconfont.isEmpty) {
        // 没有导入过iconfont
        fonts.add({
          "family": family,
          "fonts": iconfontPathMap,
        });
      } else {
        // 导入过iconfont
        iconfont[0].addAll({
          "fonts": iconfontPathMap,
        });
      }
    } else {
      flutter.addAll({
        "fonts": [
          {
            "family": family,
            "fonts": iconfontPathMap,
          }
        ]
      });
    }

    File(IconfontConfig.saveYamlPath)
        .writeAsStringSync(pubspecYaml.toYamlString());
  }
}
