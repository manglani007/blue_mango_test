import 'package:blue_mango_test/bloc/models/beer.dart';
import 'package:flutter/material.dart';

class BeerDetails extends StatelessWidget {
  final BeerModel beer;
  const BeerDetails({super.key, required this.beer});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(beer.name!)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: Image.network(beer.imageUrl!)),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            beer.name!,
                            style: textTheme.titleLarge,
                          ),
                          Text(
                            beer.tagline!,
                            maxLines: 10,
                            //style: textTheme.titleLarge,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(beer.description!),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "First Brewed:${beer.firstBrewed}",
                  style: textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "ABV:${beer.abv}",
                  style: textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "IBU:${beer.ibu}",
                  style: textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Target FG:${beer.targetFg}",
                  style: textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Target OG:${beer.targetOg}",
                  style: textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "EBC:${beer.ebc}",
                  style: textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "SRM:${beer.srm}",
                  style: textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Ph:${beer.ph}",
                  style: textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Attenuation Level:${beer.attenuationLevel}",
                  style: textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Volume:${beer.volume!.value} ${beer.volume!.unit}",
                  style: textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Boil Volume:${beer.boilVolume!.value} ${beer.boilVolume!.unit}",
                  style: textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Method",
                  style: textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: methodUi(beer.method!),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Ingredients",
                  style: textTheme.headlineSmall,
                ),
              ),
              ingredientsUi(beer.ingredients!),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  "Food Pairing",
                  style: textTheme.headlineSmall,
                ),
              ),
              ...beer.foodPairing!
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(e),
                      ))
                  .toList(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Brewers Tips:${beer.brewersTips}",
                  style: textTheme.labelMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Contributed by-${beer.contributedBy}",
                  style: textTheme.labelMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget methodUi(Method method) {
    List<Text> mtTexts = [];
    for (var mt in method.mashTemp!) {
      mtTexts.add(Text(
          "${mt.temp!.value}(${mt.temp!.unit}) - Duration:${mt.duration ?? 'N/A'}"));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ...mtTexts,
      Row(
        children: [
          const Text("fermentation"),
          const SizedBox(width: 10),
          Text(
              "${method.fermentation!.temp!.value}(${method.fermentation!.temp!.unit})"),
        ],
      ),
      Wrap(
        children: [
          const Text("Twist"),
          const SizedBox(width: 10),
          Text("${method.twist ?? 'N/A'}"),
        ],
      )
    ]);
  }

  ingredientsUi(Ingredients ingredients) {
    var ingredientsTextList = ingredients.malt!
        .map((e) => Text("${e.name}(${e.amount!.value} ${e.amount!.unit})"))
        .toList();
    var a = ListTile(
      title: const Text("Malt"),
      subtitle: Column(children: ingredientsTextList),
    );

    var hopsTextList = ingredients.hops!
        .map((e) => Text(
            "${e.name}(${e.amount!.value} ${e.amount!.unit}) (${e.add}-${e.attribute})"))
        .toList();
    var b = ListTile(
      title: const Text("Hops"),
      subtitle: Column(children: hopsTextList),
    );
    var c = ListTile(
      title: const Text("Yeast"),
      subtitle: Text(ingredients.yeast!),
    );
    return Column(
      children: [a, b, c],
    );
  }
}
