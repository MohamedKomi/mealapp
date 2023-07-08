import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:meal_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../widgets/main_drawer.dart';

class ThemesScreen extends StatelessWidget {
  static const routeName = '/themes';
  final bool fromOnBoarding;

  ThemesScreen({this.fromOnBoarding = false});

  Widget buildRadioListTile(
      ThemeMode themeVal, String txt, IconData? icon, BuildContext ctx) {
    return RadioListTile(
      secondary: Icon(
        icon,
        color: Theme.of(ctx).buttonColor,
      ),
      value: themeVal,
      groupValue: Provider.of<ThemeProvider>(ctx, listen: true).tm,
      onChanged: (newThemeVal) => Provider.of<ThemeProvider>(ctx, listen: false)
          .themeModeChange(newThemeVal),
      title: Text(txt),
    );
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);

    return Directionality(
        textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          drawer: fromOnBoarding ? null : const MainDrawer(),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: false,
                title: fromOnBoarding
                    ? null
                    : Text(lan.getTexts('theme_appBar_title') as String),
                backgroundColor: fromOnBoarding
                    ? Theme.of(context).canvasColor
                    : Theme.of(context).primaryColor,
                elevation: fromOnBoarding ? 0 : 5,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        lan.getTexts('theme_screen_title') as String,
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        lan.getTexts('theme_mode_title') as String,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    buildRadioListTile(
                        ThemeMode.system,
                        lan.getTexts('System_default_theme') as String,
                        null,
                        context),
                    buildRadioListTile(
                        ThemeMode.light,
                        lan.getTexts('light_theme') as String,
                        Icons.wb_sunny_outlined,
                        context),
                    buildRadioListTile(
                        ThemeMode.dark,
                        lan.getTexts('dark_theme') as String,
                        Icons.nights_stay_outlined,
                        context),
                    buildListTile(context, 'primary'),
                    buildListTile(context, 'accent'),
                    SizedBox(
                      height: fromOnBoarding ? 80 : 0,
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  ListTile buildListTile(BuildContext context, txt) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);

    var primaryColor =
        Provider.of<ThemeProvider>(context, listen: true).primaryColor;
    var accentColor =
        Provider.of<ThemeProvider>(context, listen: true).accentColor;
    return ListTile(
      title: Text(
        txt == "primary"
            ? lan.getTexts('primary') as String
            : lan.getTexts('accent') as String,
        style: Theme.of(context).textTheme.headline6,
      ),
      trailing: CircleAvatar(
        backgroundColor: txt == 'primary' ? primaryColor : accentColor,
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext ctx) {
              return AlertDialog(
                elevation: 4,
                titlePadding: const EdgeInsets.all(0),
                contentPadding: const EdgeInsets.all(0),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: txt == 'primary'
                        ? Provider.of<ThemeProvider>(context, listen: true)
                            .primaryColor
                        : Provider.of<ThemeProvider>(context, listen: true)
                            .accentColor,
                    onColorChanged: (newColor) =>
                        Provider.of<ThemeProvider>(context, listen: false)
                            .onChange(newColor, txt == 'primary' ? 1 : 2),
                    colorPickerWidth: 300,
                    pickerAreaHeightPercent: .7,
                    enableAlpha: false,
                    displayThumbColor: true,
                    showLabel: false,
                  ),
                ),
              );
            });
      },
    );
  }
}
