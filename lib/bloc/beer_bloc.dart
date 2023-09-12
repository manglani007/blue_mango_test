import 'package:blue_mango_test/bloc/models/beer.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'beer_event.dart';
part 'beer_state.dart';

class BeerBloc extends Bloc<BeerEvent, BeerState> {
  BeerBloc() : super(BeerInitial()) {
    on<BeerFetchEvent>((event, emit) async {
      if (event.pageNumber < 2) emit(BeerLoadingState());
      try {
        var res = await Dio()
            .get("https://api.punkapi.com/v2/beers", queryParameters: {
          "page": event.pageNumber,
          "limit": 20,
          if (event.abvLow != null) "abv_gt": event.abvLow,
          if (event.abvHi != null) "abv_lt": event.abvHi,
          if (event.ibuLow != null) "ibu_gt": event.ibuLow,
          if (event.ibuHi != null) "ibu_lt": event.ibuHi,
        });

        var newBeerList = beerModelFromJson(res.data);
        List<BeerModel> beerList = [];
        if (state is BeerLoadedState) {
          beerList = (state as BeerLoadedState).beerList;
          beerList.addAll(newBeerList);
        } else {
          beerList.addAll(newBeerList);
        }

        emit(BeerLoadedState(
            beerList: beerList,
            moreAvailable: newBeerList.isNotEmpty,
            currentPage: event.pageNumber,
            abvLow: event.abvLow,
            abvHi: event.abvHi,
            ibuLow: event.ibuLow,
            ibuHi: event.ibuHi));
      } catch (e) {
        emit(BeerErrorState(msg: e.toString()));
      }
    });
  }
}
