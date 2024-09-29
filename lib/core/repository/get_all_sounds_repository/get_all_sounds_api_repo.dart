import 'package:dio/dio.dart' hide Headers;
import 'package:o_connect/core/models/response_models/get_all_sounds_response_model/get_all_sounds_response_model.dart';
import 'package:o_connect/ui/utils/base_urls.dart';

import 'package:o_connect/ui/views/themes/models/webinar_themes_model.dart';
import 'package:retrofit/http.dart';

part 'get_all_sounds_api_repo.g.dart';

@RestApi(baseUrl: "")
abstract class GetAllSoundsAPI {
  factory GetAllSoundsAPI(Dio dio, {String baseUrl}) = _GetAllSoundsAPI;

  /// Get All Sounds API
  @GET("/features/getAllResounds")
  Future<GetAllSoundsResponseModel> getAllSounds();

  @GET("/features/getAllThemes")
  Future<WebinarThemesModel> getAllThemes();
}
