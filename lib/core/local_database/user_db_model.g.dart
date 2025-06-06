// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_db_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDBModelAdapter extends TypeAdapter<UserDBModel> {
  @override
  final int typeId = 0;

  @override
  UserDBModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDBModel(
      uid: fields[0] as String,
      fullName: fields[1] as String,
      email: fields[2] as String,
      phoneNumber: fields[3] as String,
      avatarUrl: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserDBModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.avatarUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDBModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
