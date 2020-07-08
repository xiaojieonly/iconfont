import 'dart:io';

/// PubType
enum PubType {
  FFFA,
  FFF,
  FF,
  F,
}

/// GetFlutter
typedef GetFlutter = Map<String, dynamic> Function();

/// PubTemp
class PubTemp {
  /// build
  static void build(
      String family, List<String> iconfontPath, GetFlutter getFlutter) {
    var lines = File("pubspec.yaml").readAsStringSync().split('\n');
    Map<String, dynamic> flutter = getFlutter();

    if (flutter.containsKey("fonts")) {
      if (flutter['fonts'] == null) {
        lines.insert(_getLine(lines, "^  fonts.*\$"),
            _getTemp(_getAssetContent(iconfontPath), PubType.FF, family));
      } else {
        var iconfont = flutter['fonts']
            .where((e) => e.containsKey("family") && e["family"] == family)
            .toList();

        if (iconfont.isEmpty) {
          lines.insert(_getLine(lines, "^  fonts.*\$"),
              _getTemp(_getAssetContent(iconfontPath), PubType.FF, family));
        } else {
          if (iconfont[0].containsKey("fonts")) {
            String temp = _getTemp(
                _getAssetContent(iconfontPath, iconfont[0]['fonts']),
                PubType.FFFA,
                family);
            if (temp.isNotEmpty)
              lines.insert(
                  _getLine(lines, "^.*family:\\s*$family\\s*\$") + 1, temp);
          } else {
            String temp =
                _getTemp(_getAssetContent(iconfontPath), PubType.FFF, family);
            if (temp.isNotEmpty)
              lines.insert(
                  _getLine(lines, "^.*family:\\s*$family\\s*\$"), temp);
          }
        }
      }
    } else {
      lines.insert(_getLine(lines, "^flutter.*\$"),
          _getTemp(_getAssetContent(iconfontPath), PubType.F, family));
    }
    File("pubspec.yaml").writeAsStringSync(lines.join("\n"));
  }

  static int _getLine(List<String> lines, String reg) {
    int line = lines.indexWhere((element) => RegExp(reg).hasMatch(element));
    if (line == -1) {
      throw Exception("pubspec.yaml exception");
    }
    return line + 1;
  }

  /// _getAssetContent
  static String _getAssetContent(List<String> iconfontPath,
      [List mFonts = null]) {
    List list = iconfontPath;
    if (mFonts != null) {
      Set set = iconfontPath.toSet()..removeAll(mFonts.map((e) => e['asset']));
      list = set.toList();
    }
    return list.map((e) => '''        - asset: $e''').join("\n");
  }

  /// _getTemp
  static String _getTemp(String assetContent, PubType type, String family) {
    String temp = "";

    int index = type.index;

    if (index >= PubType.FFFA.index) {
      temp = assetContent;
    }

    if (index >= PubType.FFF.index) {
      temp = '''      fonts:\n$temp''';
    }

    if (index >= PubType.FF.index) {
      temp = '''    - family: $family\n$temp''';
    }

    if (index >= PubType.F.index) {
      temp = '''  fonts:\n$temp''';
    }
    return temp;
  }
}
