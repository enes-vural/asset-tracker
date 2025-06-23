import 'package:asset_tracker/data/model/base/error/error_model.dart';

//TODO Buraya da firebase exception durumuna göre convert edilmesi lazım.
final class DatabaseErrorModel extends BaseErrorModel {
  const DatabaseErrorModel({required super.message});
}
