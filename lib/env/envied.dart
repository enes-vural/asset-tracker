import 'package:envied/envied.dart';
import 'envied_config.dart';

part 'envied.g.dart';

@Envied(path: 'developer.env', obfuscate: true)
class Env implements IEnviedConfig {
  static Env? _instance;

  Env._initalize();

  static Env setup() {
    _instance ??= Env._initalize();
    return _instance!;
  }

  @EnviedField(varName: 'socketApi', obfuscate: true)
  static final String _socketApi = _Env._socketApi;

  @override
  String get socketApi => _socketApi;
}
