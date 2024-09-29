import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';

import '../../models/calender_model/day_model.dart';
part 'calender_api_repo.g.dart';

@RestApi(baseUrl: "")
abstract class CalenderApiRepository {
  factory CalenderApiRepository(Dio dio, {String baseUrl}) =
      _CalenderApiRepository;

  ///calender details
  @POST('/calendar')
  // @Headers(ApiHelper.basicHeader)
  Future<CalenderDayModel> dayCalender(@Body() Map<String, dynamic> data);
}
