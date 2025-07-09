import 'package:asset_tracker/data/model/base/base_model.dart';
import 'package:asset_tracker/domain/entities/database/alarm_entity.dart';
import 'package:asset_tracker/presentation/view_model/home/alarm/alarm_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final class AlarmModel implements BaseModel {
  final String currencyCode;
  final String direction;
  final bool isTriggered;
  final String mode;
  final double targetValue;
  final String type;
  final String userID;
  final Timestamp createTime;
  final String? docID;

  AlarmModel({
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

  // // toJson method
  // Map<String, dynamic> toJson() {
  //   return {
  //     'currencyCode': currencyCode,
  //     'direction': direction,
  //     'isTriggered': isTriggered,
  //     'mode': mode,
  //     'targetValue': targetValue,
  //     'type': type,
  //     'userID': userID,
  //     'createTime': createTime,
  //   };
  // }

  // fromJson method
  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      currencyCode: json['currencyCode'] as String,
      direction: json['direction'] as String,
      isTriggered: json['isTriggered'] as bool,
      mode: json['mode'] as String,
      targetValue: (json['targetValue'] as num).toDouble(),
      type: json['type'] as String,
      userID: json['userId'] as String,
      docID: json['docId'] as String,
      createTime: Timestamp.fromMillisecondsSinceEpoch(
          int.tryParse(json['createTime']['value']) ?? 0),
    );
  }

  // copyWith method
  AlarmModel copyWith({
    String? currencyCode,
    String? direction,
    bool? isTriggered,
    String? mode,
    double? targetValue,
    String? type,
    String? userID,
    Timestamp? createTime,
    String? docID,
  }) {
    return AlarmModel(
      currencyCode: currencyCode ?? this.currencyCode,
      direction: direction ?? this.direction,
      isTriggered: isTriggered ?? this.isTriggered,
      mode: mode ?? this.mode,
      targetValue: targetValue ?? this.targetValue,
      type: type ?? this.type,
      createTime: createTime ?? this.createTime,
      userID: userID ?? this.userID,
      docID: docID ?? this.docID,
    );
  }

  // toString method (bonus)
  @override
  String toString() {
    return 'AlarmModel(currencyCode: $currencyCode, direction: $direction, isTriggered: $isTriggered, mode: $mode, targetValue: $targetValue, type: $type, userID: $userID, docID: $docID)';
  }

  @override
  AlarmEntity toEntity() => AlarmEntity(
        currencyCode: currencyCode,
        direction: AlarmCondition.values.firstWhere((e) => e.name == direction),
        isTriggered: isTriggered,
        mode: AlarmType.values.firstWhere((e) => e.name == mode),
        targetValue: targetValue,
        type: AlarmOrderType.values.firstWhere((e) => e.name == type),
        userID: userID,
        docID: docID,
        createTime: createTime.toDate(),
      );
}
