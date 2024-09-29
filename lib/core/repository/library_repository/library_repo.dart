import 'package:dio/dio.dart' hide Headers;
import 'package:o_connect/ui/views/drawer/library_revamp/model/library_completed_files.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/model/library_files_model.dart';
import 'package:retrofit/http.dart';

import '../../models/library_model/all_templates_model.dart';
import '../../models/library_model/library_meeting_history_model.dart';
import '../../models/library_model/presentation_delete_item.dart';
import '../../models/library_model/update_template_model.dart';

part 'library_repo.g.dart';

@RestApi(baseUrl: "")
abstract class LibraryRepository {
  factory LibraryRepository(Dio dio, {String baseUrl}) = _LibraryRepository;

  /// library meeting history
  @POST('/file-info/list')
  Future<LibraryMeetingHistoryModel> meetingHistory(@Body() Map<String, dynamic> data);

  ///getTemplatesList
  @GET("/template/getAllTemplates/?")
  Future<AllTemplatesModel> fetchAllTemplates(
      @Query("currentPage") int currentPage, @Query("ItemsPerPage") int itemPerPage, @Query("searchText") String searchText, @Query("fromDate") String fromDate, @Query("toDate") String toDate);

  ///presentation
  @GET("/file-info/getFiles?")
  Future<LibraryFilesModel> fetchPresentation(@Query("meeting_id") String meetingID, @Query("purpose") String purpose);

  @GET("/file-info/archivesBymeetingId?")
  Future<LibraryCompletedFilesModel> getCompletedItemDetails(@Query("meeting_id") String meetingID, @Query("user_id") int userId, @Headers() Map<String, dynamic> headers);

  @GET("/file-info/getFiles?")
  Future<LibraryFilesModel> fetchLibraryData(@Query("user_id") int userId, @Query("purpose") String purpose, {@Query("folderName") String? folderName, @Query("type") String? type});

  // https://xend0l50h4.execute-api.ap-south-1.amazonaws.com/devNew/file-info/delete/650ae6ecbc710500081e3115

  ///getIndividualItemDetails
  @DELETE("/file-info/delete/{itemId}")
  Future<Response> deleteFile(@Path("itemId") String itemId);

  ///Delete presentation
  @DELETE("/file-info/delete/{id}")
  Future<PresentationDeleteItemModel> deletePresentationItem(@Path("id") String postId);

  @POST('/file-info/delete')
  Future<Response> deleteVideoShareVideoFile(@Body() Map<String, dynamic> data);

  // ///presentation Uploading files
  // @POST("/file-info/uploadFiles")
  // @MultiPart()
  // Future<Response> uploadFiles(@Path() FormData formData);

  ///update template (Edit)
  @POST("/template/updateTemplate")
  Future<UpdateTemplateModel> updateTemplateName(
    @Body() Map<String, dynamic> data,
  );

  ///Delete template (Delete)
  @POST("/template/deleteTemplate")
  Future<UpdateTemplateModel> deleteTemplate(@Body() Map<String, dynamic> data);
}
