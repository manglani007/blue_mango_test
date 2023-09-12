part of 'beer_bloc.dart';

sealed class BeerState {}

final class BeerInitial extends BeerState {}

final class BeerErrorState extends BeerState {
  final String msg;

  BeerErrorState({required this.msg});
}

final class BeerLoadingState extends BeerState {}

final class BeerLoadedState extends BeerState {
  int currentPage;
  List<BeerModel> beerList;
  bool moreAvailable;
  final num? abvLow;
  final num? abvHi;
  final num? ibuLow;
  final num? ibuHi;
  BeerLoadedState(
      {required this.beerList,
      required this.currentPage,
      this.abvLow,
      this.abvHi,
      this.ibuLow,
      this.ibuHi,
      this.moreAvailable = false});
}
