import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

@RestApi(baseUrl: "")
abstract class ContactsRepository {
  factory ContactsRepository(Dio dio, {String baseUrl}) = _ContactsRepository;

  @POST('/getContacts')
  Future getAllContacts(@Body() Map<String, dynamic> data);

  @POST('/saveOrUpdateContact')
  Future createContact(@Body() Object? data);

  @GET('/getCountries')
  Future getCountries();

}

class _ContactsRepository implements ContactsRepository {
  _ContactsRepository(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future getAllContacts(Map<String, dynamic> data) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data0 = <String, dynamic>{};
    data0.addAll(data);
    final result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType(Options(
      method: 'POST',
      headers: headers,
      extra: extra,
    )
            .compose(
              _dio.options,
              '/getContacts',
              queryParameters: queryParameters,
              data: data0,
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
  Future<Response<dynamic>> createContact(Object? data) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final headers = <String, dynamic>{};
    final data0 = data;
    final result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<Response<dynamic>>(Options(
      method: 'POST',
      headers: headers,
      extra: extra,
    )
            .compose(
              _dio.options,
              '/saveOrUpdateContact',
              queryParameters: queryParameters,
              data: data0,
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
  Future<Response<dynamic>> getCountries() async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    const Map<String, dynamic>? data = null;
    final result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<Response<dynamic>>(Options(
      method: 'GET',
      headers: headers,
      extra: extra,
    )
            .compose(
              _dio.options,
              '/getCountries',
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
  Future getAllStates(String countryId) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{r'Accept': 'application/json'};
    headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? data = null;
    final result =
        await _dio.fetch<Map<String, dynamic>>(_setStreamType(Options(
      method: 'GET',
      headers: headers,
      extra: extra,
    )
            .compose(
              _dio.options,
              '/getStatesByCountryId/${countryId}',
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
  Future deleteContacts(Map<String, dynamic> data) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{r'Accept': 'application/json'};
    headers.removeWhere((k, v) => v == null);
    final data0 = <String, dynamic>{};
    data0.addAll(data);
    final result =
        await _dio.fetch<Map<String, dynamic>>(_setStreamType(Options(
      method: 'POST',
      headers: headers,
      extra: extra,
    )
            .compose(
              _dio.options,
              '/moveOrRestoreContactFromTrash',
              queryParameters: queryParameters,
              data: data0,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    // final value = Response<dynamic>.fromJson(_result.data!);
    return result;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
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
