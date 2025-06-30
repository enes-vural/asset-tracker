import 'package:asset_tracker/data/model/auth/iauth_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthUser implements IAuthenticationUserModel {
  @override
  String? get displayName => user?.displayName ?? googleUser?.displayName;
  
  @override
  String? get email => user?.email ?? googleUser?.email;
  
  @override
  String? get uid => user?.uid;
  
  @override
  bool? get emailVerified =>
      user?.emailVerified ?? (googleUser != null ? true : null);
  
  @override
  final String? idToken;
  
  final User? user;
  final GoogleSignInAccount? googleUser;

  const FirebaseAuthUser({
    required this.user,
    required this.idToken,
    this.googleUser,
  });
  
  // Google kullanıcısı için özel constructor
  const FirebaseAuthUser.fromGoogle({
    required this.googleUser,
    required this.idToken,
    this.user,
  });

  // Hem Firebase hem Google kullanıcısı için constructor
  const FirebaseAuthUser.combined({
    required this.user,
    required this.googleUser,
    required this.idToken,
  });

  // Kullanıcının Google ile giriş yapıp yapmadığını kontrol eden getter
  bool get isGoogleUser => googleUser != null;

  // Google kullanıcısının fotoğraf URL'si
  String? get photoUrl => googleUser?.photoUrl ?? user?.photoURL;

  // Kullanıcının hangi provider ile giriş yaptığını dönen method
  String get provider {
    if (googleUser != null && user != null) return 'google_firebase';
    if (googleUser != null) return 'google';
    if (user != null) return 'firebase';
    return 'unknown';
  }
}
