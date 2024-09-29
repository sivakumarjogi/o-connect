import 'package:dio/dio.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/views/home_screen/home_screen_models/user_subscription_model.dart';
import 'package:o_connect/ui/views/join_with_meetingid.dart';
import 'package:retrofit/retrofit.dart';

@RestApi(baseUrl: "")
abstract class HomeApiRepository {
  factory HomeApiRepository(Dio dio, {String baseUrl}) = _HomeApiRepository;

  /// get All Meetings info
  @POST(BaseUrls.getAllMeetingCount)
  Future<Response> getAllMeetingInfo(@Body() Map<String, dynamic> body);

  /// get All Meetings info
  @GET(BaseUrls.getMeetingStatistics)
  Future<Response> getMeetingStatistics(@Query("fromDate") String fDate, @Query("toDate") String tDate);

  /// get all banners
  @GET("/file-info/getFiles?")
  Future<Response> getAllBanners(@Query("user_id") String userid,@Query("purpose") String banner);

  /// get  Meetings
  @POST(BaseUrls.getMeetings)
  Future<Response> getMeetings(@Body() Map<String, dynamic> body);

  @POST("/userData/filterInvite-meetings")
  Future<Response> getMeetingRequests(@Body() Map<String, dynamic> body);

  @POST(BaseUrls.getInviteMeetings)
  Future<Response> getInviteMeetings(@Body() Map<String, dynamic> body);

  @POST("/userData/filterInvite-meetings")
  Future<Response> getMeetingsRequests(@Body() Map<String, dynamic> body);

  /// Invited Meetings
  @POST(BaseUrls.inviteGetMeeting)
  Future<Response> inviteMeetings(@Body() Map<String, dynamic> body);

  @PUT(BaseUrls.inviteUpDateMeeting)
  Future<Response> invitePutMeetings(@Body() Map<String, dynamic> body);

  /// Delete Meetings
  @POST(BaseUrls.deleteMeeting)
  Future deleteMeeting(@Body() Map<String, dynamic> body);

  /// Transfer Meetings
  @POST(BaseUrls.transferMeeting)
  Future transferMeeting(@Body() Map<String, dynamic> body);

  /// Delete Meetings
  @POST(BaseUrls.deletePastMeeting)
  Future deletePastMeeting(@Body() Map<String, dynamic> body);

  @POST(BaseUrls.joinMeetingByIdEndPoint)
  Future<Response> joinMeetingById(@Body() Map<String, dynamic> body);

  @GET("/{customerId}/products-menu")
  Future<UserSubscriptionModel> checkSubscribedProducts(@Path() String customerId);

  @GET("/getSubscriptionDetailsByOmailId")
  Future<Response> getOconnectSubscriptionDetails(
    @Query("omailId") String fDate,
  );
}

class _HomeApiRepository implements HomeApiRepository {
  _HomeApiRepository(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;
  @override
  Future<Response<dynamic>> getAllMeetingInfo(Map<String, dynamic> body) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = <String, dynamic>{};

    data.addAll(body);
    final result = await _dio.fetch(_setStreamType<Response<dynamic>>(Options(
      method: 'POST',
      headers: headers,
      extra: extra,
    )
        .compose(
          _dio.options,
          '/userData/update-invitedMeetingsCount',
          queryParameters: queryParameters,
          data: data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    print("meeting count data ${result.data.toString()}");
    // final value = _result.data;
    return result;
  }

  // @override
  // Future<Response<dynamic>> getAllMeetingInfo(Map<String, dynamic> body) async {
  //   const extra = <String, dynamic>{};
  //   final queryParameters = <String, dynamic>{};
  //   final headers = <String, dynamic>{};
  //   const Map<String, dynamic>? data = null;
  //   final result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response<dynamic>>(Options(
  //     method: 'POST',
  //     headers: headers,
  //     extra: extra,
  //   )
  //       .compose(
  //         _dio.options,
  //         '/update-invitedMeetingsCount',
  //         queryParameters: queryParameters,
  //         data: data,
  //       )
  //       .copyWith(
  //           baseUrl: _combineBaseUrls(
  //         _dio.options.baseUrl,
  //         baseUrl,
  //       ))));
  //   // final value = Response<dynamic>.fromJson(_result.data!);
  //   return result;
  // }

  @override
  Future<Response<dynamic>> getMeetingStatistics(
    String fDate,
    String tDate,
  ) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'fromDate': fDate,
      r'toDate': tDate,
    };
    final headers = <String, dynamic>{};
    const Map<String, dynamic>? data = null;
    final result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response<dynamic>>(Options(
      method: 'GET',
      headers: headers,
      extra: extra,
    )
        .compose(
          _dio.options,
          '/meeting/getCustomEventsCount/',
          queryParameters: queryParameters,
          data: data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));

    print("husygsuyfgsuifsdfh ${result.data.toString()}");
    // final value = Response<dynamic>.fromJson(_result.data!);
    return result;
  }

  @override
  Future<Response<dynamic>> getAllBanners(String userid,String banner) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'user_id': userid,
      r'purpose': banner,
    };    final headers = <String, dynamic>{};
    const Map<String, dynamic>? data = null;

