## KDictionary
#### Simple Dictionary/Translator Applet/PopUpApplet for Plasma Desktop

Check this widget on [kde-apps.org](http://kde-apps.org/content/show.php?content=161349), please vote up if you like it.

### Installation

**Require KDE >= 4.11** (KDE 4.10 may works but I didn't test it)

1. Download KDictionary plasmoid from [KDE-Apps](http://kde-apps.org/content/show.php?content=161349)
2. Run `plasmapkg -i kdictionary-<ver>.plasmoid` to install it
3. Run `kbuildsycoca4` to refresh desktop cache
4. Have fun

##### NOTICE

- If you've installed an early version of KDictionary, you need to run `plasmapkg -u kdictionary-<ver>.plasmoid` instead to **upgrade** KDictionary.

#### Note

All Dictionary API keys are built-in, but please don't abuse it because the query times are limited. Take Merriam-Webster's as an example, it cannot exceed **1000** queries per day.

#### More Providers?

Check [Wiki Pages](https://github.com/librehat/kdictionary/wiki). You could make KDictionary more powerful.