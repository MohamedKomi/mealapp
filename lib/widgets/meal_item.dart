import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../screens/meal_detail_screen.dart';
import '../models/meal.dart';

class MealItem extends StatelessWidget {
  final String id;
  final String imageUrl;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;

  MealItem({
    required this.id,
    required this.imageUrl,
    required this.affordability,
    required this.complexity,
    required this.duration,
  });

  void selectMeal(BuildContext context) {
    Navigator.of(context)
        .pushNamed(
      MealDetailScreen.routeName,
      arguments: id,
    )
        .then((result) {
      if (result != null) {
        // removeItem(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);

    return InkWell(
      onTap: () => selectMeal(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Hero(
                    tag: id,
                    child: InteractiveViewer(
                      child: FadeInImage(
                       height: MediaQuery.of(context).size.width*.5,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          imageUrl,
                        ),
                        placeholder: const AssetImage('assets/images/a2.png'),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Container(
                    width: 300,
                    color: Colors.black54,
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    child: Text(
                      lan.getTexts('meal-$id') as String,
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        color: Theme.of(context).buttonColor,
                        Icons.schedule,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text('$duration '),
                      if (duration > 10) Text(lan.getTexts('min') as String),
                      if (duration <= 10) Text(lan.getTexts('min2') as String),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        color: Theme.of(context).buttonColor,
                        Icons.work,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(lan.getTexts('$complexity') as String),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        color: Theme.of(context).buttonColor,
                        Icons.attach_money,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(lan.getTexts('$affordability') as String),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