    final result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response<dynamic>>(Options(
      method: 'GET',
      headers: headers,
      extra: extra,
    )
        .compose(
          _dio.options,
          '/file-info/getFiles?',
          queryParameters: queryParameters,
         data: data
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));

    print("fgfff ${result.data.toString()}");
    // final value = Response<dynamic>.fromJson(_result.data!);
    return result;
  }

  @override
  Future<Response<dynamic>> getOconnectSubscriptionDetails(
    String omailId,
  ) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'omailId': omailId,
    };
    final headers = <String, dynamic>{};
    const Map<String, dynamic>? data = null;
    final result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response<dynamic>>(Options(
      method: 'GET',
      headers: headers,
      extra: extra,
    )
        .compose(
          _dio.options,
          '/getSubscriptionDetailsByOmailId',
          queryParameters: queryParameters,
          data: data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));

    // final value = Response<dynamic>.fromJson(_result.data!);
    return result;
  }

  @override
  Future<Response> getInviteMeetings(Map<String, dynamic> body) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = <String, dynamic>{};
    data.addAll(body);
    final result = await _dio.fetch(_setStreamType<Response>(Options(
      method: 'POST',
      headers: headers,
      extra: extra,
    )
        .compose(
          _dio.options,
          '/userData/invited-meetings',
          queryParameters: queryParameters,
          data: data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    // final value = _result.data;
    return result;
  }

  @override
  Future<Response> inviteMeetings(Map<String, dynamic> body) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = <String, dynamic>{};
    data.addAll(body);
    final result = await _dio.fetch(_setStreamType<Response>(Options(
      method: 'POST',
      headers: headers,
      extra: extra,
    )
        .compose(
          _dio.options,
          '/userData/invited-meetings',
          queryParameters: queryParameters,
          data: data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    // final value = _result.data;
    return result;
  }

  @override
  Future<Response> invitePutMeetings(Map<String, dynamic> body) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = <String, dynamic>{};
    data.addAll(body);
    final result = await _dio.fetch(_setStreamType<Response>(Options(
      method: 'PUT',
      headers: headers,
      extra: extra,
    )
        .compose(
          _dio.options,
          '/userData/update-invite-status',
          queryParameters: queryParameters,
          data: data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    // final value = _result.data;
    return result;
  }

  @override
  Future<Response> getMeetingRequests(Map<String, dynamic> body) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = <String, dynamic>{};
    data.addAll(body);
    final result = await _dio.fetch(_setStreamType<Response>(Options(
      method: 'POST',
      headers: headers,
      extra: extra,
    )
        .compose(
          _dio.options,
          '/userData/filterInvite-meetings',
          queryParameters: queryParameters,
          data: data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));

    print("hgbvhffhdsifdsfdsjfh ${result.data}");
    // final value = _result.data;
    return result;
  }

  @override
  Future<Response> getMeetings(Map<String, dynamic> body) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = <String, dynamic>{};
    data.addAll(body);
    final result = await _dio.fetch(_setStreamType<Response>(Options(
      method: 'POST',
      headers: headers,
      extra: extra,
    )
        .compose(
          _dio.options,
          '/meeting/filteredEvents',
          queryParameters: queryParameters,
          data: data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    // final value = _result.data;
    return result;
  }

  @override
  Future<dynamic> deleteMeeting(Map<String, dynamic> body) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = <String, dynamic>{};
    data.addAll(body);
    final result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: headers,
      extra: extra,
    )
        .compose(
          _dio.options,
          '/meeting/delete',
          queryParameters: queryParameters,
          data: data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    // final value = _result.data;
    return result;
  }

  @override
  Future<dynamic> transferMeeting(Map<String, dynamic> body) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = <String, dynamic>{};
    data.addAll(body);
    final result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: headers,
      extra: extra,
    )
        .compose(
          _dio.options,
          '/meeting/assignMeetingTo',
          queryParameters: queryParameters,
          data: data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    // final value = _result.data;
    return result;
  }

  @override
  Future<dynamic> deletePastMeeting(Map<String, dynamic> body) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = <String, dynamic>{};
    data.addAll(body);
    final result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: headers,
      extra: extra,
    )
        .compose(
          _dio.options,
          '/meeting/deleteInPast',
          queryParameters: queryParameters,
          data: data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    // final value = _result.data;
    return result;
  }

  @override
  Future<Response> joinMeetingById(Map<String, dynamic> body) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = <String, dynamic>{};
    data.addAll(body);
    final result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: headers,
      extra: extra,
    )
        .compose(
          _dio.options,
          '/meeting/joinMeeting',
          queryParameters: queryParameters,
          data: data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    // final value = _result.data;
    return result;
  }

  @override
  Future<UserSubscriptionModel> checkSubscribedProducts(String customerId) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    const Map<String, dynamic>? data = null;
    final result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<UserSubscriptionModel>(Options(
      method: 'GET',
      headers: headers,
      extra: extra,
    )
        .compose(
          _dio.options,
          '/$customerId/products-menu',
          queryParameters: queryParameters,
          data: data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    final value = UserSubscriptionModel.fromJson(result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic && !(requestOptions.responseType == ResponseType.bytes || requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }

  @override
  Future<Response> getMeetingsRequests(Map<String, dynamic> body) {
    // TODO: implement getMeetingsRequests
    throw UnimplementedError();
  }
}
