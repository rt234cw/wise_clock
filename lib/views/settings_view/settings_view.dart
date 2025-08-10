import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../providers/locale_provider.dart';
import '../../providers/settings_provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    // final localeProvider = context.watch<LocaleProvider>();

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ".System",
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Container(
          decoration: BoxDecoration(color: Colors.amber.withAlpha(100)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _getIconTitle(title: S.current.selectLanguage, iconData: Icons.translate_rounded),
                  selectLanguage(context)
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          ".Calendar",
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Container(
          decoration: BoxDecoration(color: Colors.amber.withAlpha(100)),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _getIconTitle(
                    title: ".顯示週末",
                    iconData: Icons.weekend_rounded,
                  ),
                  Switch.adaptive(
                    value: settingsProvider.showWeekend,
                    onChanged: (value) => settingsProvider.setShowWeekend(value),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _getIconTitle(
                    title: ".每月固定顯示六週",
                    iconData: Icons.looks_6_rounded,
                  ),
                  Switch.adaptive(
                    value: settingsProvider.showSixWeeks,
                    onChanged: (value) => {settingsProvider.setFixedSixWeeks(value)},
                  )
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          ".Data",
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Container(
          decoration: BoxDecoration(color: Colors.amber.withAlpha(100)),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _getIconTitle(
                    title: S.current.clearAllRecords,
                    iconData: Icons.warning_amber_rounded,
                  ),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {},
                    label: Text(S.current.clear),
                    icon: Icon(Icons.delete_forever),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget selectLanguage(BuildContext context) {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          value: context.read<LocaleProvider>().locale?.languageCode ?? "zh",
          buttonStyleData: ButtonStyleData(
            width: 120,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).cardColor,
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          items: [
            DropdownMenuItem(
              value: "zh",
              child: Text("中文"),
            ),
            DropdownMenuItem(
              value: "en",
              child: Text("English"),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              context.read<LocaleProvider>().setLocale(Locale(value));
            }
          },
        ),
      ),
    );
  }
}

Widget _getIconTitle({
  required String title,
  required IconData iconData,
}) {
  return Row(
    children: [
      Icon(
        iconData,
        color: Colors.grey,
        size: 20,
      ),
      const SizedBox(width: 8),
      Text(title),
    ],
  );
}
