class BaseUrls {
  ///hello "BASE_URL": "https://obsapi-qa.onpassive.com",
  //   "tokenGenerateBaseUrl": "https://b5ukn0u36k.execute-api.ap-south-1.amazonaws.com/qaold",
  //   "meetingBaseUrl": "https://ku5cjrot7d.execute-api.ap-south-1.amazonaws.com/qaold",
  //   "templateBaseUrl": "https://qwk0dxowjc.execute-api.ap-south-1.amazonaws.com/qaold",
  //   "bgmBaseUrl": "https://87c2ho7a9a.execute-api.ap-south-1.amazonaws.com/qaold",
  //   "chatBaseUrl": "https://qybuur0er0.execute-api.ap-south-1.amazonaws.com/qaold",
  //   "libraryBaseUrl": "https://zgfij2c851.execute-api.ap-south-1.amazonaws.com/qaold",
  //   "globalAccessStatusSetUrl": "https://mn3u233yv8.execute-api.ap-south-1.amazonaws.com/qaold",
  //   "panelCountUrl": "https://b18xwd2jah.execute-api.ap-south-1.amazonaws.com/qaold",
  //   "globalAccessSetUrl": "https://najit89cy5.execute-api.ap-south-1.amazonaws.com/qaold",
  //   "pollBaseUrl": "https://3t6ad2zdp1.execute-api.ap-south-1.amazonaws.com/qaold",
  //   "trimUrlsBaseUrl": "https://trimurlqa.onpassive.com",
  //   "hubSocketUrl": "https://hub-qa.onpassive.com/",
  //   "meetingRoomSocketUrl": "https://rms-qa.onpassive.com/",
  //   "chatSocketUrl": "https://chat-qa.onpassive.com/",
  //   "baseOriginUrl": "https://oconnectqa-ui.onpassive.com",
  //   "whiteBoardSocketUrl": "https://wb-dev.onpassive.com/",

  static const String baseUrl = "https://obsapi-qa.onpassive.com";
  static const String tokenGenerateBaseUrl = "https://b5ukn0u36k.execute-api.ap-south-1.amazonaws.com/qaold";
  static const String meetingBaseUrl = "https://ku5cjrot7d.execute-api.ap-south-1.amazonaws.com/qaold";
  static const String templateBaseUrl = "https://qwk0dxowjc.execute-api.ap-south-1.amazonaws.com/qaold";
  static const String bgmBaseUrl = "https://87c2ho7a9a.execute-api.ap-south-1.amazonaws.com/qaold";
  static const String chatBaseUrl = "https://qybuur0er0.execute-api.ap-south-1.amazonaws.com/qaold";
  static const String libraryBaseUrl = "https://zgfij2c851.execute-api.ap-south-1.amazonaws.com/qaold";
  static const String webinarCopyLinkBaseUrl = "https://obs-qa.onpassive.com";
  static const String redirectRegisterUrl = "https://obs-qa.onpassive.com/auth";
  static const String getMeetingCountUrl = "https://5be2nwr5cd.execute-api.ap-south-1.amazonaws.com/qaold";

  /// global-access/status/set
  static const String globalAccessStatusSetUrl = "https://mn3u233yv8.execute-api.ap-south-1.amazonaws.com/qaold";
  static const String panelCountUrl = "https://b18xwd2jah.execute-api.ap-south-1.amazonaws.com/qaold";

  /// global-access/set
  static const String globalAccessSetUrl = "https://najit89cy5.execute-api.ap-south-1.amazonaws.com/qaold";
  static const String pollBaseUrl = "https://3t6ad2zdp1.execute-api.ap-south-1.amazonaws.com/qaold";
  static const String trimUrlsBaseUrl = "https://trimurlqa.onpassive.com";
  static const String imageUrl = "https://de4nfar4wtruu.cloudfront.net/";
  static const oMailEndTag = "@qa.o-mailnow.net";
  static const meetingCountUrl = "https://5n968gg6m8.execute-api.ap-south-1.amazonaws.com/qaold/meeting-restriction/";
  static const refreshAuthorization = "https://b5ukn0u36k.execute-api.ap-south-1.amazonaws.com/qaold";
  static const videoStreamUrl = "https://wbnr-qa.onpassive.com/LiveApp/streams/";


