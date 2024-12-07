// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LevelProgressAdapter extends TypeAdapter<LevelProgress> {
  @override
  final int typeId = 0;

  @override
  LevelProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LevelProgress(
      levelId: fields[0] as int,
      isCompleted: fields[1] as bool,
      highScore: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, LevelProgress obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.levelId)
      ..writeByte(1)
      ..write(obj.isCompleted)
      ..writeByte(2)
      ..write(obj.highScore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
