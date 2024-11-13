import "package:flutter_bloc/flutter_bloc.dart";

import "package:app/repositories/.index.dart" as repositories;
import "package:app/entities/.index.dart" as entities;

final class GetCurrency extends Cubit<GetCurrencyState> {
  GetCurrency({
    required this.currencyRepository,
  }) : super(GetCurrencyInitial());

  final repositories.CurrencyRepository currencyRepository;

  void execute({
    required String? currencyCode,
    required String date,
  }) async {
    if (currencyCode == null) {
      emit(GetCurrencyFailure(
        message: "Currency Code is Required.",
      ));

      return;
    }

    emit(GetCurrencyLoading());

    try {
      emit(GetCurrencySuccess(
        currency: await currencyRepository.getCurrency(
          currencyCode: currencyCode.toLowerCase(),
          date: date,
        ),
      ));
    } catch (e, _) {
      emit(GetCurrencyFailure(
        message: e.toString(),
      ));
    }
  }
}

sealed class GetCurrencyState {}

final class GetCurrencyInitial extends GetCurrencyState {}

final class GetCurrencyLoading extends GetCurrencyState {}

final class GetCurrencySuccess extends GetCurrencyState {
  GetCurrencySuccess({
    required this.currency,
  });

  final entities.Currency currency;
}

final class GetCurrencyFailure extends GetCurrencyState {
  GetCurrencyFailure({
    required this.message,
  });

  final String message;
}
