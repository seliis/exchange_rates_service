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
          bloc: BlocProvider.of<usecases.GetExchangeData>(context),
          listener: (context, state) {
            final size = MediaQuery.of(context).size;
            final width = size.width * 0.90;
            final height = size.height * 0.70;

            if (state is usecases.GetExchangeDataFailure) {
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

            if (state is usecases.GetExchangeDataSuccess) {
              showDialog<void>(
                context: context,
                builder: (_) {
                  return _Dialog(
                    data: state.exchangeData,
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
      body: isMobile ? const _Mobile() : const _Desktop(),
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
    required this.data,
    required this.width,
    required this.height,
  });

  final entities.ExchangeData data;
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
              subtitle: Text(data.currency),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                "Date",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(data.date),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
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
              contentPadding: EdgeInsets.zero,
              title: const Text(
                "Rates For AMOS",
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
  const _Currencies({
    required this.expand,
  });

  final bool expand;

  @override
  Widget build(context) {
    return DropdownMenu(
      width: expand ? null : 128,
      label: const Text("Currency"),
      expandedInsets: expand ? EdgeInsets.zero : null,
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
