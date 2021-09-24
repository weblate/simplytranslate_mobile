import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/main_localizations.dart';
import '/data.dart';

// var renderBox;
// var translateButtonWidgetSize;

class GoogleTranslateButton extends StatelessWidget {
  final setStateParent;
  final Future<String> Function(String) translateParent;

  const GoogleTranslateButton({
    Key? key,
    required this.setStateParent,
    required this.translateParent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            alignment: Alignment.center,
            width: 100,
            // height: 50,
            child: LinearProgressIndicator())
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2)),
            ),
            onPressed: googleTranslationInputController.text == ''
                ? null
                : googleTranslationInputController.text.length <= 5000
                    ? () async {
                        FocusScope.of(context).unfocus();
                        isTranslationCanceled = false;
                        setStateParent(() => loading = true);
                        final translatedText =
                            await translateParent(translationInput);
                        if (!isTranslationCanceled) {
                          setStateParent(() {
                            googleTranslationOutput = translatedText;
                            loading = false;
                          });
                        }
                      }
                    : null,
            child: Text(
              AppLocalizations.of(context)!.translate,
              style: TextStyle(
                  fontSize: 18,
                  color: theme == Brightness.dark ? null : Colors.white),
            ),
          );
  }
}
