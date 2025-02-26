import 'package:asset_tracker/data/model/database/response/asset_code_model.dart';
import 'package:asset_tracker/domain/entities/database/error/database_error_entity.dart';
import 'package:asset_tracker/domain/repository/database/firestore/ifirestore_repository.dart';
import 'package:asset_tracker/domain/usecase/base/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetCurrencyCodeUseCase extends BaseUseCase {
  final IFirestoreRepository _firestoreRepository;

  GetCurrencyCodeUseCase({required IFirestoreRepository firestoreRepository})
      : _firestoreRepository = firestoreRepository;

  @override
  Future<Either<DatabaseErrorEntity, List<AssetCodeModel>>> call(params) async {
    return await _firestoreRepository.getAssetCodes();
  }
}
