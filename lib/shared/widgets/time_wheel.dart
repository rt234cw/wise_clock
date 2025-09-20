import 'package:flutter/material.dart';
import 'package:wheel_picker/wheel_picker.dart';

class TimeWheel extends StatefulWidget {
  // 為了清晰，修正了拼寫和命名
  final ({int hour, int min, int sec})? initialTime;
  final ValueSetter<({int hour, int min, int sec})> onTimeChanged;

  const TimeWheel({
    super.key,
    required this.onTimeChanged,
    this.initialTime,
  });

  @override
  State<TimeWheel> createState() => _TimeWheelState();
}

class _TimeWheelState extends State<TimeWheel> {
  late final WheelPickerController hourWheel;
  late final WheelPickerController minWheel;
  late final WheelPickerController secWheel;

  @override
  void initState() {
    super.initState();
    final now = TimeOfDay.now();
    hourWheel = WheelPickerController(
      itemCount: 24,
      initialIndex: widget.initialTime?.hour ?? now.hour,
    );
    minWheel = WheelPickerController(
      itemCount: 60,
      initialIndex: widget.initialTime?.min ?? now.minute,
    );
    secWheel = WheelPickerController(
      itemCount: 60,
      initialIndex: widget.initialTime?.sec ?? 0,
    );

    // 如果父元件沒有正確處理初始值，可以使用這個安全的回調
    // 但最佳實踐是由父元件自己處理
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onTimeChanged((hour: hourWheel.initialIndex, min: minWheel.initialIndex, sec: secWheel.initialIndex));
      }
    });
  }

  // didUpdateWidget 已被移除，因為它是錯誤的

  @override
  void dispose() {
    hourWheel.dispose();
    minWheel.dispose();
    secWheel.dispose();
    super.dispose();
  }

  // build 方法保持不變，因為它寫得很好
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 16.0, height: 1.5);
    final wheelStyle = WheelPickerStyle(
      itemExtent: textStyle.fontSize! * textStyle.height!,
      squeeze: 1.25,
      diameterRatio: .8,
      surroundingOpacity: .25,
      magnification: 1.2,
    );

    return Center(
      child: SizedBox(
        width: 130,
        height: 60,
        child: Stack(
          children: [
            _centerBar(),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildWheelPicker(hourWheel, context, textStyle, wheelStyle),
                const Padding(padding: EdgeInsets.only(bottom: 3), child: Text(":")),
                _buildWheelPicker(minWheel, context, textStyle, wheelStyle),
                const Padding(padding: EdgeInsets.only(bottom: 3), child: Text(":")),
                _buildWheelPicker(secWheel, context, textStyle, wheelStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWheelPicker(
    WheelPickerController controller,
    BuildContext context,
    TextStyle textStyle,
    WheelPickerStyle wheelStyle,
  ) {
    return SizedBox(
      height: 60,
      width: 40,
      child: WheelPicker(
        selectedIndexColor: Theme.of(context).colorScheme.primary,
        controller: controller,
        style: wheelStyle,
        onIndexChanged: (index, interactionType) {
          widget.onTimeChanged((hour: hourWheel.selected, min: minWheel.selected, sec: secWheel.selected));
        },
        builder: (context, index) {
          return Text(index.toString().padLeft(2, "0"), style: textStyle);
        },
      ),
    );
  }

  Widget _centerBar() {
    return Center(
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withAlpha(20),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
