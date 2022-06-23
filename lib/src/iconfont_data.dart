class IconFontData {
  String? fontFamily;
  String? cssPrefixText;
  List<IconFontGlyph>? glyphs;
  String? tffPath;
  String? fontPackage;

  IconFontData({
    this.fontFamily,
    this.cssPrefixText,
    this.glyphs,
    this.tffPath,
    this.fontPackage,
  });

  factory IconFontData.parse(String data) {
    return IconFontData(
      fontFamily:
          RegExp(r'font-family: "(.+?)";').firstMatch(data)?.group(1) ?? "",
      cssPrefixText: "",
      glyphs: RegExp(r'\.(.+):before[\S\s]*?content: "\\(.+)";')
          .allMatches(data)
          .map((m) {
        return IconFontGlyph(
          fontClass: m.group(1) ?? "",
          iconId: '',
          name: '',
          unicode: m.group(2) ?? "",
          unicodeDecimal: '',
        );
      }).toList(),
      tffPath: RegExp(r"//at.alicdn.com/t/font.*\.ttf\?t=[0-9]{13}")
              .stringMatch(data) ??
          "",
    );
  }

  IconFontData.fromJson(Map<String, dynamic> json) {
    fontFamily = json['font_family'];
    cssPrefixText = json['css_prefix_text'];
    if (json['glyphs'] != null) {
      glyphs = <IconFontGlyph>[];
      json['glyphs'].forEach((v) {
        glyphs!.add(new IconFontGlyph.fromJson(v));
      });
    }
    tffPath = json['tff_path'];
    fontPackage = json['font_package'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['font_family'] = this.fontFamily;
    data['css_prefix_text'] = this.cssPrefixText;
    if (this.glyphs != null) {
      data['glyphs'] = this.glyphs!.map((v) => v.toJson()).toList();
    }
    data['tff_path'] = this.tffPath;
    data['font_package'] = this.fontPackage;
    return data;
  }
}

class IconFontGlyph {
  String? iconId;
  String? fontClass;
  String? unicode;
  String? unicodeDecimal;
  String? name;

  IconFontGlyph(
      {this.iconId,
      this.fontClass,
      this.unicode,
      this.unicodeDecimal,
      this.name});

  IconFontGlyph.fromJson(Map<String, dynamic> json) {
    iconId = json['icon_id'];
    fontClass = json['font_class'];
    unicode = json['unicode'];
    unicodeDecimal = json['unicode_decimal'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon_id'] = this.iconId;
    data['font_class'] = this.fontClass;
    data['unicode'] = this.unicode;
    data['unicode_decimal'] = this.unicodeDecimal;
    data['name'] = this.name;
    return data;
  }
}
