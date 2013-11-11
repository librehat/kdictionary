## KDictionary
#### Yet Another Simple Dictionary/Translator Plasmoid

Check this widget on [kde-apps.org](http://kde-apps.org/content/show.php?content=161349), please vote 5 stars if you think it make your life more convenient.

### Installation

**Require KDE >= 4.11** (KDE 4.10 may works but I didn't test it)

1. Download KDictionary plasmoid from [releases](https://github.com/librehat/kdictionary/releases)
2. Run `plasmapkg -i kdictionary-<ver>.plasmoid` to install it
3. Run `kbuildsycoca4` to refresh desktop cache
4. Have fun

##### NOTICE

- If you've installed an early version of KDictionary, you need to run `plasmapkg -u kdictionary-<ver>.plasmoid` instead to **upgrade** KDictionary.

### Advanced Usage

KDictionary invokes [QQDict](http://dict.qq.com) API by default for some reasons. But you can choose other providers, instructions are shown below.

##### Note

All Dictionary API keys are built-in, but you're encouraged to use your own API keys because there're limitations. Take Merriam-Webster's as an example, it cannot exceed **1000** queries per day.

#### YOUDAO

1. Apply for a [YOUDAO](http://fanyi.youdao.com/openapi?path=data-mode) API to use YOUDAO Dictionary
2. Fill in your API key and name in KDictionary Advanced Setting
3. Change Dictionary Provider to YOUDAO

#### Baidu

_Tip: Baidu Translation support English, Japanese, Spanish, Thai and Arabic._

1. Apply for a [Baidu](http://developer.baidu.com/wiki/index.php?title=%E5%B8%AE%E5%8A%A9%E6%96%87%E6%A1%A3%E9%A6%96%E9%A1%B5/%E7%99%BE%E5%BA%A6%E7%BF%BB%E8%AF%91/%E7%BF%BB%E8%AF%91API) API to use Baidu Translation service
2. Fill in your API key in KDictionary Advanced Setting
3. Change Dictionary Provider to Baidu

#### iCiBa

1. Apply for a [iCiBa](http://open.iciba.com/?c=api) API to use Kingsoft PowerWord Dictionary. You'll get API key immediately in your E-mail inbox, if not, check your spam box
2. Fill in your API key in KDictionary Advanced Setting
3. Change Dictionary Provider to iCiBa

#### Merriam-Webster's Collegiate® Dictionary

1. Apply for a [Merriam-Webster's Dictionary](http://www.dictionaryapi.com) API to use Merriam-Webster's **Collegiate®** Dictionary. You'll get API key once you finished your E-mail verification
2. Fill in your API key in KDictionary Advanced Setting
3. Change Dictionary Provider to Merriam-Webster's Collegiate® Dictionary

_Notice: Merriam-Webster provide different kinds of API keys. What KDictionary supports is Merriam-Webster's Collegiate® Dictionary and Spanish Dictionary. Please don't make mistakes._

#### Merriam-Webster's Spanish Dictionary

1. Apply for a [Merriam-Webster's Dictionary](http://www.dictionaryapi.com) API to use Merriam-Webster's **Spanish** Dictionary. You'll get API key once you finished your E-mail verification
2. Fill in your API key in KDictionary Advanced Setting
3. Change Dictionary Provider to Merriam-Webster's Spanish Dictionary

#### More Providers?

Check [Wiki Pages](https://github.com/librehat/kdictionary/wiki). You could make KDictionary more powerful.