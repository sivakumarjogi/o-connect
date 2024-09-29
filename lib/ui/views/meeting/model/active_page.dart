enum ActivePage {
  presentation("Presentation"),
  poll("Poll"),
  qna("Q&A"),
  videoPlayer("VideoPlayer"),
  whiteboard("Whiteboard"),
  audioVideo("AV");

  const ActivePage(this.title);

  final String title;
}
