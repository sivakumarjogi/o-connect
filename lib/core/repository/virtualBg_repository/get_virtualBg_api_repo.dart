import 'package:dio/dio.dart' hide Headers;
import 'package:o_connect/core/models/response_models/get_virtualBg_response_model/get_virtualBg_response_model.dart';
import 'package:retrofit/http.dart';

part 'get_virtualBg_api_repo.g.dart';

@RestApi(baseUrl: "https://pl6jlq6gwa.execute-api.ap-south-1.amazonaws.com")
abstract class GetVirtualBgAPI {
  factory GetVirtualBgAPI(Dio dio, {String baseUrl}) = _GetVirtualBgAPI;

  @GET("/devNew/features/getAllVBG")
  @Headers({
    "Accept": "application/json",
  })
  Future<GetVirtualBgModel> getVirtualBg();
}
