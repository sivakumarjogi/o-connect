import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:o_connect/core/service/api_helper/api_helper.dart';
import 'package:retrofit/http.dart';

@RestApi(baseUrl: "")
abstract class InvitesRepo {
  factory InvitesRepo(Dio dio, {String baseUrl}) = InvitesRepoImp;

  @POST("/invite/saveInviteInfo")
  Future<Response> sendInvite(@Body() Map<String, dynamic> input);
}

class InvitesRepoImp implements InvitesRepo {
  InvitesRepoImp(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<Response> sendInvite(Map<String, dynamic> body) async {
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
          '/invite/saveInviteInfo',
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
/*@override
  Future<Either<String, Response>> sendInvite(
      {List? emailList, List? contactList}) async {
*/ /*    Map<String, dynamic> payLoad = {
      //TODO: add meeting id
      "meeting_id": "6502a360d0d0a90008b22bb4",
      "contacts": contactList ?? [],
      "emails": emailList ?? [],
      "groups": [],
      "userInfo": {
        "userName": "kalyankumar01@qa.o-mailnow.net",
        "userEmai": "kalyankumar01@qa.o-mailnow.net",
        "name": "Kalyan Kumar"
      }
    };*/ /*

    final res = await apiHelper.oConnectPost(
        endPoint: "/devNew/invite/saveInviteInfo",
        bodyData: payLoad,
        baseUrl: baseUrl);

    return res.fold((failure) {
      print("the right called ");
      return Left(failure);
    }, (data) {
      print("the Lest called ");
      return Right(data);
    });
  }*/
}
