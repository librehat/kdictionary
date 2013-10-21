## KDictionary
#### Yet Another Simple English-Chinese Dictionary Plasmoid

Check this widget on [kde-apps.org](http://kde-apps.org/content/show.php?content=161349), please vote 5 stars if you think it make your life more convenient.

### Installation

* Download plasmoid from [releases](https://github.com/librehat/kdictionary/releases)
* Run `plasmapkg -i kdictionary.plasmoid` to install it
* Run `kbuildsycoca4` to refresh desktop cache
* Have fun

### Advanced Usage

KDictionary invokes [QQDict](http://dict.qq.com) API at default for some reasons. But you can choose other providers, instructions are shown below.

#### YOUDAO

1. Apply for a [YOUDAO](http://fanyi.youdao.com/openapi?path=data-mode) API to use YOUDAO Dictionary
2. Fill in your API key and name in KDictionary Advanced Setting
3. Change Dictionary Provider to YOUDAO

#### Baidu (TODO)

1. Apply for a [Baidu](http://developer.baidu.com/wiki/index.php?title=%E5%B8%AE%E5%8A%A9%E6%96%87%E6%A1%A3%E9%A6%96%E9%A1%B5/%E7%99%BE%E5%BA%A6%E7%BF%BB%E8%AF%91/%E7%BF%BB%E8%AF%91API) API to use Baidu Translation service
2. Fill in your API key in KDictionary Advanced Setting
3. Change Dictionary Provider to Baidu

#### iCiBa (TODO)

1. Apply for a [iCiBa](http://open.iciba.com/?c=api) API to use Kingsoft PowerWord Dictionary
2. Fill in your API key in KDictionary Advanced Setting
3. Change Dictionary Provider to iCiBa

### TO-DO List

- [ ] Add sentence examples for QQdict API
- [x] Add YOUDAO API
- [ ] Add iciba API
- [ ] Add Baidu Translate API
- [ ] i18n
- [ ] Offline dictionary
- [x] Configuration XML File
- [x] Configuration UI