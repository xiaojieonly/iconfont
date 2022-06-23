import 'dart:convert';
import 'dart:io';

import 'package:iconfont/src/iconfont_css.dart';
import 'package:iconfont/src/pub.dart';
import 'package:yaml/yaml.dart';

import 'constants.dart';
import 'data.dart';
import 'iconfont_config.dart';

import 'package:path/path.dart' as path;

import 'iconfont_scanner.dart';

class IconFontBuilder {
  static build(IconFontConfig config) async {
    Data.ioPaths[config.readPath] = config.writePath;

    // print(
    //     "config.readPath: ${config.readPath}, config.writePath: ${config.writePath}");

    await IconFontCss(
      cssUrl: config.cssUrl,
      dirPath: path.joinAll([config.readPath, config.dirName]),
      fontPackage: config.fontPackage,
    ).downloadFromCss();
  }

  static defaultBuild() {}

  static buildFromYamlConfig(String configPath) async {
    var yamlConfig =
        jsonDecode(jsonEncode(loadYaml(File(configPath).readAsStringSync())));

    if (path.basename(configPath) == Constants.PUBSPECYAML) {
      yamlConfig = yamlConfig["iconfont"] ?? [];
    }

    await Future.forEach(yamlConfig, (e) async {
      final c = IconFontYamlConfig.fromJson(jsonDecode(jsonEncode(e)));
      await Future.forEach(c.icons ?? [], (icon) async {
        await build(IconFontConfig(
          cssUrl: (icon as IconFontYamlConfigItem).css ?? "",
          dirName: icon.dir ?? "",
          fontPackage: icon.package ?? "",
          readPath: c.readPath ?? Constants.DEFAULT_READ_PATH,
          writePath: c.writePath ?? Constants.DEFAULT_WRITE_PATH,
        ));
      });
    });
  }

  static scanAndPubSave() async {
    await IconFontScanner.scan();
    await Pub.save();
  }
}
