import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wise_clock/bloc/record_bloc.dart';
import 'package:wise_clock/bloc/record_event.dart';
import 'package:wise_clock/hive/clock_record.dart';
import '../../generated/l10n.dart';
import '../common/edit_record_dialog.dart';

class HistoryDetailCard extends StatefulWidget {
  final ClockRecord record;

  const HistoryDetailCard({super.key, required this.record});

  @override
  State<HistoryDetailCard> createState() => _HistoryDetailCardState();
}

class _HistoryDetailCardState extends State<HistoryDetailCard> {
  // 顯示確認對話框的方法
  Future<void> _showDeleteConfirmationDialog() async {
    final recordBloc = context.read<RecordBloc>();

    final confirmed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (ctx) {
        return Material(
          type: MaterialType.transparency, // 類型設為透明，避免產生背景色
          child: Theme(
            data: Theme.of(context).copyWith(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
            child: AlertDialog.adaptive(
              title: Text(S.current.confirmAction),
              content: Text(S.current.sureToDeleteRecord),
              actions: _buildDialogActions(ctx, isDelete: false),
            ),
          ),
        );
      },
    );

    if (confirmed == true) {
      //  向 RecordBloc 發送刪除事件，並附上這筆紀錄的 ID
      recordBloc.add(RecordDeleted(widget.record.id));
    }
  }

  List<Widget> _buildDialogActions(BuildContext context, {required bool isDelete}) {
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      return [
        CupertinoDialogAction(
          child: Text(S.current.cancel),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: Text(S.current.delete),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ];
    } else {
      return [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(S.current.cancel),
        ),
        FilledButton.tonal(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(S.current.delete),
        ),
      ];
    }
  }

  // 輔助 Widget，用來建立每一行的詳情
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // _buildDetailRow("日期:", DateFormat('yyyy/MM/dd E', 'zh_TW').format(widget.record.clockInTime)),
            _buildDetailRow(S.current.clockInTime, DateFormat('HH:mm:ss').format(widget.record.clockInTime)),
            _buildDetailRow(
                S.current.clockOutTime,
                widget.record.clockOutTime != null
                    ? DateFormat('HH:mm:ss').format(widget.record.clockOutTime!)
                    : '---'),
            _buildDetailRow(
                S.current.leaveHours, "${(widget.record.leaveDuration?.toInt()) ?? 0} ${S.current.abbreHour}"),
            const Divider(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                  onPressed: _showDeleteConfirmationDialog,
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => showEditRecordDialog(
                    context: context,
                    selectedDate: widget.record.clockInTime,
                    existingRecord: widget.record,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
