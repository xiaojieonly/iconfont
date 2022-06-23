import 'dart:io';
import 'package:iconfont/src/data.dart';
import 'package:iconfont/src/iconfont_icon.dart';
import 'package:path/path.dart' as path;

class IconFontScanner {
  static scan() async {
    await Future.forEach(Data.ioPaths.entries,
        (MapEntry<String, String> entry) async {
      // print("${entry.key},${entry.value}");
      _scan(entry.key, entry.key, entry.value);
    });
  }

  static _scan(String dirPath, String readPath, String writePath) async {
    if (!Directory(dirPath).existsSync()) {
      // print("not found $dirPath");
      return;
    }

    var ttfPath = '';
    var jsonPath = '';

    Directory(dirPath)
        .listSync(recursive: false, followLinks: true)
        .forEach((e) {
      if (FileSystemEntity.isFileSync(e.path)) {
        if (e.path.endsWith('.json')) {
          jsonPath = e.path;
        } else if (e.path.endsWith('.ttf')) {
          ttfPath = e.path;
        } else {
          return;
        }

        if (ttfPath.isNotEmpty && jsonPath.isNotEmpty) {
          var className = path.basename(dirPath);
          var savePath = path.setExtension(
              path.joinAll([
                writePath,
                path.dirname(path.relative(e.path, from: readPath)),
              ]),
              ".dart");

          // print("className: $className");
          // print("savePath: $savePath");
          // print("readPath: $readPath");
          // print("writePath: $writePath");

          IconFontIcon.saveIconClass(
            ttfPath,
            jsonPath,
            savePath,
            className,
          );
        }
      }

      if (FileSystemEntity.isDirectorySync(e.path)) {
        _scan(e.path, readPath, writePath);
      }
    });
  }
}
