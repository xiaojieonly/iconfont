# iconfont [![Pub](https://img.shields.io/pub/v/iconfont.svg?style=flat-square)](https://pub.dartlang.org/packages/iconfont)

只需一行命令，即可快速生成[https://www.iconfont.cn/](https://www.iconfont.cn/)的Icon文件。

## 特点

1. 支持多个 `iconfont` 项目。
2. 可自动在 `pubspec.yaml` 中注册字体
3. 支持 `font class` 链接生成文件


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
-c, --css     font css的链接，例如(http://at.alicdn.com/t/font_1500681_sz0skwerbw.css)
              (defaults to "")
-d, --dir     自动生成的assets文件夹名
              (defaults to "")
-i, --in      iconfont文件所在目录
              (defaults to "assets/fonts/")
-o, --out     生成后文件存放目录
              (defaults to "lib/icons/")
-h, --help    help
-s, --skip    覆盖pubspec.yaml文件，将会丢失pubspec.yaml中的注释

```

## 常见问题

1. [iconfont command not found](https://dart.dev/tools/pub/cmd/pub-global#running-a-script)

## 例子

- [example](example)
- [https://0hy3e2.coding-pages.com](https://0hy3e2.coding-pages.com)

### 场景1

> 通过 `Font css` 链接生成 `Icon` 文件

`iconfont -c http://at.alicdn.com/t/font_1500681_sz0skwerbw.css -d my_icons -s`


### 场景2

> 下载 `.zip` 文件，手动创建文件夹，将 `iconfont.json` 和 `iconfont.ttf` 文件放入新创建的文件夹中。

`iconfont -s`


## image

![](img/2.png)