import 'package:dio/dio.dart' hide Headers;
import 'package:o_connect/ui/views/call_to_action/model/call_to_action_response_model.dart';
import 'package:retrofit/retrofit.dart';

@RestApi()
abstract class CallToActionRepository {
  factory CallToActionRepository(Dio dio, {String baseUrl}) = _CallToActionRepository;

  @POST("/cta/create")
  Future<CallToActionResponseModel> createCallToAction(@Body() Map<String, dynamic> input);

  @POST("/cta/deleteCTA")
  Future<Response> deleteCTA(@Body() Map<String, dynamic> input);

  @POST("/cta/partcipantCreate")
  Future<Response> ctaGetNoOfTaps(@Body() Map<String, dynamic> input);
}

class _CallToActionRepository implements CallToActionRepository {
  _CallToActionRepository(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<CallToActionResponseModel> createCallToAction(Map<String, dynamic> input) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(input);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<CallToActionResponseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/cta/create',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    final value = CallToActionResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Response> ctaGetNoOfTaps(Map<String, dynamic> input) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(input);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/cta/partcipantCreate',
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
  Future<Response> deleteCTA(Map<String, dynamic> input) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(input);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/cta/deleteCTA',
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
