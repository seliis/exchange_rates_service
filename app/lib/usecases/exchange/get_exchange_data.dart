import "package:flutter_bloc/flutter_bloc.dart";

import "package:app/repositories/.index.dart" as repositories;
import "package:app/presenters/.index.dart" as presenters;
import "package:app/entities/.index.dart" as entities;

final class GetExchangeData extends Cubit<GetExchangeDataState> {
  GetExchangeData({
    required this.exchangeRepository,
  }) : super(GetExchangeDataInitial());

  final repositories.ExchangeRepository exchangeRepository;

  void execute(presenters.HomeData homeData) async {
    emit(GetExchangeDataLoading());

    try {
      emit(GetExchangeDataSuccess(
        exchangeData: await exchangeRepository.getExchangeData(
          currency: homeData.currency.toLowerCase(),
          date: homeData.date,
        ),
      ));
    } catch (e) {
      emit(GetExchangeDataFailure(
        message: e.toString(),
      ));
    }
  }
}

sealed class GetExchangeDataState {}

final class GetExchangeDataInitial extends GetExchangeDataState {}

final class GetExchangeDataLoading extends GetExchangeDataState {}

final class GetExchangeDataSuccess extends GetExchangeDataState {
  GetExchangeDataSuccess({
    required this.exchangeData,
  });

  final entities.ExchangeData exchangeData;
}

final class GetExchangeDataFailure extends GetExchangeDataState {
  GetExchangeDataFailure({
    required this.message,
  });

  final String message;
}
