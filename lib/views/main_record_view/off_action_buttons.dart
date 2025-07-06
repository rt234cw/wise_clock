import 'package:flutter/material.dart';

enum OffButtonType {
  editingMode,
  hasRecord,
  noRecord;
}

class OffActionButtons extends StatelessWidget {
  final OffButtonType buttonType;
  final VoidCallback quickClockIn;
  final VoidCallback startEditing;

  const OffActionButtons({super.key, required this.buttonType, required this.quickClockIn, required this.startEditing});

  @override
  Widget build(BuildContext context) {
    final child = switch (buttonType) {
      OffButtonType.editingMode => SizedBox.shrink(), // 隱藏
      OffButtonType.hasRecord => _hasRecordButtons(),
      OffButtonType.noRecord => SizedBox.shrink(),
    };

    return IgnorePointer(
      ignoring: buttonType == OffButtonType.editingMode,
      child: SizedBox(
        // 這裡要加上高度，不然再展開時，Row的高度會變化
        // 導致左側的時間記錄文字也會跟著移動
        // kMinInteractiveDimension 是 Material Design 中的最小互動尺寸
        height: kMinInteractiveDimension, // 48
        child: AnimatedOpacity(
          opacity: buttonType == OffButtonType.editingMode ? 0 : 1,
          duration: const Duration(milliseconds: 200),
          child: KeyedSubtree(key: ValueKey(buttonType), child: child),
        ),
      ),
    );
  }

  Widget _hasRecordButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            onPressed: () {
              startEditing.call();
            },
            child: Text("手輸")),
        SizedBox(width: 8),
        ElevatedButton(
            onPressed: () {
              quickClockIn();
            },
            child: Text("快速打卡")),
      ],
    );
  }

  // Widget _noRecordButtons() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       TextButton(
  //           onPressed: () {
  //             startEditing.call();
  //           },
  //           child: Text("手輸")),
  //       SizedBox(width: 8),
  //       ElevatedButton(
  //           onPressed: () {
  //             quickClockIn();
  //           },
  //           child: Text("快速打卡")),
  //     ],
  //   );
  // }
}
