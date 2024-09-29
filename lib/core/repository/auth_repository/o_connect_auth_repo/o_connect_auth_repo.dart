import 'package:dio/dio.dart' hide Headers;
import 'package:o_connect/core/models/auth_models/generate_token_model.dart';
import 'package:o_connect/core/models/auth_models/generate_token_o_connect_model.dart';
import 'package:retrofit/http.dart';

@RestApi(baseUrl: "")
abstract class OConnectAuthRepo {
  factory OConnectAuthRepo(Dio dio, {String baseUrl}) = _OConnectAuthRepo;

  @POST('/user/generate-random-token')
  Future<GenerateTokenModel> generateRandomToken(@Headers() oConnectAuthHeader);
  @POST('/user/generate-token-oconnect')
  Future<GenerateTokenOConnectModel> generateRandomOConnectToken(@Headers() Map<String, dynamic> oConnectAuthHeader, @Body() Map<String, dynamic> data);

  @POST('/user/refresh-token')
  Future<Response> refreshOconnectToken(@Headers() Map<String, dynamic> oConnectAuthHeader, @Body() Map<String, dynamic> data);
}

class _OConnectAuthRepo implements OConnectAuthRepo {
  _OConnectAuthRepo(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;
  String? baseUrl;

  @override
  Future<GenerateTokenModel> generateRandomToken(dynamic oConnectAuthHeader) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = oConnectAuthHeader;
    const Map<String, dynamic>? data = null;

    final result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<GenerateTokenModel>(Options(
      method: 'POST',
      headers: headers,
      extra: extra,
    )
        .compose(
          _dio.options,
          '/user/generate-random-token',
          queryParameters: queryParameters,
          data: data,
        )
        .copyWith(baseUrl: baseUrl)));
    print("internal error${result.data!}");
    final value = GenerateTokenModel.fromJson(result.data!);
    return value;
  }

  @override
  Future<GenerateTokenOConnectModel> generateRandomOConnectToken(dynamic oConnectAuthHeader, Map<String, dynamic> bodyData) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = oConnectAuthHeader;
    final data = bodyData;
    final result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<GenerateTokenOConnectModel>(Options(
      method: 'POST',
      headers: headers,
      extra: extra,
    )
        .compose(
          _dio.options,
          '/user/generate-token-oconnect',
          queryParameters: queryParameters,
          data: data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    print("user derails in for login time ${result.data.toString()}");
    final value = GenerateTokenOConnectModel.fromJson(result.data!);
    return value;
  }

  @override
  Future<Response> refreshOconnectToken(dynamic oConnectAuthHeader, Map<String, dynamic> bodyData) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = oConnectAuthHeader;
    final data = bodyData;
    final result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response>(Options(
      method: 'POST',
      headers: headers,
      extra: extra,
    )
        .compose(
          _dio.options,
          '/user/refresh-token',
          queryParameters: queryParameters,
          data: data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    print("the refresh tkn response is the ${result.data.toString()} ");
    return result;
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
