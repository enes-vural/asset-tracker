import 'package:asset_tracker/domain/entities/database/enttiy/user_data_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_uid_entity.dart';
import 'package:asset_tracker/domain/entities/database/error/database_error_entity.dart';
import 'package:asset_tracker/domain/repository/database/firestore/ifirestore_repository.dart';
import 'package:asset_tracker/domain/usecase/base/base_use_case.dart';
import 'package:dartz/dartz.dart';

//TODO: Database use case diye ayrılacak direkt olarak

class GetUserDataUseCase implements BaseUseCase<UserDataEntity, UserUidEntity> {
  final IFirestoreRepository firestoreRepository;

  const GetUserDataUseCase({required this.firestoreRepository});

  @override
  Future<Either<DatabaseErrorEntity, UserDataEntity>> call(
      UserUidEntity params) async {
    return await firestoreRepository.getUserData(params);
  }
}
