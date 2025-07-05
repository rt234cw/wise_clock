import 'package:hive_flutter/hive_flutter.dart';
import 'package:wise_clock/hive/clock_record.dart';

class HiveService {
  Future<void> initializeHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ClockInAdapter());
    await Hive.deleteBoxFromDisk('clockInRecords');
    await Hive.openBox<ClockRecord>("clockInRecords");
  }

  Box<ClockRecord> get clockInRecordsBox {
    return Hive.box<ClockRecord>("clockInRecords");
  }
}

class ClockInAdapter extends TypeAdapter<ClockRecord> {
  @override
  int get typeId => 0;

  @override
  ClockRecord read(BinaryReader reader) {
    // 1️⃣ 先读 id
    final id = reader.read() as String;
    // 2️⃣ 再读 clockInTime（可能为 null）
    final clockInTime = reader.read() as DateTime;
    // 3️⃣ 最后读 clockOutTime（可能为 null）
    final clockOutTime = reader.read() as DateTime?;
    final offDuration = reader.read() as double?;

    return ClockRecord(
      id: id,
      clockInTime: clockInTime,
      clockOutTime: clockOutTime,
      offDuration: offDuration,
    );
  }

  @override
  void write(BinaryWriter writer, ClockRecord obj) {
    // 1️⃣ 写 id（String）
    writer.write(obj.id);
    // 2️⃣ 写 clockInTime（DateTime?）
    writer.write(obj.clockInTime);
    // 3️⃣ 写 clockOutTime（DateTime?）
    writer.write(obj.clockOutTime);
    writer.write(obj.offDuration);
  }
}
