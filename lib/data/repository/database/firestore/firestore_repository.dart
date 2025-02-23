import 'package:asset_tracker/data/model/database/error/database_error_model.dart';
import 'package:asset_tracker/data/model/database/request/buy_currency_model.dart';
import 'package:asset_tracker/data/model/database/response/asset_code_model.dart';
import 'package:asset_tracker/data/service/remote/database/firestore/ifirestore_service.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/buy_currency_entity.dart';
import 'package:asset_tracker/domain/entities/database/error/database_error_entity.dart';
import 'package:asset_tracker/domain/repository/database/firestore/ifirestore_repository.dart';
import 'package:dartz/dartz.dart';

class FirestoreRepository implements IFirestoreRepository {
  final IFirestoreService firestoreService;

  const FirestoreRepository({required this.firestoreService});

  @override
  Future<Either<DatabaseErrorEntity, List<AssetCodeModel>>>
      getAssetCodes() async {
    final currencyCodeList = await firestoreService.getAssetCodes();
    //we setted our default empty error
    const DatabaseErrorEntity emptyError = DatabaseErrorEntity(
        message: "asset codes not available [developer error line 27]");

    return currencyCodeList.fold(
      (DatabaseErrorModel failure) {
        return Left(DatabaseErrorEntity.fromModel(failure));
      },
      (List<AssetCodeModel> success) {
        //the error statement if value was empty
        if (success.isEmpty) {
          return const Left(emptyError);
        }

        //another cases we will return the success value
        return Right(success);
      },
    );
  }

  @override
  Future<Either<DatabaseErrorEntity, BuyCurrencyEntity>> buyCurrency(
      BuyCurrencyEntity entity) async {
    final data =
        await firestoreService.buyCurrency(BuyCurrencyModel.fromEntity(entity));

    return data.fold((failure) {
      return Left(DatabaseErrorEntity.fromModel(failure));
    }, (success) {
      return Right(BuyCurrencyEntity.fromModel(success));
    });
  }
}
