// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_db_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationsDBModelAdapter extends TypeAdapter<NotificationsDBModel> {
  @override
  final int typeId = 1;

  @override
  NotificationsDBModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationsDBModel(
      currentChattingWithId: fields[0] as String,
      isNotificationEnabled: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationsDBModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.currentChattingWithId)
      ..writeByte(1)
      ..write(obj.isNotificationEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationsDBModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
