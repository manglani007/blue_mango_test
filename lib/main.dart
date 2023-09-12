import 'package:blue_mango_test/bloc/beer_bloc.dart';
import 'package:blue_mango_test/bloc/models/beer.dart';
import 'package:blue_mango_test/ui/widgets/beer_details.dart';
import 'package:blue_mango_test/ui/widgets/filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beer catalogue',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => BeerBloc(),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scrollController = ScrollController();
  int currentPage = 1;

  @override
  void initState() {
    context.read<BeerBloc>().add(BeerFetchEvent(pageNumber: 1));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        fetchBeers();
      }
    });
    super.initState();
  }

  fetchBeers() {
    var state = context.read<BeerBloc>().state as BeerLoadedState;
    if (state.moreAvailable == false) return;
    currentPage++;
    context.read<BeerBloc>().add(BeerFetchEvent(
        pageNumber: currentPage,
        abvLow: state.abvLow,
        abvHi: state.abvHi,
        ibuLow: state.ibuLow,
        ibuHi: state.ibuHi));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Beer Catalogue App"), actions: [
        IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  if (context.read<BeerBloc>().state is BeerLoadedState) {
                    return BlocProvider.value(
                      value: context.read<BeerBloc>(),
                      child: const AlertDialog(
                          title: Text("Filter"), content: FliterDialog()),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            },
            icon: const Icon(Icons.sort)),
        IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                  content: Text("App By Rohit Manglani for blue mango labs"),
                ),
              );
            },
            icon: const Icon(Icons.info))
      ]),
      body: BlocListener<BeerBloc, BeerState>(
        listener: (context, state) {
          if (state is BeerLoadedState) {
            currentPage = 1;
          }
          if (state is BeerLoadedState) {
            if (state.moreAvailable && !_scrollController.hasClients) {
              fetchBeers();
            }
          }
        },
        child: BlocBuilder<BeerBloc, BeerState>(
          builder: (context, state) {
            if (state is BeerLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is BeerErrorState) {
              return Center(
                child: Column(
                  children: [
                    Text(state.msg),
                    TextButton.icon(
                        onPressed: () => context
                            .read<BeerBloc>()
                            .add(BeerFetchEvent(pageNumber: 1)),
                        icon: const Icon(Icons.refresh),
                        label: const Text("Retry"))
                  ],
                ),
              );
            }
            if (state is BeerLoadedState) {
              currentPage = state.currentPage;
              return RefreshIndicator(
                onRefresh: () {
                  context.read<BeerBloc>().add(BeerFetchEvent(
                      pageNumber: 1,
                      abvLow: state.abvLow,
                      abvHi: state.abvHi,
                      ibuLow: state.ibuLow,
                      ibuHi: state.ibuHi));
                  return Future.value();
                },
                child: state.beerList.isEmpty
                    ? const Center(child: Text("No Beer Found"))
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: state.moreAvailable
                            ? state.beerList.length + 1
                            : state.beerList.length,
                        itemBuilder: (context, index) {
                          if (state.moreAvailable &&
                              index == state.beerList.length) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          var beer = state.beerList[index];

                          return beerListTile(beer);
                        },
                      ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  ListTile beerListTile(BeerModel beer) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BeerDetails(
                    beer: beer,
                  )),
        );
      },
      leading: beer.imageUrl == null
          ? const Icon(Icons.warning)
          : Image.network(beer.imageUrl!),
      title: Text(beer.name!),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            beer.tagline!,
            maxLines: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("ABV - ${beer.abv}"),
              const SizedBox(width: 10),
              Text("IBU - ${beer.ibu}")
            ],
          ),
        ],
      ),
      trailing: const Icon(Icons.arrow_right),
    );
  }
}
