import 'package:blue_mango_test/bloc/beer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FliterDialog extends StatefulWidget {
  const FliterDialog({super.key});

  @override
  State<FliterDialog> createState() => _FliterDialogState();
}

class _FliterDialogState extends State<FliterDialog> {
  RangeValues ibuValue = const RangeValues(0, 100);
  RangeValues abvValue = const RangeValues(0, 100);
  @override
  void initState() {
    var cstate = context.read<BeerBloc>().state as BeerLoadedState;
    ibuValue = RangeValues(
        cstate.ibuLow != null ? cstate.ibuLow!.toDouble() : 0,
        cstate.ibuHi != null ? cstate.ibuHi!.toDouble() : 100);
    abvValue = RangeValues(
        cstate.abvLow != null ? cstate.abvLow!.toDouble() : 0,
        cstate.abvHi != null ? cstate.abvHi!.toDouble() : 100);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BeerBloc, BeerState>(
      builder: (context, state) {
        if (state is BeerLoadedState) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            const Text("IBU Value"),
            RangeSlider(
                labels: RangeLabels(
                    ibuValue.start.toString(), ibuValue.end.toString()),
                max: 100,
                min: 0,
                divisions: 100,
                values: ibuValue,
                onChanged: (r) {
                  setState(() {
                    ibuValue = r;
                  });
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(ibuValue.start.toString()),
                Text(ibuValue.end.toString()),
              ],
            ),
            const Text("ABV Value"),
            RangeSlider(
                labels: RangeLabels(
                    abvValue.start.toString(), abvValue.end.toString()),
                max: 100,
                min: 0,
                divisions: 100,
                values: abvValue,
                onChanged: (r) {
                  setState(() {
                    abvValue = r;
                  });
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(abvValue.start.toString()),
                Text(abvValue.end.toString()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      context.read<BeerBloc>().add(BeerFetchEvent(
                            pageNumber: 1,
                          ));
                      Navigator.pop(context);
                    },
                    child: const Text("Reset")),
                ElevatedButton(
                    onPressed: () {
                      context.read<BeerBloc>().add(BeerFetchEvent(
                          pageNumber: 1,
                          ibuLow: ibuValue.start,
                          ibuHi: ibuValue.end,
                          abvLow: abvValue.start,
                          abvHi: abvValue.end));
                      Navigator.pop(context);
                    },
                    child: const Text("Apply")),
              ],
            )
          ]);
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
