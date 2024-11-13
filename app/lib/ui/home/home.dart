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
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 768;

        return BlocListener(
          bloc: BlocProvider.of<usecases.GetCurrency>(context),
          listener: (context, state) {
            final size = MediaQuery.of(context).size;
            final width = size.width * 0.90;
            final height = size.height * 0.70;

            if (state is usecases.GetCurrencyFailure) {
              showDialog<void>(
                context: context,
                builder: (_) {
                  return common_ui.ErrorDialog(
                    message: state.message,
                    width: isMobile ? width : 512,
                    height: isMobile ? height : 256,
                  );
                },
              );
            }

            if (state is usecases.GetCurrencySuccess) {
              showDialog<void>(
                context: context,
                builder: (_) {
                  return _Dialog(
                    currency: state.currency,
                    width: isMobile ? width : 512,
                    height: isMobile ? height : 256,
                  );
                },
              );
            }
          },
          child: _View(
            isMobile: isMobile,
          ),
        );
      },
    );
  }
}

final class _View extends StatelessWidget {
  const _View({
    required this.isMobile,
  });

  final bool isMobile;

  @override
  Widget build(context) {
    return Scaffold(
      body: BlocBuilder<usecases.GetCurrencyCodes, usecases.GetCurrencyCodesState>(
        bloc: BlocProvider.of<usecases.GetCurrencyCodes>(context),
        builder: (context, state) {
          if (state is usecases.GetCurrencyCodesLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is usecases.GetCurrencyCodesFailure) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is usecases.GetCurrencyCodesSuccess) {
            return isMobile ? const _Mobile() : const _Desktop();
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

final class _Mobile extends StatelessWidget {
  const _Mobile();

  @override
  Widget build(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox.shrink(),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.10,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _Currencies(
                  expand: true,
                ),
                const SizedBox(
                  height: 16,
                ),
                common_ui.DateField(
                  controller: presenters.Home.controller,
                ),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: _Button(),
                ),
              ],
            ),
          ),
        ),
        const _Footer(
          isMobile: true,
        ),
      ],
    );
  }
}

final class _Desktop extends StatelessWidget {
  const _Desktop();

  @override
  Widget build(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox.shrink(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _Currencies(
              expand: false,
            ),
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
            const SizedBox(
              width: 128,
              height: 48,
              child: _Button(),
            ),
          ],
        ),
        const _Footer(
          isMobile: false,
        ),
      ],
    );
  }
}

final class _Footer extends StatelessWidget {
  const _Footer({
    required this.isMobile,
  });

  final bool isMobile;

  @override
  Widget build(context) {
    return Text(
      "© 2024 Aero K Airlines. Developed by In Son.",
      style: TextStyle(
        fontWeight: FontWeight.w100,
        fontSize: isMobile ? 12 : 16,
      ),
    );
  }
}

final class _Dialog extends StatelessWidget {
  const _Dialog({
    required this.currency,
    required this.width,
    required this.height,
  });

  final entities.Currency currency;
  final double width;
  final double height;

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
        width: width,
        height: height,
        child: ListView(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                "Currency",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(currency.curreencyCode),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                "Date",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(currency.date),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "One ${currency.curreencyCode} Equals",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text("${currency.rate.toString()} KRW"),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: currency.rate.toString()));
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
  const _Currencies({
    required this.expand,
  });

  final bool expand;

  @override
  Widget build(context) {
    final state = context.watch<usecases.GetCurrencyCodes>().state as usecases.GetCurrencyCodesSuccess;

    return DropdownMenu(
      width: expand ? null : 128,
      label: const Text("Currency"),
      expandedInsets: expand ? EdgeInsets.zero : null,
      initialSelection: presenters.Home.selectedCurrencyCode,
      onSelected: (currencyCode) {
        if (currencyCode != null) {
          presenters.Home.selectedCurrencyCode = currencyCode;
        }
      },
      dropdownMenuEntries: state.currencyCodes.map((currencyCode) {
        return DropdownMenuEntry(
          value: currencyCode,
          label: currencyCode,
        );
      }).toList(),
    );
  }
}

final class _Button extends StatelessWidget {
  const _Button();

  @override
  Widget build(context) {
    final bool isLoading = context.watch<usecases.GetCurrency>().state is usecases.GetCurrencyLoading;

    void Function()? onPressed() {
      if (isLoading) {
        return null;
      }

      return () {
        context.read<usecases.GetCurrency>().execute(
              currencyCode: presenters.Home.selectedCurrencyCode,
              date: presenters.Home.controller.text,
            );
      };
    }

    return FilledButton(
      onPressed: onPressed(),
      style: FilledButton.styleFrom(
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
