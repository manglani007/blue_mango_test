part of 'beer_bloc.dart';

sealed class BeerEvent {}

class BeerFetchEvent extends BeerEvent {
  final int pageNumber;
  final num? abvLow;
  final num? abvHi;
  final num? ibuLow;
  final num? ibuHi;

  BeerFetchEvent(
      {this.abvLow, this.abvHi, this.ibuLow, this.ibuHi, this.pageNumber = 1});
}
