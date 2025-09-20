// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clock_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClockRecordAdapter extends TypeAdapter<ClockRecord> {
  @override
  final int typeId = 0;

  @override
  ClockRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClockRecord(
      id: fields[0] as String,
      clockInTime: fields[1] as DateTime,
      clockOutTime: fields[2] as DateTime?,
      offDuration: fields[3] as double?,
      leaveDuration: fields[4] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ClockRecord obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.clockInTime)
      ..writeByte(2)
      ..write(obj.clockOutTime)
      ..writeByte(3)
      ..write(obj.offDuration)
      ..writeByte(4)
      ..write(obj.leaveDuration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClockRecordAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
