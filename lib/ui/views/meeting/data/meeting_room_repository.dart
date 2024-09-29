import 'package:dio/dio.dart' hide Headers;
import 'package:o_connect/ui/views/bgm/model/custom_mp3_files_model.dart';
import 'package:o_connect/ui/views/meeting/model/attendee_data_response.dart';
import 'package:o_connect/ui/views/meeting/model/global_access_set_response.dart';
import 'package:o_connect/ui/views/meeting/model/input.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_data_response/meeting_data_response.dart';
import 'package:o_connect/ui/views/meeting/model/meeting_global_access_status_response/meeting_global_access_status_response.dart';
import 'package:o_connect/ui/views/meeting/model/new_attendee_response/new_attendee_response.dart';
import 'package:retrofit/http.dart';

@RestApi()
abstract class MeetingRoomRepository {
  factory MeetingRoomRepository(Dio dio, {String baseUrl}) = _MeetingRoomRepository;

  @POST('/meeting/check-meeting-valid')
  Future<MeetingDataResponse> checkMeetingIsValid(@Body() CheckMeetingIsValidInput input);

  @POST('/meeting/getEventDetailsById')
  Future<MeetingDataResponse> fetchEventDetailsById(@Body() Map<String, dynamic> data);

  @POST('/global-access/status/get')
  Future<MeetingGlobalAccessStatusResponse> fetchMeetingGlobalAccessStatus(@Body() Map<String, dynamic> body);

  @POST('/attendee/newAttendee')
  Future<NewAttendeeResponse> addNewAttendee(@Body() Map<String, dynamic> body);

  @GET('/panelcount/{meetingId}')
  Future<Response> fetchPanelCount(@Path() String meetingId);

  @GET('/attendee/getTempBlockAttendeeList')
  Future<Response> fetchTempBlockedAttendeeList(@Query('meeting_id') String meetingId);

  @GET('/global-access/getMeetingAccessStatus/{meetingId}')
  Future<Response> handRaise(@Path() String meetingId);

  @POST('/global-access/status/set')
  Future<Response> updateGlobalAccessStatus(@Body() Map<String, dynamic> body);

  @POST('/global-access/status/delete/{meetingId}')
  Future<Response> deleteMeetingStatus(@Path() String meetingId);

  @POST('/meeting/updateMeetingStatus')
  Future<Response> updateMeetingStatus(@Body() Map<String, dynamic> body);

  @POST('/attendee/updateRole')
  Future<Response> updateRole(@Body() Map<String, dynamic> body);

  @POST('/attendee/blockAttendee')
  Future<Response> blockAttendee(@Body() Map<String, dynamic> body);

  @GET('/getUserDetails/{oacid}')
  Future<Response> fetchOesUserDetails(@Path() String oacid);

  @POST('/meeting/UpDateMeetingDetails')
  Future<MeetingDataResponse> updateMeetingDetails(@Body() Map<String, dynamic> body);

  @POST('/attendee/exportAttendeeList')
  Future<Response> exportAttendeeList(@Body() Map<String, dynamic> body);

  @GET('/oparticipantdata/{meetingId}/0/100')
  Future<AttendeeDataResponse> fetchAttendeeUsers(@Path() String meetingId);

  @POST('/global-access/set')
  Future<GlobalAccessSetResponse> setGlobalAccess(@Body() Map<String, dynamic> body);

  @POST('/file-info/save-recordings')
  Future<Response> saveReciordings(@Body() Map<String, dynamic> body);

  @POST('/global-access/status/set')
  Future<Response> setBreakTime(@Body() Map<String, dynamic> body);

  @POST('/meeting/meetingExtension')
  Future<Response> extendMeetingTime(@Body() Map<String, dynamic> body);

