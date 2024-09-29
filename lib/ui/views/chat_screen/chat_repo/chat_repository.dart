import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../../utils/base_urls.dart';
import '../chat_model/chat_model.dart';

part 'chat_repository.g.dart';

@RestApi(baseUrl: "")
abstract class ChatApiRepository {
  factory ChatApiRepository(Dio dio, {String baseUrl}) = _ChatApiRepository;

  /// create chat  Meetings
  @POST(BaseUrls.createChat)
  Future createChat(
    @Body() Map<String, dynamic> body,
  );

  ///save chat data
  @POST(BaseUrls.exportChat)
  Future saveChatData(
    @Body() Map<String, dynamic> body,
  );

  /// set question And Ans
  @POST(BaseUrls.questionAndAnsSet)
  Future questionAndAnsSet(
    @Body() Map<String, dynamic> body,
  );

  /// update chat  Meetings
  @POST(BaseUrls.updateChat)
  Future updateChat(
    @Body() Map<String, dynamic> body,
  );

  /// Chat History data
  @GET(BaseUrls.chatHistory)
  Future getChatHistory(
    @Query("meeting_id") String meetingId,
    @Query("type") String type,
    @Query("from_user_id") String fromUserId,
  );

  /// Update Chat Status
  @POST(BaseUrls.updateChatStatus)
  Future updateChatStatus(
    @Body() Map<String, dynamic> body,
  );

  /// Delete Chat Message
  @POST(BaseUrls.deleteChatMessage)
  Future deleteChatMessage(
    @Body() Map<String, dynamic> body,
  );

  /// Chat History data
  @GET(BaseUrls.privateChatHistory)
  Future getPrivateChatHistory(
      @Query("to_user_id") String toUserId,
      @Query("meeting_id") String meetingId,
    @Query("from_user_id") String fromUserId ,
  );

  /// Get Chat Counts By User
  @GET(BaseUrls.getChatCountsByMeetingId)
  Future getChatCountsByMeetingId(
    @Query("meeting_id") String meetingId,
    @Query("to_user") String toUserId,
    @Query("type") String fromUserId,
  );
}
