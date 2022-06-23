class IconFontConfig {
  final String readPath;
  final String writePath;
  final String dirName;
  final String cssUrl;
  final String fontPackage;

  const IconFontConfig({
    required this.readPath,
    required this.writePath,
    required this.dirName,
    required this.cssUrl,
    required this.fontPackage,
  });
}

class IconFontYamlConfig {
  String? readPath;
  String? writePath;
  List<IconFontYamlConfigItem>? icons;

  IconFontYamlConfig({this.readPath, this.writePath, this.icons});

  IconFontYamlConfig.fromJson(Map<String, dynamic> json) {
    readPath = json['in'];
    writePath = json['out'];
    if (json['icons'] != null) {
      icons = <IconFontYamlConfigItem>[];
      json['icons'].forEach((v) {
        icons!.add(new IconFontYamlConfigItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['in'] = this.readPath;
    data['out'] = this.writePath;
    if (this.icons != null) {
      data['icons'] = this.icons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IconFontYamlConfigItem {
  String? css;
  String? dir;
  String? package;

  IconFontYamlConfigItem({this.css, this.dir, this.package});

  IconFontYamlConfigItem.fromJson(Map<String, dynamic> json) {
    css = json['css'];
    dir = json['dir'];
    package = json['package'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['css'] = this.css;
    data['dir'] = this.dir;
    data['package'] = this.package;
    return data;
  }
}
