class Quiz{
  final String image_url;
  final String answer;
  final List choices;

  Quiz({
    required this.image_url,
    required this.answer,
    required this.choices,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      image_url:  json["image_url"],
      answer:   json["answer"],
      choices:   (json['choices'] as List).map((choice) => choice).toList() ,
    );
  }
}