import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

@HiveType(typeId: 0)
enum CalculationType {
  @HiveField(0)
  dowry,
  @HiveField(1)
  alimony,
}

@HiveType(typeId: 1)
class CalculationModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final CalculationType type;

  @HiveField(2)
  final Map<String, dynamic> inputData;

  @HiveField(3)
  final double result;

  @HiveField(4)
  final DateTime timestamp;

  CalculationModel({
    String? id,
    required this.type,
    required this.inputData,
    required this.result,
    DateTime? timestamp,
  }) : id = id ?? const Uuid().v4(),
       timestamp = timestamp ?? DateTime.now();

  CalculationModel copyWith({
    String? id,
    CalculationType? type,
    Map<String, dynamic>? inputData,
    double? result,
    DateTime? timestamp,
  }) {
    return CalculationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      inputData: inputData ?? this.inputData,
      result: result ?? this.result,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class CalculationTypeAdapter extends TypeAdapter<CalculationType> {
  @override
  final int typeId = 0;

  @override
  CalculationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CalculationType.dowry;
      case 1:
        return CalculationType.alimony;
      default:
        return CalculationType.dowry;
    }
  }

  @override
  void write(BinaryWriter writer, CalculationType obj) {
    switch (obj) {
      case CalculationType.dowry:
        writer.writeByte(0);
        break;
      case CalculationType.alimony:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CalculationModelAdapter extends TypeAdapter<CalculationModel> {
  @override
  final int typeId = 1;
  @override
  CalculationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalculationModel(
      id: fields[0] as String,
      type: fields[1] as CalculationType,
      inputData: (fields[2] as Map).cast<String, dynamic>(),
      result: fields[3] as double,
      timestamp: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CalculationModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.inputData)
      ..writeByte(3)
      ..write(obj.result)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
