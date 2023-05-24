import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simplytranslate_mobile/generated/l10n.dart';
import 'package:path_provider/path_provider.dart';

// const lightGreenColor = const Color(0xff62d195);
const greyColor = const Color(0xff131618);
const secondgreyColor = const Color(0xff212529);
const greenColor = const Color(0xff3fb274);
const lightThemeGreyColor = const Color(0xffa9a9a9);
const darkThemedisabledColor = const Color(0xff6e7071);
const lightThemedisabledColor = const Color(0xff9b9b9b);

late BuildContext contextOverlordData;
late void Function(void Function() fn) setStateOverlord;

var themeRadio = AppTheme.system;

var focus = FocusNode();

String fromLangVal = 'auto';
String toLangVal = '';
String shareLangVal = '';

String instance = 'random';

Map googleOutput = {};

extension CapitalizeString on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

String customInstance = '';

late Locale appLocale;

enum AppTheme { dark, light, system }

var themeValue = '';

Future<File> byte2File(Uint8List byte) async {
  final tempDir = await getTemporaryDirectory();
  final random = Random().nextInt(10000000);
  final file = await new File('${tempDir.path}/$random.jpg').create();
  file.writeAsBytesSync(byte);
  return file;
}

Widget line = Container(
  margin: const EdgeInsets.only(top: 10, bottom: 5),
  height: 1.5,
  color: theme == Brightness.dark ? Colors.white : lightThemeGreyColor,
);

late File img;

Brightness theme = SchedulerBinding.instance.window.platformBrightness;

enum InstanceValidation { False, True, NotChecked }

bool isClipboardEmpty = true;

late Map<String, String> toSelLangMap;
late Map<String, String> fromSelLangMap;

bool loading = false;
bool isTranslationCanceled = false;

final customUrlCtrl = TextEditingController();
final googleInCtrl = TextEditingController();

final session = GetStorage();

late final PackageInfo packageInfo;

Function() fromCancel = () {};
Function() toCancel = () {};

late Function(String) changeFromTxt;
late Function(String) changeToTxt;

String newText = "";

