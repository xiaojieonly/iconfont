import 'package:args/args.dart';
import 'package:iconfont/iconfont.dart';

/// main
void main(List<String> args) async {
  final ArgParser argParser = ArgParser()
    ..addOption('css',
        abbr: 'c',
        defaultsTo: '',
        help:
            "font css的链接,例如(http://at.alicdn.com/t/font_1500681_sz0skwerbw.css)")
    ..addOption('dir', abbr: 'd', defaultsTo: '', help: "自动生成的assets文件夹名")
    ..addOption('in',
        abbr: 'i',
        defaultsTo: Constants.DEFAULT_READ_PATH,
        help: "iconfont文件所在目录")
    ..addOption('out',
        abbr: 'o', defaultsTo: Constants.DEFAULT_WRITE_PATH, help: "生成后文件存放目录")
    ..addOption('package', abbr: 'p', defaultsTo: '', help: "fontPackage")
    ..addOption('config',
        defaultsTo: Constants.PUBSPECYAML, help: "config file path")
    ..addFlag('help', abbr: 'h', negatable: false, help: "help");

  ArgResults argResults = argParser.parse(args);
  if (argResults['help']) {
    print(argParser.usage);
    return;
  }

  try {
    await IconFontBuilder.build(IconFontConfig(
      cssUrl: argResults['css'],
      dirName: argResults['dir'],
      readPath: argResults['in'],
      writePath: argResults['out'],
      fontPackage: argResults['package'],
    ));

    await IconFontBuilder.buildFromYamlConfig(argResults['config']);

    await IconFontBuilder.scanAndPubSave();
  } catch (e) {
    print(e.toString());
  }
}
