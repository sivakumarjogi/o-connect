import 'package:dio/dio.dart' hide Headers;
import 'package:o_connect/core/models/create_webinar_model/selected_template_model.dart';
import 'package:retrofit/http.dart';
import '../../models/create_webinar_model/contact_groups_model/create_webinar_all_contacts.dart';
import '../../models/create_webinar_model/contact_groups_model/get_all_groups_response_model.dart';
import '../../models/create_webinar_model/create_webinar_response_model.dart';
part 'create_webinar_repo.g.dart';

@RestApi(baseUrl: "")
abstract class CreateWebinarRepository {
  factory CreateWebinarRepository(Dio dio, {String baseUrl}) = _CreateWebinarRepository;

  ///getSelectedTemplate
  @GET("/template/getAllTemplates?meeting_type=webinar")
  Future<SelectTemplateModel> getSelectedTemplate();

  @GET("/getContactsByGroupId/{groupId}")
  Future<Response> getGroupDetailsById(@Path("groupId") String groupId);

  ///getEventDetailsById
  @POST('/meeting/getEventDetailsById')
  Future<CreateWebinarResponseModel> eventDetailsById(@Body() Map<String, dynamic> data);

  ///getAllContacts
  @GET('/getAllContacts')
  Future<AllContactsResponseModel> getAllContacts();

  ///getAllGroups
  @POST('/getGroups')
  Future<GetAllGroupsModel> getAllGroupsInWebinar(@Body() Map<String, dynamic> data);

  /// createWebinar
  @POST('/meeting/create')
  Future<CreateWebinarResponseModel> createWebinarData(@Body() Map<String, dynamic> data);

  @POST('/insertURLForOConnect')
  Future<Response> generateTrimUrls(@Body() Map<String, dynamic> data);

  /// updateWebinar
  @PUT('/meeting/update')
  Future<CreateWebinarResponseModel> updateWebinarData(@Body() Map<String, dynamic> data);

  ///Send invitation
  @POST("/meeting/send-email-invitation")
  Future sendInvitation(@Body() Map<String, dynamic> data);
}
