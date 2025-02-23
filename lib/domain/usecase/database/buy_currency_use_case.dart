import 'package:asset_tracker/domain/entities/auth/base/error/base_error_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/buy_currency_entity.dart';
import 'package:asset_tracker/domain/repository/database/firestore/ifirestore_repository.dart';
import 'package:asset_tracker/domain/usecase/base/base_use_case.dart';
import 'package:dartz/dartz.dart';

class BuyCurrencyUseCase
    extends BaseUseCase<BuyCurrencyEntity, BuyCurrencyEntity> {
  final IFirestoreRepository firestoreRepository;

  BuyCurrencyUseCase({required this.firestoreRepository});

  @override
  Future<Either<BaseErrorEntity, BuyCurrencyEntity>> call(params) async {
    return await firestoreRepository.buyCurrency(params);
  }
}
