## KDictionary
#### Yet Another Simple Dictionary/Translator Plasmoid

Check this widget on [kde-apps.org](http://kde-apps.org/content/show.php?content=161349), please vote 5 stars if you think it make your life more convenient.

### Installation

1. Download KDictionary plasmoid from [releases](https://github.com/librehat/kdictionary/releases)
2. Run `plasmapkg -i kdictionary-<ver>.plasmoid` to install it
3. Run `kbuildsycoca4` to refresh desktop cache
4. Have fun

##### NOTICE

- If you've installed an early version of KDictionary, you need to run `plasmapkg -u kdictionary-<ver>.plasmoid` instead to **upgrade** KDictionary.
- Any upgrade will lose previous settings data.

### Advanced Usage

KDictionary invokes [QQDict](http://dict.qq.com) API by default for some reasons. But you can choose other providers, instructions are shown below.

#### YOUDAO

1. Apply for a [YOUDAO](http://fanyi.youdao.com/openapi?path=data-mode) API to use YOUDAO Dictionary
2. Fill in your API key and name in KDictionary Advanced Setting
3. Change Dictionary Provider to YOUDAO

#### Baidu

1. Apply for a [Baidu](http://developer.baidu.com/wiki/index.php?title=%E5%B8%AE%E5%8A%A9%E6%96%87%E6%A1%A3%E9%A6%96%E9%A1%B5/%E7%99%BE%E5%BA%A6%E7%BF%BB%E8%AF%91/%E7%BF%BB%E8%AF%91API) API to use Baidu Translation service
2. Fill in your API key in KDictionary Advanced Setting
3. Change Dictionary Provider to Baidu

#### iCiBa

_Note: iCiBa API key is provided by default, though you could still use your own API key._

1. Apply for a [iCiBa](http://open.iciba.com/?c=api) API to use Kingsoft PowerWord Dictionary. You'll get API key immediately in your E-mail inbox, if not, check your spam box.
2. Fill in your API key in KDictionary Advanced Setting
3. Change Dictionary Provider to iCiBa

#### More Providers?

Check [Wiki Pages](https://github.com/librehat/kdictionary/wiki). You could make KDictionary more powerful.