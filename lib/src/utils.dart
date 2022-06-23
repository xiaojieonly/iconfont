import 'package:path/path.dart' as path;

import 'package:http/http.dart' as http;
import 'dart:io';

/// Utils
class Utils {
  /// 格式化
  static formatName(String str) {
    return str
        .split("_")
        .map((e) => e.isNotEmpty ? capitalize(e) : "")
        .join("")
        .replaceAll('-', '_')
        .split("_")
        .map((e) => e.isNotEmpty ? capitalize(e) : "")
        .join("_");
  }

  /// 首字母大写
  static String capitalize(String str) {
    return "${str[0].toUpperCase()}${str.substring(1)}";
  }

  // 创建文件夹
  static createDir(String p) {
    var dir = Directory(p);
    if (!dir.existsSync()) dir.createSync(recursive: true);
  }

  // 写入文件
  static writeToFile(String filePath, String contents) {
    createDir(path.dirname(filePath));
    File(filePath).writeAsStringSync(contents);
  }

  // http get
  static Future<String> httpGet(String url) async {
    Uri uri = Uri.parse(url);
    uri = uri.replace(scheme: "http");

    final rsp = await http.get(uri);
    if (rsp.statusCode != 200) {
      print("${uri.toString()} 请求失败 , statusCode = ${rsp.statusCode}");
      return "";
    }

    final contents = rsp.body;
    return contents;
  }

  // 下载到文件
  static Future<void> downloadToFile(String filePath, String url) async {
    final contents = await httpGet(url);
    writeToFile(filePath, contents);
  }
}
