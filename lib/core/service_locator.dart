import 'package:get_it/get_it.dart';
import 'package:o_connect/core/user_cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


final serviceLocator = GetIt.instance;
Future<void> setUpServiceLocator() async {
  /////// [Auth]
  serviceLocator.registerSingleton<UserCacheService>(UserCacheService());
  //external
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerFactory<SharedPreferences>(() => sharedPreferences);

}
