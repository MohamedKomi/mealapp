
import 'package:flutter/material.dart';
import 'package:meal_app/providers/meal_provider.dart';
import 'package:provider/provider.dart';

import '../dummy_data.dart';
import '../providers/language_provider.dart';

class MealDetailScreen extends StatefulWidget {
  static const routeName = '/meal-detail';

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.subtitle1,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildContainer(Widget child) {
    bool isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var dw = MediaQuery.of(context).size.width;
    var dh = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(10),
      height: isLandScape ? dh * .5 : dh * .25,
      width: isLandScape ? (dw * 0.5 - 30) : dw,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);

    final mealId = ModalRoute.of(context)!.settings.arguments as String;
    final selectedMeal = DUMMY_MEALS.firstWhere((meal) => meal.id == mealId);
    bool isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    List<String> ingredientsLi = lan.getTexts('steps-$mealId') as List<String>;
    var liIngredients = ListView.builder(
      padding: const EdgeInsets.all(0),

      itemBuilder: (ctx, index) => Card(
        color: Theme.of(context).accentColor,
        child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: Text(
              ingredientsLi[index],
              style: const TextStyle(color: Colors.black),
            )),
      ),
      itemCount: ingredientsLi.length,
    );
    List<String> stepsLi = lan.getTexts('ingredients-$mealId') as List<String>;

    var liSteps = ListView.builder(
      padding: const EdgeInsets.all(0),
      itemBuilder: (ctx, index) => Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text('# ${(index + 1)}'),
            ),
            title: Text(
              stepsLi[index],
              style: const TextStyle(color: Colors.black),
            ),
          ),
          const Divider()
        ],
      ),
      itemCount: stepsLi.length,
    );

    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(

        body: CustomScrollView(
          slivers: [

            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  title:Text(lan.getTexts('meal-$mealId') as String),
                background: Hero(
                  tag: mealId,
                  child: InteractiveViewer(
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        selectedMeal.imageUrl,
                      ),
                      placeholder: const AssetImage('assets/images/a2.png'),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([

                if (isLandScape)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          buildSectionTitle(
                              context, lan.getTexts('Ingredients') as String),
                          buildContainer(liIngredients),
                        ],
                      ),
                      Column(
                        children: [
                          buildSectionTitle(
                              context, lan.getTexts('Steps') as String),
                          buildContainer(liSteps),
                        ],
                      ),
                    ],
                  ),
                if (!isLandScape)
                  buildSectionTitle(
                      context, lan.getTexts('Ingredients') as String),
                if (!isLandScape) buildContainer(liIngredients),
                if (!isLandScape)
                  buildSectionTitle(context, lan.getTexts('Steps') as String),
                if (!isLandScape) buildContainer(liSteps),
              ]),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Provider.of<MealProvider>(context, listen: true).isFavorite(mealId)
                ? Icons.star
                : Icons.star_border,
          ),
          onPressed: () => Provider.of<MealProvider>(context, listen: false)
              .toggleFavorite(mealId),
        ),
      ),
    );
  }
}
