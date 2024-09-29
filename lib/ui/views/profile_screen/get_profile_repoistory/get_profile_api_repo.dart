import 'package:dio/dio.dart';
import 'package:o_connect/core/models/faq_model/faq_model.dart';
import 'package:o_connect/core/models/response_models/profile_response_model.dart/profile_response_model.dart';
import 'package:o_connect/core/models/response_models/update_response_model.dart';
import 'package:o_connect/ui/views/profile_screen/profile_model/change_password_response_model.dart';
import 'package:o_connect/ui/views/profile_screen/profile_model/updtaeuser_response_model.dart';
import 'package:retrofit/http.dart';

import '../../../utils/base_urls.dart';
import '../profile_model/profile_information_model.dart';

part 'get_profile_api_repo.g.dart';

@RestApi(baseUrl: "")
abstract class GetProfileApi {
  factory GetProfileApi(Dio dio, {String baseUrl}) = _GetProfileApi;

  @GET("/headerInfo")
  Future<GetProfileResponseModel> getProfile();

  @GET("/get-profile/{userId}")
  Future<ProfileInformationModel> getProfileInformationById(@Path("userId") String itemId);

  @PUT("/update-profile")
  Future<UpdateResponseModel> updateProfile(@Body() Map<String, dynamic> body);

  @GET("/faqs-service/getFaqsList")
  Future getFAQ();

  @POST("/uploadProfilePic")
  Future<GetUpdateUserResponseModel> updateUser(@Body() data);

  @POST("/changePassword")
  Future<GetChangePasswordResponseModel> changePassword(
      @Body() Map<String, dynamic> data);

  
  @DELETE(BaseUrls.deleteProfilePic)
    Future<Response> deleteProfilePic(
    
  );


}
