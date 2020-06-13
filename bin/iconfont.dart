import 'package:iconfont/iconfont.dart';
import 'package:args/args.dart';

/// main
void main(List<String> args) {
  final ArgParser argParser = ArgParser()
    ..addOption('css',
        abbr: 'c',
        defaultsTo: '',
        help:
            "font css的链接，例如(http://at.alicdn.com/t/font_1500681_sz0skwerbw.css)")
    ..addOption('dir', abbr: 'd', defaultsTo: '', help: "自动生成的assets文件夹名")
    ..addOption('in',
        abbr: 'i', defaultsTo: 'assets/fonts/', help: "iconfont文件所在目录")
    ..addOption('out', abbr: 'o', defaultsTo: 'lib/icons/', help: "生成后文件存放目录")
    ..addFlag('help', abbr: 'h', negatable: false, help: "help")
    ..addFlag('skip',
        abbr: 's',
        negatable: false,
        help: "覆盖pubspec.yaml文件，将会丢失pubspec.yaml中的注释");

  ArgResults argResults = argParser.parse(args);
  if (argResults['help']) {
    print(argParser.usage);
    return;
  }

  IconfontConfig.readPath = argResults['in'];
  IconfontConfig.writePath = argResults['out'];
  IconfontConfig.saveYamlPath =
      argResults['skip'] ? "pubspec.yaml" : "pubspec.yaml.g";

  IconfontConfig.dirName = argResults['dir'];
  IconfontConfig.cssUrl = argResults['css'];

  WingsIconfont();
}
