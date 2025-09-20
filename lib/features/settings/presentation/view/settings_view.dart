import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise_clock/core/bloc/record_bloc.dart';

import '../../../../core/bloc/record_event.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/settings_provider.dart';

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
          S.current.system,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
          ),
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
          S.current.calendar,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _getIconTitle(
                    title: S.current.showWeekend,
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
                    title: S.current.alwaysSixWeeks,
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
          S.current.data,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _getIconTitle(
                    title: S.current.clearAllRecords,
                    iconData: Icons.event_busy_rounded,
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                    ),
                    onPressed: () async {
                      final confirmed = await _clearAllRecordsDialog(context);
                      if (confirmed && context.mounted) {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(S.current.clearAll),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                      }
                    },
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

  Future<bool> _clearAllRecordsDialog(BuildContext context) async {
    bool isIos = Theme.of(context).platform == TargetPlatform.iOS;

    final confirmed = await showAdaptiveDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(S.current.confirmAction),
          content: Text(S.current.permanentlyDelete),
          actions: [
            if (isIos) ...[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(S.current.cancel),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(S.current.clearAll),
              ),
            ],
            if (!isIos) ...[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(S.current.cancel),
              ),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(S.current.clearAll),
              )
            ]
          ],
        );
      },
    );

    if (confirmed != true) return false;
    // 確認刪除後，發送清除所有紀錄的事件
    if (context.mounted) context.read<RecordBloc>().add(AllRecordsDeleted());
    return true;
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
