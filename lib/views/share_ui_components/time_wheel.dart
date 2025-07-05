import 'package:flutter/material.dart';

import 'package:wheel_picker/wheel_picker.dart';
import 'package:wise_clock/color_scheme/color_code.dart';

class TimeWheel extends StatefulWidget {
  final ({int hour, int min, int sec})? userReocrd;
  final ValueSetter<({int hour, int min, int sec})> onSetter;
  const TimeWheel({
    super.key,
    required this.onSetter,
    required this.userReocrd,
  });

  @override
  State<TimeWheel> createState() => _TimeWheelState();
}

class _TimeWheelState extends State<TimeWheel> {
  late final TimeOfDay timeNow;

  late final WheelPickerController hourWheel;
  late final WheelPickerController minWheel;
  late final WheelPickerController secWheel;

  @override
  void initState() {
    timeNow = TimeOfDay.now();

    hourWheel = WheelPickerController(
      itemCount: 24,
      initialIndex: widget.userReocrd?.hour ?? timeNow.hour,
    );

    minWheel = WheelPickerController(
      itemCount: 60,
      initialIndex: widget.userReocrd?.min ?? timeNow.minute,
    );

    secWheel = WheelPickerController(
      itemCount: 60,
      initialIndex: widget.userReocrd?.sec ?? 0,
    );

    // 一開始要先呼叫一次OnSetter，確保初始時間被設定
    // 否則用戶直接按更新會使用初始時間為0:0:0
    widget.onSetter((hour: hourWheel.initialIndex, min: minWheel.initialIndex, sec: secWheel.initialIndex));

    super.initState();
  }

  @override
  void dispose() {
    hourWheel.dispose();
    minWheel.dispose();
    secWheel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 16.0, height: 1.5);
    final wheelStyle = WheelPickerStyle(
      itemExtent: textStyle.fontSize! * textStyle.height!, // Text height
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
          // fit: StackFit.expand,
          children: [
            _centerBar(),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var wheelController in [hourWheel, minWheel, secWheel]) ...{
                  Row(
                    children: [
                      SizedBox(
                        height: 60,
                        width: 40,
                        child: WheelPicker(
                          selectedIndexColor: Colors.deepOrange,
                          controller: wheelController,
                          style: wheelStyle,
                          onIndexChanged: (index, interactionType) {
                            widget.onSetter((hour: hourWheel.selected, min: minWheel.selected, sec: secWheel.selected));
                          },
                          builder: (context, index) {
                            return Text(
                              index.toString().padLeft(2, "0"),
                              style: textStyle,
                            );
                          },
                        ),
                      ),
                      if (wheelController != secWheel)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(":"),
                        ),
                    ],
                  )
                }
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _centerBar() {
    return Center(
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: ColorCode.primaryColor.withAlpha(20),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
