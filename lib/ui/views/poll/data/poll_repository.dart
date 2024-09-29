import 'package:dio/dio.dart' hide Headers;
import 'package:o_connect/ui/views/poll/model/create_poll_response_model.dart';
import 'package:o_connect/ui/views/poll/model/fetch_poll_question_files.dart';
import 'package:retrofit/retrofit.dart';

@RestApi()
abstract class PollRepository {
  factory PollRepository(Dio dio, {String baseUrl}) = _PollRepository;

  @GET('/survey/getSurveyByUserId?from_user_id={userId}')
  Future<FetchPollQuestionFile> fetchAllPreviousPollQuestionFiles(@Path() String userId);

  @POST('/survey/createSurvey')
  Future<CreatePollResponseModel> createPoll(@Body() Map<String, dynamic> body);

  @POST('/survey/deleteSurvey')
  Future<Response> deletePoll(@Body() Map<String, dynamic> body);

  @POST('/survey/createDuplicateSurvey')
  Future<CreatePollResponseModel> createDuplicatePollSurveyQuestionFile(@Body() Map<String, dynamic> body);

  @POST('/survey/editSurvey')
  Future<CreatePollResponseModel> editPoll(@Body() Map<String, dynamic> body);
}

class _PollRepository implements PollRepository {
  _PollRepository(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<FetchPollQuestionFile> fetchAllPreviousPollQuestionFiles(String userId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<FetchPollQuestionFile>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/survey/getSurveyByUserId?from_user_id=$userId',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    final value = FetchPollQuestionFile.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CreatePollResponseModel> createPoll(Map<String, dynamic> body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<CreatePollResponseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/survey/createSurvey',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    final value = CreatePollResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CreatePollResponseModel> editPoll(Map<String, dynamic> body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<CreatePollResponseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/survey/editSurvey',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    final value = CreatePollResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Response> deletePoll(Map<String, dynamic> body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/survey/deleteSurvey',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));

    return _result;
  }

  @override
  Future<CreatePollResponseModel> createDuplicatePollSurveyQuestionFile(Map<String, dynamic> body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<CreatePollResponseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          "/survey/createDuplicateSurvey",
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    final value = CreatePollResponseModel.fromJson(_result.data!);
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
