import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter/material.dart";

import "package:app/presenters/.index.dart" as presenters;
import "package:app/ui/common/.index.dart" as common_ui;
import "package:app/usecases/.index.dart" as usecases;
import "package:app/entities/.index.dart" as entities;

final class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(context) {
    return BlocListener(
      bloc: BlocProvider.of<usecases.GetExchangeData>(context),
      listener: (context, state) {
        if (state is usecases.GetExchangeDataFailure) {
          showDialog<void>(
            context: context,
            builder: (_) {
              return common_ui.ErrorDialog(
                message: state.message,
              );
            },
          );
        }

        if (state is usecases.GetExchangeDataSuccess) {
          showDialog<void>(
            context: context,
            builder: (_) {
              return _Dialog(data: state.exchangeData);
            },
          );
        }
      },
      child: const _View(),
    );
  }
}

final class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox.shrink(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _Currencies(),
              const SizedBox(
                width: 16,
              ),
              SizedBox(
                width: 256,
                child: common_ui.DateField(
                  controller: presenters.Home.controller,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              const _Button(),
            ],
          ),
          const Text("Developed by In Son at Aero K Airlines, 2024"),
        ],
      ),
    );
  }
}

final class _Dialog extends StatelessWidget {
  const _Dialog({
    required this.data,
  });

  final entities.ExchangeData data;

  @override
  Widget build(context) {
    return AlertDialog(
      title: const Text(
        "Exchange Data",
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      content: SizedBox(
        width: 512,
        height: 256,
        child: Column(
          children: [
            ListTile(
              title: const Text(
                "Currency",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(data.currency),
            ),
            ListTile(
              title: const Text(
                "Date",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(data.date),
            ),
            ListTile(
              title: const Text(
                "Rates",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(data.rates.toString()),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: data.rates.toString()));
                },
              ),
            ),
            ListTile(
              title: const Text(
                "AMOS Rates",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(data.amosRates.toString()),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: data.amosRates.toString()));
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Close"),
        ),
      ],
    );
  }
}

final class _Currencies extends StatelessWidget {
  const _Currencies();

  @override
  Widget build(context) {
    return DropdownMenu(
      initialSelection: presenters.Home.currency,
      onSelected: (value) {
        if (value != null) {
          presenters.Home.currency = value;
        }
      },
      dropdownMenuEntries: presenters.Home.currencies.map((currency) {
        return DropdownMenuEntry(
          value: currency,
          label: currency,
        );
      }).toList(),
    );
  }
}

final class _Button extends StatelessWidget {
  const _Button();

  @override
  Widget build(context) {
    final bool isLoading = context.watch<usecases.GetExchangeData>().state is usecases.GetExchangeDataLoading;

    void Function()? onPressed() {
      if (isLoading) {
        return null;
      }

      return () {
        context.read<usecases.GetExchangeData>().execute(presenters.Home.data);
      };
    }

    return FilledButton(
      onPressed: onPressed(),
      style: FilledButton.styleFrom(
        fixedSize: const Size(128, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: isLoading
          ? Transform.scale(
              scale: 0.50,
              child: const CircularProgressIndicator(),
            )
          : const Text("Query"),
    );
  }
}
