import 'package:flutter/material.dart';
import 'package:meal_app/providers/language_provider.dart';
import 'package:meal_app/screens/tabs_screen.dart';
import 'package:meal_app/screens/themes_screen.dart';
import 'package:provider/provider.dart';

import '../screens/filters_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  Widget buildListTile(
      String title, IconData icon, VoidCallback tapHandler, BuildContext ctx) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(ctx).buttonColor,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(ctx).textTheme.bodyText1!.color,
          fontFamily: 'RobotoCondensed',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Drawer(
        elevation: 0,
        child: Column(
          children: <Widget>[
            Container(
              height: 120,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              alignment:
                  lan.isEn ? Alignment.centerLeft : Alignment.centerRight,
              color: Theme.of(context).accentColor,
              child: Text(
                lan.getTexts('drawer_name') as String,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            buildListTile(
                lan.getTexts('drawer_item1') as String, Icons.restaurant, () {
              Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
            }, context),
            buildListTile(
                lan.getTexts('drawer_item2') as String, Icons.settings, () {
              Navigator.of(context)
                  .pushReplacementNamed(FiltersScreen.routeName);
            }, context),
            buildListTile(
                lan.getTexts('drawer_item3') as String, Icons.color_lens, () {
              Navigator.of(context)
                  .pushReplacementNamed(ThemesScreen.routeName);
            }, context),
            const Divider(
              height: 10,
              color: Colors.black54,
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(top: 20, right: 22),
              child: Text(lan.getTexts('drawer_switch_title') as String,
                  style: Theme.of(context).textTheme.headline6),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: (lan.isEn ? 0 : 20),
                  left: lan.isEn ? 20 : 0,
                  bottom: 10,
                  top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    lan.getTexts('drawer_switch_item2') as String,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Switch(
                      value: lan.isEn,
                      onChanged: (newVal) {
                        Provider.of<LanguageProvider>(context, listen: false)
                            .changeLan(newVal);
                        Navigator.of(context).pop;
                      }),
                  Text(
                    lan.getTexts('drawer_switch_item1') as String,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.black54,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
