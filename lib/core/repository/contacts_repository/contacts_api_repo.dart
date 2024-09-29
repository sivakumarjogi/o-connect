import 'package:dio/dio.dart' hide Headers;
import 'package:o_connect/core/models/response_models/get_all_groups_response_model/get_group_details_by_group_id_response_model.dart';
import 'package:o_connect/core/models/response_models/get_all_groups_response_model/permanent_delete_group_response_model.dart';
import 'package:o_connect/core/models/response_models/get_all_groups_response_model/restore_contacts_response_model.dart';
import 'package:o_connect/core/models/response_models/get_all_groups_response_model/restore_groups_response_model.dart';
import 'package:retrofit/http.dart';

import '../../models/response_models/delete_contacts_response_model/permanent_delete_contact_response_model.dart';

@RestApi(baseUrl: "")
abstract class ContactsAPIRepository {
  factory ContactsAPIRepository(Dio dio, {String baseUrl}) = _ContactsAPIRepository;

  @POST('/favoriteUnFavoriteContact')
  Future favOrUnFav(@Body() Map<String, dynamic> data);

  @POST('/getGroups')
  Future getAllGroups(@Body() Map<String, dynamic> data);

  @POST('/moveOrRestoreGroupFromTrash')
  Future<Response> deleteGroup(@Body() Map<String, dynamic> data);

  @POST('/exportContactsToCSV')
  Future<Response> uploadCSV(  @Body() Map<String, dynamic> data,);

  @POST('/saveOrUpdateGroup')
  Future createGroups(@Body() Object? data);

  @GET("/getContactsByGroupId/{groupId}")
  Future<GetGroupsDetailsByGroupIdResponseModel> viewGroup(@Path("groupId") int groupId);

  @POST('/deleteContact')
  Future<Response<dynamic>> permanentDeleteContact(@Body() Map<String, dynamic> data);

  @POST('/deleteGroup')
  Future<Response> permanentDeleteGroup(@Body() Map<String, dynamic> data);

  @POST('/moveOrRestoreContactFromTrash')
  Future<RestoreContactResponseModel> restoreContact(@Body() Map<String, dynamic> data);
// @POST('/moveOrRestoreGroupFromTrash')
// Future restoreGroup(
//     @Body() Map<String, dynamic> data);
}

class _ContactsAPIRepository implements ContactsAPIRepository {
  _ContactsAPIRepository(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<dynamic> favOrUnFav(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/favoriteUnFavoriteContact',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getAllGroups(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/getGroups',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    final value = _result.data;
    return value;
  }

  @override
  Future<Response<dynamic>> deleteGroup(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result = await _dio.fetch(_setStreamType<Response<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/moveOrRestoreGroupFromTrash',
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
  Future<Response<dynamic>> uploadCSV(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result = await _dio.fetch(_setStreamType<Response<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      responseType: ResponseType.bytes,
    )
        .compose(
          _dio.options,
          '/exportContactsToCSV',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    print("the csv data is the ${_result.data}");
    return _result;
  }

  @override
  Future<dynamic> createGroups(Object? data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = data;
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/saveOrUpdateGroup',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    final value = _result.data;
    return value;
  }

  @override
  Future<GetGroupsDetailsByGroupIdResponseModel> viewGroup(int groupId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<GetGroupsDetailsByGroupIdResponseModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/getContactsByGroupId/${groupId}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    final value = GetGroupsDetailsByGroupIdResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Response<dynamic>> permanentDeleteContact(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result = await _dio.fetch(_setStreamType<Response<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/deleteContact',
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
  Future<Response<dynamic>> permanentDeleteGroup(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/deleteGroup',
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
  Future<RestoreContactResponseModel> restoreContact(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<RestoreContactResponseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/moveOrRestoreContactFromTrash',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
    final value = RestoreContactResponseModel.fromJson(_result.data!);
    return value;
  }

  // @override
  // Future<Response<dynamic>> uploadCSV(Map<String, dynamic> data) async {
  //   const _extra = <String, dynamic>{};
  //   final queryParameters = <String, dynamic>{};
  //   final _headers = <String, dynamic>{};
  //   final _data = <String, dynamic>{};
  //   _data.addAll(data);
  //   final _result = await _dio.fetch(_setStreamType<Response<dynamic>>(Options(
  //     method: 'POST',
  //     headers: _headers,
  //     extra: _extra,
  //     responseType: ResponseType.bytes,
  //   )
  //       .compose(
  //         _dio.options,
  //         '/moveOrRestoreGroupFromTrash',
  //         queryParameters: queryParameters,
  //         data: _data,
  //       )
  //       .copyWith(
  //           baseUrl: _combineBaseUrls(
  //         _dio.options.baseUrl,
  //         baseUrl,
  //       ))));
  //   return _result;
  // }

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
