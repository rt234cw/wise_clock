import 'package:hive_flutter/hive_flutter.dart';
import 'package:wise_clock/hive/clock_record.dart';

class HiveService {
  Future<void> initializeHive() async {
    await Hive.initFlutter();

    // 為了防止 App 重複啟動時報錯，先檢查是否已註冊
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ClockRecordAdapter());
    }

    // 在開發完成後，務必移除或註解掉這行，否則每次都會清空資料庫！
    // await Hive.deleteBoxFromDisk('clockInRecords');

    // 打開 Box
    await Hive.openBox<ClockRecord>("clockInRecords");
  }

  Box<ClockRecord> get clockInRecordsBox {
    return Hive.box<ClockRecord>("clockInRecords");
  }
}