Future<InstanceValidation> checkInstance(String urlValue) async {
  var url;
  try {
    url = Uri.parse(urlValue);
  } catch (err) {
    print(err);
    return InstanceValidation.False;
  }
  try {
    final response = await http
        .get(Uri.parse('$url/api/translate?from=en&to=es&text=hello'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      if (data['translated-text'].toLowerCase() == 'hola')
        return InstanceValidation.True;
      else
        return InstanceValidation.False;
    } else
      return InstanceValidation.False;
  } catch (err) {
    print(err);
    return InstanceValidation.False;
  }
}

Future<void> getSharedText() async {
  const methodChannel = MethodChannel('com.simplytranslate_mobile/translate');
  try {
    final answer = await methodChannel.invokeMethod('getText');
    if (answer != '') {
      final _translationInput = answer.toString();

      setStateOverlord(() {
        googleInCtrl.text = _translationInput;
        loading = true;
      });

      final translatedText = await translate(
        input: _translationInput,
        fromLang: 'auto',
        toLang: shareLangVal,
        context: contextOverlordData,
      );
      setStateOverlord(() {
        googleOutput = translatedText;
        loading = false;
      });
    }
  } catch (_) {
    setStateOverlord(() => loading = false);
  }
}

bool isSnackBarVisible = false;

enum TrainedDataState { notDownloaded, Downloading, Downloaded }

Map<String, String> selectLanguagesMapGetter(BuildContext context) {
  Map<String, String> mapOne = {
    "af": L10n.of(context).afrikaans,
    "sq": L10n.of(context).albanian,
    "am": L10n.of(context).amharic,
    "ar": L10n.of(context).arabic,
    "hy": L10n.of(context).armenian,
    "az": L10n.of(context).azerbaijani,
    "eu": L10n.of(context).basque,
    "be": L10n.of(context).belarusian,
    "bn": L10n.of(context).bengali,
    "bs": L10n.of(context).bosnian,
    "bg": L10n.of(context).bulgarian,
    "ca": L10n.of(context).catalan,
    "ceb": L10n.of(context).cebuano,
    "ny": L10n.of(context).chichewa,
    "zh-CN": L10n.of(context).chinese,
    "co": L10n.of(context).corsican,
    "hr": L10n.of(context).croatian,
    "cs": L10n.of(context).czech,
    "da": L10n.of(context).danish,
    "nl": L10n.of(context).dutch,
    "en": L10n.of(context).english,
    "eo": L10n.of(context).esperanto,
    "et": L10n.of(context).estonian,
    "tl": L10n.of(context).filipino,
    "fi": L10n.of(context).finnish,
    "fr": L10n.of(context).french,
    "fy": L10n.of(context).frisian,
    "gl": L10n.of(context).galician,
    "ka": L10n.of(context).georgian,
    "de": L10n.of(context).german,
    "el": L10n.of(context).greek,
    "gu": L10n.of(context).gujarati,
    "ht": L10n.of(context).haitian_creole,
    "ha": L10n.of(context).hausa,
    "haw": L10n.of(context).hawaiian,
    "iw": L10n.of(context).hebrew,
    "hi": L10n.of(context).hindi,
    "hmn": L10n.of(context).hmong,
    "hu": L10n.of(context).hungarian,
    "is": L10n.of(context).icelandic,
    "ig": L10n.of(context).igbo,
    "id": L10n.of(context).indonesian,
    "ga": L10n.of(context).irish,
    "it": L10n.of(context).italian,
    "ja": L10n.of(context).japanese,
    "jw": L10n.of(context).javanese,
    "kn": L10n.of(context).kannada,
    "kk": L10n.of(context).kazakh,
    "km": L10n.of(context).khmer,
    "rw": L10n.of(context).kinyarwanda,
    "ko": L10n.of(context).korean,
    "ku": L10n.of(context).kurdish_kurmanji,
    "ky": L10n.of(context).kyrgyz,
    "lo": L10n.of(context).lao,
    "la": L10n.of(context).latin,
    "lv": L10n.of(context).latvian,
    "lt": L10n.of(context).lithuanian,
    "lb": L10n.of(context).luxembourgish,
    "mk": L10n.of(context).macedonian,
    "mg": L10n.of(context).malagasy,
    "ms": L10n.of(context).malay,
    "ml": L10n.of(context).malayalam,
    "mt": L10n.of(context).maltese,
    "mi": L10n.of(context).maori,
    "mr": L10n.of(context).marathi,
    "mn": L10n.of(context).mongolian,
    "my": L10n.of(context).myanmar_burmese,
    "ne": L10n.of(context).nepali,
    "no": L10n.of(context).norwegian,
    "or": L10n.of(context).odia_oriya,
    "ps": L10n.of(context).pashto,
    "fa": L10n.of(context).persian,
    "pl": L10n.of(context).polish,
    "pt": L10n.of(context).portuguese,
    "pa": L10n.of(context).punjabi,
    "ro": L10n.of(context).romanian,
    "ru": L10n.of(context).russian,
    "sm": L10n.of(context).samoan,
    "gd": L10n.of(context).scots_gaelic,
    "sr": L10n.of(context).serbian,
    "st": L10n.of(context).sesotho,
    "sn": L10n.of(context).shona,
    "sd": L10n.of(context).sindhi,
    "si": L10n.of(context).sinhala,
    "sk": L10n.of(context).slovak,
    "sl": L10n.of(context).slovenian,
    "so": L10n.of(context).somali,
    "es": L10n.of(context).spanish,
    "su": L10n.of(context).sundanese,
    "sw": L10n.of(context).swahili,
    "sv": L10n.of(context).swedish,
    "tg": L10n.of(context).tajik,
    "ta": L10n.of(context).tamil,
    "tt": L10n.of(context).tatar,
    "te": L10n.of(context).telugu,
    "th": L10n.of(context).thai,
    "tr": L10n.of(context).turkish,
    "tk": L10n.of(context).turkmen,
    "uk": L10n.of(context).ukrainian,
    "ur": L10n.of(context).urdu,
    "ug": L10n.of(context).uyghur,
    "uz": L10n.of(context).uzbek,
    "vi": L10n.of(context).vietnamese,
    "cy": L10n.of(context).welsh,
    "xh": L10n.of(context).xhosa,
    "yi": L10n.of(context).yiddish,
    "yo": L10n.of(context).yoruba,
    "zu": L10n.of(context).zulu,
  };

  Map<String, String> mapTwo = {};

  // ignore: non_constant_identifier_names
  List<String> Valuelist = [];

  for (var i in mapOne.values) Valuelist.add(i);
  Valuelist.sort();

  for (String i in Valuelist)
    for (var x in mapOne.keys) if (mapOne[x] == i) mapTwo[x] = i;

  return mapTwo;
}

BuildContext? translateContext;

showInstanceError(context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(L10n.of(context).something_went_wrong),
      content: Text(L10n.of(context).check_instance),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(L10n.of(context).ok),
        )
      ],
    ),
  );
}

