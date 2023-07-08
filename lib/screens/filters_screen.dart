import 'package:flutter/material.dart';
import 'package:meal_app/providers/meal_provider.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/main_drawer.dart';

class FiltersScreen extends StatelessWidget {
  static const routeName = '/filters';
  final bool fromOnBoarding;

  FiltersScreen({this.fromOnBoarding = false});

  Widget _buildSwitchListTile(
      String title,
      String description,
      bool currentValue,
      final ValueChanged<bool?> updateValue,
      BuildContext ctx) {
    return SwitchListTile(
      title: Text(title),
      value: currentValue,
      subtitle: Text(
        description,
      ),
      onChanged: updateValue,
      inactiveTrackColor:
          Provider.of<ThemeProvider>(ctx, listen: true).tm == ThemeMode.light
              ? null
              : Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, bool> currentFilters =
        Provider.of<MealProvider>(context, listen: true).filters;
    var lan = Provider.of<LanguageProvider>(context, listen: true);

    return Directionality(
        textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          drawer: fromOnBoarding ? null : const MainDrawer(),
          body: CustomScrollView(slivers: [
            SliverAppBar(
              pinned: false,
              title: fromOnBoarding
                  ? null
                  : Text(lan.getTexts('filters_appBar_title') as String),
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
                      lan.getTexts('filters_screen_title') as String,
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  _buildSwitchListTile(
                      lan.getTexts('Gluten-free') as String,
                      lan.getTexts('Gluten-free-sub') as String,
                      currentFilters['gluten']!, (newValue) {
                    currentFilters['gluten'] = newValue!;

                    Provider.of<MealProvider>(context, listen: false)
                        .setFilters();
                  }, context),
                  _buildSwitchListTile(
                      lan.getTexts('Lactose-free') as String,
                      lan.getTexts('Lactose-free_sub') as String,
                      currentFilters['lactose']!, (newValue) {
                    currentFilters['lactose'] = newValue!;

                    Provider.of<MealProvider>(context, listen: false)
                        .setFilters();
                  }, context),
                  _buildSwitchListTile(
                      lan.getTexts('Vegetarian') as String,
                      lan.getTexts('Vegetarian-sub') as String,
                      currentFilters['vegetarian']!, (newValue) {
                    currentFilters['vegetarian'] = newValue!;

                    Provider.of<MealProvider>(context, listen: false)
                        .setFilters();
                  }, context),
                  _buildSwitchListTile(
                      lan.getTexts('Vegan') as String,
                      lan.getTexts('Vegan-sub') as String,
                      currentFilters['vegan']!, (newValue) {
                    currentFilters['vegan'] = newValue!;

                    Provider.of<MealProvider>(context, listen: false)
                        .setFilters();
                  }, context),
                  SizedBox(height: fromOnBoarding ? 80 : 0)
                ],
              ),
            ),
          ]),
        ));
  }
}
