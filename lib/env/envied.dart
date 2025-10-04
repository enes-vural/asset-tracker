import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:envied/envied.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'envied_config.dart';

part 'envied.g.dart';

@Envied(path: 'developer.env', obfuscate: true)
class Env implements IEnviedConfig {
  static final Env _instance = Env._internal();
  factory Env() => _instance;

  final Encrypter _encrypter;

  Env._internal()
      : _encrypter = Encrypter(AES(Key.fromBase64(_aesKey), mode: AESMode.cbc));


  @EnviedField(varName: 'socketApi', obfuscate: true)
  static final String _socketApi = _Env._socketApi;

  @EnviedField(varName: 'aesKey', obfuscate: true)
  static final String _aesKey = _Env._aesKey;

  @EnviedField(varName: 'aesIv', obfuscate: true)
  static final String _aesIv = _Env._aesIv;

  @EnviedField(varName: 'googleAuthKey', obfuscate: true)
  static final String _googleAuthKey = _Env._googleAuthKey;

  String encryptText(String text) {
    final encrypted = _encrypter.encrypt(text, iv: IV.fromBase16(_aesIv));
    return encrypted.base64;
  }

  String tryDecrypt(String? data) {
    try {
      if (data == null || data.isEmpty) {
        return "";
      }
      if (!_isBase64(data)) {
        // şifrelenmemiş veri
        return data;
      }
      return _encrypter.decrypt64(data, iv: IV.fromBase16(_aesIv));
    } catch (e) {
      debugPrint('Decryption failed: $e');
      return data ?? "";
    }
  }

  bool _isBase64(String str) {
    // Base64 formatı: 4'ün katları şeklinde, sonunda 0-2 adet = olabilir
    final base64Regex = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');
    if (!base64Regex.hasMatch(str)) return false;

    // Uzunluk kontrolü
    if (str.length % 4 != 0) return false;

    try {
      base64Decode(str);
      return true;
    } catch (_) {
      return false;
    }
  }
  @override
  String get socketApi => _socketApi;


  @override
  String get googleAuthKey => _googleAuthKey;
}
