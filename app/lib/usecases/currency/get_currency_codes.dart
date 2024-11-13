import "package:flutter_bloc/flutter_bloc.dart";

import "package:app/repositories/.index.dart" as repositories;

final class GetCurrencyCodes extends Cubit<GetCurrencyCodesState> {
  GetCurrencyCodes({
    required this.currencyRepository,
  }) : super(GetCurrencyCodesInitial());

  final repositories.CurrencyRepository currencyRepository;

  void execute() async {
    emit(GetCurrencyCodesLoading());

    try {
      emit(GetCurrencyCodesSuccess(
        currencyCodes: await currencyRepository.getCurrencyCodes(),
      ));
    } catch (e, _) {
      emit(GetCurrencyCodesFailure(
        message: e.toString(),
      ));
    }
  }
}

sealed class GetCurrencyCodesState {}

final class GetCurrencyCodesInitial extends GetCurrencyCodesState {}

final class GetCurrencyCodesLoading extends GetCurrencyCodesState {}

final class GetCurrencyCodesSuccess extends GetCurrencyCodesState {
  GetCurrencyCodesSuccess({
    required this.currencyCodes,
  });

  final List<String> currencyCodes;
}

final class GetCurrencyCodesFailure extends GetCurrencyCodesState {
  GetCurrencyCodesFailure({
    required this.message,
  });

  final String message;
}
