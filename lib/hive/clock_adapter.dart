import 'package:hive_flutter/hive_flutter.dart';
import 'package:wise_clock/daily_clock_log.dart' show DailyClockLog;

import '../models/clock_records.dart';

class OnDutyClockAdapter extends TypeAdapter<OnDutyClockRecords> {
  @override
  OnDutyClockRecords read(BinaryReader reader) {
    return OnDutyClockRecords(
      id: reader.read(),
      clockIn: reader.read(),
    );
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, OnDutyClockRecords obj) {
    writer.write(obj.id);
    writer.write(obj.clockIn);
  }
}

class OffDutyClockAdapter extends TypeAdapter<OnDutyClockRecords> {
  @override
  OnDutyClockRecords read(BinaryReader reader) {
    return OnDutyClockRecords(
      id: reader.read(),
      clockIn: reader.read(),
    );
  }

  @override
  int get typeId => 2;

  @override
  void write(BinaryWriter writer, OnDutyClockRecords obj) {
    writer.write(obj.id);
    writer.write(obj.clockIn);
  }
}

class DurationAdapter extends TypeAdapter<Duration> {
  @override
  Duration read(BinaryReader reader) {
    // 先讀出 microseconds，再還原成 Duration
    final int micros = reader.readInt();
    return Duration(microseconds: micros);
  }

  @override
  int get typeId => 1;

  @override
  void write(BinaryWriter writer, Duration obj) {
    // 用 microseconds 存，比 milliseconds 更精確
    writer.writeInt(obj.inMicroseconds);
  }
}

class DailyClockLogAdapter extends TypeAdapter<DailyClockLog> {
  @override
  final int typeId = 3;

  @override
  DailyClockLog read(BinaryReader reader) {
    final id = reader.readString();
    final date = DateTime.fromMillisecondsSinceEpoch(reader.readInt());

    // clockIn
    DateTime? clockIn;
    final hasClockIn = reader.readBool();
    if (hasClockIn) {
      clockIn = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    }

    // clockOut
    DateTime? clockOut;
    final hasClockOut = reader.readBool();
    if (hasClockOut) {
      clockOut = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    }

    return DailyClockLog(
      id: id,
      date: date,
      clockIn: clockIn,
      clockOut: clockOut,
    );
  }

  @override
  void write(BinaryWriter writer, DailyClockLog obj) {
    writer
      ..writeString(obj.id)
      ..writeInt(obj.date.millisecondsSinceEpoch);

    // clockIn
    writer.writeBool(obj.clockIn != null);
    if (obj.clockIn != null) {
      writer.writeInt(obj.clockIn!.millisecondsSinceEpoch);
    }

    // clockOut
    writer.writeBool(obj.clockOut != null);
    if (obj.clockOut != null) {
      writer.writeInt(obj.clockOut!.millisecondsSinceEpoch);
    }
  }
}
