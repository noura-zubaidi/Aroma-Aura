// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchased_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PurchasedItemAdapter extends TypeAdapter<PurchasedItem> {
  @override
  final int typeId = 1;

  @override
  PurchasedItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PurchasedItem(
      itemId: fields[0] as String?,
      itemName: fields[1] as String,
      image: fields[2] as String,
      price: fields[3] as int,
      description: fields[4] as String,
      quantity: fields[5] as int,
      userId: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PurchasedItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.itemName)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchasedItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
