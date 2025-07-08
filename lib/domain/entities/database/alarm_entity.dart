import 'package:asset_tracker/data/model/base/base_model.dart';
import 'package:asset_tracker/data/model/database/alarm_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final class AlarmEntity implements BaseEntity {
  final String currencyCode;
  final String direction;
  final bool isTriggered;
  final String mode;
  final double targetValue;
  final String type;
  final String userID;
  final String? docID;
  final DateTime createTime;

  AlarmEntity({
    required this.currencyCode,
    required this.direction,
    required this.isTriggered,
    required this.mode,
    required this.targetValue,
    required this.type,
    required this.userID,
    required this.createTime,
    this.docID,
  });

  AlarmEntity copyWith({
    String? currencyCode,
    String? direction,
    bool? isTriggered,
    String? mode,
    double? targetValue,
    String? type,
    String? userID,
    String? docID,
    DateTime? createTime,
  }) {
    return AlarmEntity(
      currencyCode: currencyCode ?? this.currencyCode,
      direction: direction ?? this.direction,
      isTriggered: isTriggered ?? this.isTriggered,
      mode: mode ?? this.mode,
      targetValue: targetValue ?? this.targetValue,
      type: type ?? this.type,
      userID: userID ?? this.userID,
      createTime: createTime ?? this.createTime,
      docID: docID ?? this.docID,
    );
  }

  // toString method
  @override
  String toString() {
    return 'AlarmEntity(currencyCode: $currencyCode, direction: $direction, isTriggered: $isTriggered, mode: $mode, targetValue: $targetValue, type: $type, userID: $userID, docID: $docID)';
  }

  @override
  AlarmModel toModel() {
    return AlarmModel(
      currencyCode: currencyCode,
      direction: direction,
      isTriggered: isTriggered,
      mode: mode,
      targetValue: targetValue,
      type: type,
      userID: userID,
      createTime: Timestamp.fromDate(createTime),
      docID: docID,
    );
  }
}
