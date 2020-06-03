import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

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
  _init() async {
    if (this.pubspecYaml == null) {
      print("not found pubspec.yaml");
      return;
    }

    await _loadCss();
    await _scanDir(IconfontConfig.readPath);

    await iconfontMap.forEach((key, value) async {
      await _addYaml(key, value);
    });

    print("success");
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
        } else if (e.path.endsWith('.ttf')) {
          ttfPath = e.path;
        } else {
          return;
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
  _saveIcon(
      String ttfPath, String jsonPath, String savePath, String className) {
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
    bool exists = file.existsSync();
    if (!exists) {
      file.createSync(recursive: true);
    }
    file.writeAsStringSync(tmp);

    print("build $savePath from $ttfPath and $jsonPath");
  }

  /// 添加字体到 pubspec.yaml 中
  _addYaml(String family, List<String> iconfontPath) async {
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

  /// 载入css url
  _loadCss() async {
    if (IconfontConfig.dirName.isEmpty || IconfontConfig.cssUrl.isEmpty) {
      return;
    }

    Response response;
    Dio dio = Dio();
    var url = _fillUrl(IconfontConfig.cssUrl);
    if (url.isEmpty) {
      return;
    }

    response = await dio.get(url);
    String data = response.data.toString();

    var ttfUrl =
        RegExp(r"//at.alicdn.com/t/font.*\.ttf\?t=[0-9]{13}").stringMatch(data);

    var iconJson = {
      "font_family":
          RegExp(r'font-family: "(.+?)";').firstMatch(data)?.group(1),
      "css_prefix_text": "",
      "glyphs": RegExp(r'\.(.+):before[\S\s]*?content: "\\(.+)";')
          .allMatches(data)
          .map((m) {
        return {
          "font_class": m.group(1),
          "unicode": m.group(2),
          "name": "",
        };
      }).toList()
    };

    var dir = Directory(
        path.joinAll([IconfontConfig.readPath, IconfontConfig.dirName]));
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    var iconfontJsonFile = File(path.joinAll([dir.path, "iconfont.json"]));
    iconfontJsonFile.writeAsStringSync(json.encode(iconJson));

    var iconfontTxtFile = File(path.joinAll([dir.path, "iconfont.txt"]));
    iconfontTxtFile.writeAsStringSync(url);

    await dio.download(
        _fillUrl(ttfUrl), path.joinAll([dir.path, "iconfont.ttf"]));
  }

  /// 补全url
  String _fillUrl(String url) {
    var index = url.indexOf("at.alicdn.com");
    if (index == -1) {
      print("cssUrl is error");
      return "";
    }
    return url.replaceRange(0, index, "http://");
  }
}