  /// sockets
  static const String hubSocketUrl = "https://hub-qa.onpassive.com/";
  static const String meetingRoomSocketUrl = "https://rms-qa.onpassive.com/";
  static const String chatSocketUrl = "https://chat-qa.onpassive.com/";
  static const String baseOriginUrl = "https://oconnectqa-ui.onpassive.com";
  static const String whiteBoardDevSocketUrl = "https://wb-dev.onpassive.com/";
  static const String whiteBoardQaSocketUrl = "https://wb-qa.onpassive.com/";
  static const String getDefaultDataUrl = "https://i0bdjxf7m4.execute-api.ap-south-1.amazonaws.com/qaold/userData/get";
  static const String addDefaultDataUrl = "https://i0bdjxf7m4.execute-api.ap-south-1.amazonaws.com/qaold/userData/add";
  static const String flavor = "qa";
  static const String meetingRequests = "https://5be2nwr5cd.execute-api.ap-south-1.amazonaws.com/qaold";
  static const String savedTemplate = "https://qwk0dxowjc.execute-api.ap-south-1.amazonaws.com/qaold";

  /// Notification or Invite Meetings
  static const String inviteGetMeeting = "/userData/invited-meetings";
  static const String inviteUpDateMeeting = "/userData/update-invite-status";

  /// chat base urls
  static const String createChat = "/chat/create";
  static const String updateChat = "/chat/update";
  static const String exportChat = "/chat/exportChat";
  static const String chatHistory = "/chat/getChatHistory";
  static const String privateChatHistory = "/chat/getPrivateChatById";
  static const String updateChatStatus = "/chat/private/updateChatStatus";
  static const String getChatCountsByMeetingId = "/chat/getChatCountsByMeetingId";
  static const String deleteChatMessage = "/chat/delete";
  static const String questionAndAnsSet = "/global-access/set";

  /// Meeting Api`s End Points
  static const String getAllMeetingInfo = "/meeting/getEventsCountsByUserId";
  static const String getAllMeetingCount = "/userData/update-invitedMeetingsCount";
  static const String getMeetings = "/meeting/filteredEvents";
  static const String getMeetingRequests = "/meeting/filteredEvents";
  static const String getInviteMeetings = "/userData/invited-meetings";
  static const String deleteMeeting = "/meeting/delete";
  static const String transferMeeting = "/meeting/assignMeetingTo";

  static const String deletePastMeeting = "/meeting/deleteInPast";
  static const String getMeetingStatistics = "/meeting/getCustomEventsCount/";
  static const String joinMeetingByIdEndPoint = '/meeting/joinMeeting';

  /// Templates Api`s End Points
  static const String createTemplate = "/template/create";

  /// Library Api`s End Points
  static const String getMeetingHistory = "/file-info/list";

  /// Themes Api`s End Points
  static const String getBackGroundMusic = "/features/getAllBgms";

//profile pic
  static const String updateProfile = "/uploadProfilePic";
  static const String deleteProfilePic = "/delete-profile-picture";
}




   /// preprod urls
