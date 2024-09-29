

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../utils/base_urls.dart';



@RestApi(baseUrl: "")
abstract class TemplateRepository {
  factory TemplateRepository(Dio dio, {String baseUrl}) = _TemplateRepository;

  /// create template
  @POST(BaseUrls.createTemplate)
  Future createTemplate(@Body() Map<String, dynamic> body);

}


class _TemplateRepository implements TemplateRepository {
  _TemplateRepository(
      this._dio, {
        this.baseUrl,
      });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<dynamic> createTemplate(Map<String, dynamic> body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
      _dio.options,
      '/template/create',
      queryParameters: queryParameters,
      data: _data,
    )
        .copyWith(
        baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    // final value = _result.data;
    return _result;
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