showInstanceTtsError(context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(L10n.of(context).something_went_wrong),
      content: Text(L10n.of(context).check_instnace_tts),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(L10n.of(context).ok),
        )
      ],
    ),
  );
}

showInternetError(context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(L10n.of(context).no_internet),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(L10n.of(context).ok),
        )
      ],
    ),
  );
}

Future<Map> translate({
  required String input,
  required String fromLang,
  required String toLang,
  required BuildContext context,
}) async {
  final url;
  if (instance == 'custom')
    url = Uri.parse('$customInstance/api/translate');
  else if (instance == 'random') {
    final randomInstance = instances[Random().nextInt(instances.length)];
    url = Uri.parse('$randomInstance/api/translate');
  } else
    url = Uri.parse('$instance/api/translate');

  try {
    final response = await http.post(
      url,
      body: {
        'from': fromLang,
        'to': toLang,
        'text': input,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      await showInstanceError(context);
      return {};
    }
  } catch (err) {
    print('something is wrong buddy: $err');
    try {
      final result = await InternetAddress.lookup('exmaple.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await showInstanceError(context);
        throw ('Instnace not valid');
      }
    } on SocketException catch (_) {
      await showInternetError(context);
      throw ('No internet');
    }
    return {};
  }
}

bool isTtsInCanceled = false;
bool ttsInputloading = false;

bool ttsOutloading = false;
bool isTtsOutputCanceled = false;

bool ttsMaximizedOutputloading = false;
bool isMaximizedTtsOutputCanceled = false;

bool isFirst = true;

late double inTextFieldHeight;
late double outTextFieldHeight;

var instances = [
  "https://simplytranslate.org",
  "https://st.alefvanoon.xyz",
  "https://translate.josias.dev",
  "https://translate.namazso.eu",
  "https://translate.riverside.rocks",
  "https://st.manerakai.com",
  "https://translate.bus-hit.me",
  "https://simplytranslate.pussthecat.org",
  "https://translate.northboot.xyz",
  "https://translate.tiekoetter.com",
  "https://simplytranslate.esmailelbob.xyz",
  "https://translate.syncpundit.com",
];

Map<String, bool> inList = {
  "Remove": true,
  "Copy": false,
  "Camera": true,
  "Paste": true,
  "Text-To-Speech": true,
  "Counter": true,
};
Map<String, bool> outList = {
  "Copy": true,
  "Maximize": true,
  "Text-To-Speech": true,
};

Map<String, String> getInListTranslation(BuildContext context) => {
      "Remove": L10n.of(context).remove,
      "Copy": L10n.of(context).copy,
      "Camera": L10n.of(context).camera,
      "Paste": L10n.of(context).paste,
      "Text-To-Speech": L10n.of(context).text_to_speech,
      "Counter": L10n.of(context).counter,
    };

Map<String, String> getOutListTranslation(BuildContext context) => {
      "Copy": L10n.of(context).copy,
      "Maximize": L10n.of(context).maximize,
      "Text-To-Speech": L10n.of(context).text_to_speech,
    };
