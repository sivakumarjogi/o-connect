import 'dart:developer';

import 'package:dio/dio.dart' hide Headers;
import 'package:o_connect/core/models/create_webinar_model/get_contact_model.dart';
import 'package:o_connect/core/models/response_models/login_response_model/login_response_model.dart';
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:retrofit/http.dart';

part 'auth_api_repo.g.dart';

@RestApi(baseUrl: "")
abstract class AuthApiRepository {
  factory AuthApiRepository(Dio dio, {String baseUrl}) = _AuthApiRepository;

  /// login
  @POST('/login')
  @Headers(ApiHelper.basicHeader)
  Future<ResponseModel> loginUser(@Body() Map<String, dynamic> data);

  @POST('/register')
  @Headers(ApiHelper.basicHeader)
  Future<ResponseModel> registerUser(@Body() Map<String, dynamic> data);

  @GET("/app/forgot-password")
  @Headers(ApiHelper.basicHeader)
  Future<ResponseModel> sendOtpRequestForForgotPassword(
      @Query("alternateEmailId") String alternateEmailId);

  @POST("/app/validate-forgot-password-otp")
  Future<ResponseModel> validateForgotPasswordOtp(
      @Query("emailId") String alternateEmailId, @Query("otp") String otp);

  @GET("/validate-login-otp")
  @Headers(ApiHelper.basicHeader)
  Future<ResponseModel> validateOtpForForgotPassword(
      @Query("otp") String otp, @Query("emailId") String emailId);

  @GET("/send-login-otp")
  @Headers(ApiHelper.basicHeader)
  Future<ResponseModel> sendOtpRequestLogin(@Query("emailId") String emailId);

  @POST('/app/reset-password')
  Future<ResponseModel> changeUserPassword(@Body() Map<String, dynamic> data);

  @POST('/getContacts')
  Future<AllContactsModel> getAllContacts(@Body() Map<String, dynamic> data);

  @POST('/saveOrUpdateContact')
  Future<Response> createContact(@Body() Object? data);

  @GET('/getCountries')
  Future<Response> getCountries();

  @GET('/getStatesByCountryId/{countryId}')
  @Headers(ApiHelper.basicHeader)
  Future<Response> getAllStates(
    @Path("countryId") String countryId,
  );

  /// Delete Contact
  @POST('/moveOrRestoreContactFromTrash')
  @Headers(ApiHelper.basicHeader)
  Future<Response> deleteContacts(@Body() Map<String, dynamic> data);
}