  @GET("/file-info/getFiles")
  Future<List<CustomMp3FilesModel>> fetchMp3Files(@Query("user_id") String userId, @Query("purpose") String purpose, @Query("category") String category);
}

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _MeetingRoomRepository implements MeetingRoomRepository {
  _MeetingRoomRepository(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<MeetingDataResponse> checkMeetingIsValid(CheckMeetingIsValidInput input) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(input.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<MeetingDataResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/meeting/check-meeting-valid',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    final value = MeetingDataResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MeetingDataResponse> fetchEventDetailsById(@Body() Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<MeetingDataResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/meeting/getEventDetailsById',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    final value = MeetingDataResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MeetingGlobalAccessStatusResponse> fetchMeetingGlobalAccessStatus(Map<String, dynamic> body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<MeetingGlobalAccessStatusResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/global-access/status/get',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));

    print("avvvvvvvvvvvvvvvvvvvvvvvv ${_result.data}");
    final value = MeetingGlobalAccessStatusResponse.fromJson(_result.data!);


    return value;
  }

  @override
  Future<NewAttendeeResponse> addNewAttendee(Map<String, dynamic> body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<NewAttendeeResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/attendee/newAttendee',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));

    print("ateendeeeeeeeee111111111   ${_result.data!.toString()}");
    final value = NewAttendeeResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Response<dynamic>> fetchPanelCount(String meetingId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response<dynamic>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/panelcount/${meetingId}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    // final value = Response<dynamic>.fromJson(_result.data!);
    return _result;
  }

  @override
  Future<Response<dynamic>> fetchTempBlockedAttendeeList(String meetingId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'meeting_id': meetingId,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response<dynamic>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/attendee/getTempBlockAttendeeList',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    // final value = Response<dynamic>.fromJson(_result.data!);
    return _result;
  }

  @override
  Future<Response<dynamic>> handRaise(String meetingId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response<dynamic>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/global-access/getMeetingAccessStatus/${meetingId}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    // final value = Response<dynamic>.fromJson(_result.data!);
    return _result;
  }

  @override
  Future<Response<dynamic>> updateGlobalAccessStatus(Map<String, dynamic> body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    print(_dio.options.headers.toString());
    print(baseUrl);

    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/global-access/status/set',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    print("kjjhjjgjfhhytjjffjhghjvbhvhgfhgfhfhhjgjvjgfhjfjhfjfj");
    print(_result.data!.toString());
    // final value = Response<dynamic>.fromJson(_result.data!);
    return _result;
  }

  @override
  Future<Response<dynamic>> deleteMeetingStatus(String meetingId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};

    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/global-access/status/delete/${meetingId}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    // final value = Response<dynamic>.fromJson(_result.data!);
    return _result;
  }

  @override
  Future<Response<dynamic>> updateMeetingStatus(Map<String, dynamic> body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/meeting/updateMeetingStatus',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    // final value = Response<dynamic>.fromJson(_result.data!);
    return _result;
  }

  @override
  Future<Response<dynamic>> updateRole(Map<String, dynamic> body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/attendee/updateRole',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    // final value = Response<dynamic>.fromJson(_result.data!);
    return _result;
  }

  @override
  Future<Response<dynamic>> blockAttendee(Map<String, dynamic> body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/attendee/blockAttendee',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    // final value = Response<dynamic>.fromJson(_result.data!);
    return _result;
  }

  @override
  Future<Response<dynamic>> fetchOesUserDetails(String oacid) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response<dynamic>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/getUserDetails/${oacid}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    // final value = Response<dynamic>.fromJson(_result.data!);
    return _result;
  }

  @override
  Future<MeetingDataResponse> updateMeetingDetails(Map<String, dynamic> body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<MeetingDataResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/meeting/UpDateMeetingDetails',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    final value = MeetingDataResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Response> exportAttendeeList(Map<String, dynamic> body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/attendee/exportAttendeeList',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    // final value = MeetingDataResponse.fromJson(_result.data!);
    return _result;
  }

  @override
  Future<AttendeeDataResponse> fetchAttendeeUsers(String meetingId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<AttendeeDataResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/oparticipantdata/$meetingId/0/100',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    final value = AttendeeDataResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GlobalAccessSetResponse> setGlobalAccess(Map<String, dynamic> body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/global-access/set',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    final value = GlobalAccessSetResponse.fromMap(_result.data!);
    return value;
  }

  @override
  Future<Response> saveReciordings(Map<String, dynamic> body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/file-info/save-recordings',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    // final value = GlobalAccessSetResponse.fromMap(_result.data!);
    return _result;
  }

  @override
  Future<Response> setBreakTime(Map<String, dynamic> body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/global-access/status/set',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));

    print("jdfsfsfhksfjksldskjfdslkjfdslkfjslkfjslkfjlkdsfjlkdsfjlkdsf");
    // final value = GlobalAccessSetResponse.fromMap(_result.data!);
    return _result;
  }

  @override
  Future<Response> extendMeetingTime(Map<String, dynamic> body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/meeting/meetingExtension',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    // final value = MeetingDataResponse.fromJson(_result.data!);
    return _result;
  }

  @override
  Future<List<CustomMp3FilesModel>> fetchMp3Files(String userId, String purpose, String category) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'user_id': userId, r'purpose': purpose, r'category': category};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    Response _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<CustomMp3FilesModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/file-info/getFiles?',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    List<CustomMp3FilesModel> value = (_result.data!["data"] as List).map((e) => CustomMp3FilesModel.fromJson(e)).toList();
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
}
