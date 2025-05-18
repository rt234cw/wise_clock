class TimeCalculateHelper {
  static Map<String, int> calculateTimeOffset(DateTime baseTime, int offsetMinutes) {
    final totalMinutes = baseTime.hour * 60 + baseTime.minute + offsetMinutes;
    final correctedTotal = (totalMinutes + 24 * 60) % (24 * 60); // 避免負值

    final hour = correctedTotal ~/ 60;
    final minute = correctedTotal % 60;

    return {'hour': hour, 'minute': minute};
  }
}
