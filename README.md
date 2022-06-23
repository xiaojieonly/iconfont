# iconfont [![Pub](https://img.shields.io/pub/v/iconfont.svg?style=flat-square)](https://pub.dartlang.org/packages/iconfont)

只需一行命令，即可快速生成[https://www.iconfont.cn/](https://www.iconfont.cn/)的Icon文件。

## 特点

1. 支持多个 `iconfont` 项目。
2. 自动识别 `family`
3. 可自动在 `pubspec.yaml` 中注册字体
4. 支持 `font class` 链接生成文件

## 运行

### 方式1

#### 安装

`flutter pub global activate iconfont` 或者 `pub global activate iconfont`

#### 使用

`iconfont`

### 方式2

#### 安装

在 `pubspec.yaml` 中添加

```yaml
dev_dependencies:
  iconfont: #latest version
```

#### 使用

`flutter packages pub run iconfont`

## 参数

```text
-c, --css        font css的链接,例如(http://at.alicdn.com/t/font_1500681_sz0skwerbw.css)
                 (defaults to "")
-d, --dir        自动生成的assets文件夹名
                 (defaults to "")
-i, --in         iconfont文件所在目录
                 (defaults to "assets/fonts/")
-o, --out        生成后文件存放目录
                 (defaults to "lib/icons/")
-p, --package    fontPackage
                 (defaults to "")
    --config     config file path
                 (defaults to "pubspec.yaml")
-h, --help       help

```

## 常见问题

1. [iconfont command not found](https://dart.dev/tools/pub/cmd/pub-global#running-a-script)

## 例子

- [example](example)
- [https://0hy3e2.coding-pages.com](https://0hy3e2.coding-pages.com)

### 场景1

> 通过 `Font css` 链接生成 `Icon` 文件

`iconfont -c http://at.alicdn.com/t/font_1500681_sz0skwerbw.css -d my_icons`

### 场景2

> 下载 `.zip` 文件，手动创建文件夹，将 `iconfont.json` 和 `iconfont.ttf` 文件放入新创建的文件夹中。

`iconfont`

### 场景3

#### 使用配置文件 `pubspec.yaml`
```yaml
# pubspec.yaml
iconfont:
  - icons: 
    - css: //at.alicdn.com/t/font_1500681_sz0skwerbw.css
      dir: test_icons
    in: assets/fonts2
    out: lib/icons/

  - icons: 
    - css: //at.alicdn.com/t/font_1500681_sz0skwerbw.css
      dir: my_icons

  - icons:
    - css: //at.alicdn.com/t/font_1932408_c19dd499jfh.css
      dir: my_icons2
```

运行 `iconfont`

#### 新建配置文件 `iconfont.yaml`

```yaml
# iconfont.yaml
- icons: 
    - css: //at.alicdn.com/t/font_1500681_sz0skwerbw.css
      dir: my_icons
      package: myPackage
  in: assets/fonts0/
  out: lib/xxicon

- icons: 
    - css: //at.alicdn.com/t/font_1500681_sz0skwerbw.css
      dir: test_icons
  in: assets/fonts1/
  out: lib/xxicon

- icons: 
    - css: //at.alicdn.com/t/font_1500681_sz0skwerbw.css
      dir: test_icons
  in: assers/fonts2
  out: lib/icons/

- icons: 
    - css: //at.alicdn.com/t/font_1500681_sz0skwerbw.css
      dir: my_icons
```
运行 `iconfont --config iconfont.yaml`