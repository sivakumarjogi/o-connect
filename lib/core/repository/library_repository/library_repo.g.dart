// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_repo.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _LibraryRepository implements LibraryRepository {
  _LibraryRepository(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<LibraryMeetingHistoryModel> meetingHistory(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<LibraryMeetingHistoryModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/file-info/list',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    final value = LibraryMeetingHistoryModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LibraryCompletedFilesModel> getCompletedItemDetails(String meetingId, int userId, Map<String, dynamic> headers) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'meeting_id': meetingId,
      r'user_id': userId,
    };
    final _headers = headers;
    final _data = <String, dynamic>{};

    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<LibraryCompletedFilesModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/file-info/archivesBymeetingId?',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    final value = LibraryCompletedFilesModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AllTemplatesModel> fetchAllTemplates(
    int currentPage,
    int itemPerPage,
    String searchText,
    String fromDate,
    String toDate,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'currentPage': currentPage,
      r'ItemsPerPage': itemPerPage,
      r'searchText': searchText,
      r'fromDate': fromDate,
      r'toDate': toDate,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<AllTemplatesModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/template/getAllTemplates/?',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));

    final value = AllTemplatesModel.fromJson(_result.data!);
    print("jdfjfdkhghghg ${_result.data}");

    return value;
  }

  @override
  Future<LibraryFilesModel> fetchPresentation(
    String meetingID,
    String purpose,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'meeting_id': meetingID,
      r'purpose': purpose,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<LibraryFilesModel>(Options(
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
    final value = LibraryFilesModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LibraryFilesModel> fetchLibraryData(int userId, String purpose, {String? folderName, String? type}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'user_id': userId,
      r'purpose': purpose,
      if (folderName != null && folderName.isNotEmpty) r'folderName': folderName,
      if (type != null && type.isNotEmpty) r'type': type,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<LibraryItem>(Options(
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
    final value = LibraryFilesModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Response<dynamic>> deleteFile(String itemId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Response<dynamic>>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/file-info/delete/${itemId}',
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
  Future<PresentationDeleteItemModel> deletePresentationItem(String postId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<PresentationDeleteItemModel>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/file-info/delete/${postId}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    final value = PresentationDeleteItemModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UpdateTemplateModel> updateTemplateName(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<UpdateTemplateModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/template/updateTemplate',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    final value = UpdateTemplateModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UpdateTemplateModel> deleteTemplate(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<UpdateTemplateModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/template/deleteTemplate',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    final value = UpdateTemplateModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Response> deleteVideoShareVideoFile(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<LibraryMeetingHistoryModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/file-info/delete',
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
