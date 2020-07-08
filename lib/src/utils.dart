/// Utils
class Utils {
  /// 格式化
  static formatName(String str) {
    return str
        .replaceAll('-', '_')
        .split("_")
        .map((e) => e.isNotEmpty ? capitalize(e) : "")
        .join("");
  }

  /// 首字母大写
  static String capitalize(String str) {
    return "${str[0].toUpperCase()}${str.substring(1)}";
  }

  /// 补全url
  static String getUrl(String url) {
    var index = url.indexOf("at.alicdn.com");
    if (index == -1) {
      print("cssUrl is error");
      return "";
    }
    return url.replaceRange(0, index, "http://");
  }
}
