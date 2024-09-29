import 'package:dio/dio.dart';
import 'package:o_connect/core/models/response_models/get_all_bgms_response_model/get_bgm_response_model.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:retrofit/http.dart';

part 'theme_repository.g.dart';

@RestApi(baseUrl: "")
abstract class ThemeRepository {
  factory ThemeRepository(Dio dio, {String baseUrl}) = _ThemeRepository;

  @GET("/features/getAllBgms")
  Future<GetBgmResponseModel> getAllBGMs();
}
