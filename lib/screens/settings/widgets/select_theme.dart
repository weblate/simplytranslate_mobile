import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/main_localizations.dart';
import 'package:simplytranslate_mobile/screens/settings/widgets/settings_button.dart';
import '../../../data.dart';

class SelectTheme extends StatelessWidget {
  const SelectTheme({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _darkFunc(setState) {
      setState(() => themeRadio = AppTheme.dark);
      setStateOverlord(() {
        session.write('theme', 'dark');
        themeValue = AppLocalizations.of(context)!.dark;
        theme = Brightness.dark;
      });
      Navigator.of(context).pop();
    }

    _lightFunc(setState) {
      setState(() => themeRadio = AppTheme.light);
      setStateOverlord(() {
        session.write('theme', 'light');
        themeValue = AppLocalizations.of(context)!.light;
        theme = Brightness.light;
      });
      Navigator.of(context).pop();
    }

    _systemFunc(setState) {
      setState(() => themeRadio = AppTheme.system);
      setStateOverlord(() {
        session.write('theme', 'system');
        themeValue = AppLocalizations.of(context)!.follow_system;
        theme = MediaQuery.of(context).platformBrightness;
      });
      Navigator.of(context).pop();
    }

    return SettingsButton(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              contentTextStyle: TextStyle(
                  color: theme == Brightness.dark ? Colors.white : Colors.black,
                  fontSize: 20),
              contentPadding: EdgeInsets.all(5),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                      onTap: () => _darkFunc(setState),
                      child: Row(
                        children: [
                          Radio<AppTheme>(
                            value: AppTheme.dark,
                            groupValue: themeRadio,
                            onChanged: (_) => _darkFunc(setState),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Text(AppLocalizations.of(context)!.dark),
                            ),
                          ),
                        ],
                      )),
                  InkWell(
                    onTap: () => _lightFunc(setState),
                    child: Row(
                      children: [
                        Radio<AppTheme>(
                          value: AppTheme.light,
                          groupValue: themeRadio,
                          onChanged: (_) => _lightFunc(setState),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: Text(AppLocalizations.of(context)!.light),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                      onTap: () => _systemFunc(setState),
                      child: Row(
                        children: [
                          Radio<AppTheme>(
                            value: AppTheme.system,
                            groupValue: themeRadio,
                            onChanged: (_) => _systemFunc(setState),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Text(
                                  AppLocalizations.of(context)!.follow_system),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context)!.cancel),
                )
              ],
            ),
          ),
        );
      },
      icon: theme == Brightness.dark ? Icons.dark_mode : Icons.light_mode,
      iconColor: Colors.yellow[800]!,
      title: AppLocalizations.of(context)!.theme,
      content: themeValue,
    );
  }
}
