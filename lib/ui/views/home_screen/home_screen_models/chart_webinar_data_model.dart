class ChartWebinarData {
  ChartWebinarData(
      this.monthName, this.numberOfWebinars, this.numberOfParticipants);
   String monthName;
   int numberOfWebinars;
   int numberOfParticipants;
}


class ChartPollData {
  ChartPollData({
    required this.question,
    required this.options,
  });
  String question;
  int options;
}
/*
List<ChartPollData> pollChatData = [
  ChartPollData(question: "nckjn",options: 2),
  ChartPollData(question: "skjnskc",options: 3),
  ChartPollData(question: "skcjjbj",options: 10)
];*/