// class BaseUrls {
//
//
//   static const String baseUrl = "https://obsapi-sg.onpassive.com";
//     static const String redirectRegisterUrl = "https://ecosystem-tsg.onpassive.com/auth";
//
//   // static const String baseUrl = "https://ecosystem-tsg.onpassive.com";
//   static const String tokenGenerateBaseUrl = "https://ocmr-ppuserservicesql.oconnect.ai";
//   static const String meetingBaseUrl = "https://ocmr-ppmeeting.oconnect.ai";
//   static const String templateBaseUrl = "https://ocmr-pptemplate.oconnect.ai";
//   static const String bgmBaseUrl = "https://ocmr-ppfeatures.oconnect.ai";
//   static const String chatBaseUrl = "https://ocmr-ppchat.oconnect.ai";
//   static const String libraryBaseUrl = "https://ocmr-ppwebinarlist.oconnect.ai";
//   static const String webinarCopyLinkBaseUrl = "https://ecosystem-tsg.onpassive.com";
//   static const String getMeetingCountUrl = "https://ocmr-ppuserspecific.oconnect.ai";
//
//   /// global-access/status/set
//   static const String globalAccessStatusSetUrl = "https://ocmr-ppglobalaccesscontrol.oconnect.ai";
//   static const String panelCountUrl = "https://b18xwd2jah.execute-api.ap-south-1.amazonaws.com/qaold";
//
//
//   /// global-access/set
//   static const String globalAccessSetUrl = "https://ocmr-ppglobalservice.oconnect.ai";
//   static const String pollBaseUrl = "https://ocmr-ppsurveyservice.oconnect.ai";
//   static const String trimUrlsBaseUrl = "https://otrimapi-sg.onpassive.com";
//   static const String imageUrl = "https://de4nfar4wtruu.cloudfront.net/";
//   static const oMailEndTag = "@sg.o-mailnow.net";
//   static const meetingCountUrl = "https://ocmr-ppmeetingrestriction.oconnect.ai/meeting-restriction/";
//   static const refreshAuthorization = "https://ocmr-ppuserservicesql.oconnect.ai";
//
//
//   /// sockets
//   static const String hubSocketUrl = "https://hub-pp.onpassive.com/";
//   static const String meetingRoomSocketUrl = "https://rms-pp.onpassive.com/";
//   static const String chatSocketUrl = "https://mrchat-pp.oconnect.ai/";
//   static const String baseOriginUrl = "https://oconnectui-pp.onpassive.com";
//   static const String whiteBoardQaSocketUrl = "https://wb-pp.onpassive.com/";
//   static const String getDefaultDataUrl = "https://ocmr-ppuserspecific.oconnect.ai/userData/get";
//   static const String addDefaultDataUrl = "https://i0bdjxf7m4.execute-api.ap-south-1.amazonaws.com/qaold/userData/add";
//   static const String flavor = "pp";
//   static const String meetingRequests = "https://ocmr-ppuserspecific.oconnect.ai";
//   static const String savedTemplate = "https://ocmr-pptemplate.oconnect.ai";
//   static const String videoStreamUrl = "https://wbnr-pp.onpassive.com/LiveApp/streams/";
//
//
//   /// End points
//
//
//   ///video stream end point
//   static const String videoStreamEndPoint = "https://wbnr-pp.onpassive.com";
//
//   /// Notification or Invite Meetings
//   static const String inviteGetMeeting = "/userData/invited-meetings";
//   static const String inviteUpDateMeeting = "/userData/update-invite-status";
//
//   /// chat base urls
//   static const String createChat = "/chat/create";
//   static const String updateChat = "/chat/update";
//   static const String exportChat = "/chat/exportChat";
//   static const String chatHistory = "/chat/getChatHistory";
//   static const String privateChatHistory = "/chat/getPrivateChatById";
//   static const String updateChatStatus = "/chat/private/updateChatStatus";
//   static const String getChatCountsByMeetingId = "/chat/getChatCountsByMeetingId";
//   static const String deleteChatMessage = "/chat/delete";
//   static const String questionAndAnsSet = "/global-access/set";
//
//   /// Meeting Api`s End Points
//   static const String getAllMeetingInfo = "/meeting/getEventsCountsByUserId";
//   static const String getAllMeetingCount = "/userData/update-invitedMeetingsCount";
//   static const String getMeetings = "/meeting/filteredEvents";
//   static const String getMeetingRequests = "/meeting/filteredEvents";
//   static const String getInviteMeetings = "/userData/invited-meetings";
//   static const String deleteMeeting = "/meeting/delete";
//   static const String transferMeeting = "/meeting/assignMeetingTo";
//
//   static const String deletePastMeeting = "/meeting/deleteInPast";
//   static const String getMeetingStatistics = "/meeting/getCustomEventsCount/";
//   static const String joinMeetingByIdEndPoint = '/meeting/joinMeeting';
//
//   /// Templates Api`s End Points
//   static const String createTemplate = "/template/create";
//
//   /// Library Api`s End Points
//   static const String getMeetingHistory = "/file-info/list";
//
//   /// Themes Api`s End Points
//   static const String getBackGroundMusic = "/features/getAllBgms";
//
// //profile pic
//   static const String updateProfile = "/uploadProfilePic";
//   static const String deleteProfilePic = "/delete-profile-picture";
// }
