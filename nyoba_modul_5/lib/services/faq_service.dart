class FAQ {
  final String id;
  final String question;
  final String answer;
  final String detail;
  final String image; 

  FAQ({
    required this.id,
    required this.question,
    required this.answer,
    required this.detail,
    required this.image, 
  });

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      detail: json['detail'],
      image: json['image'] ?? '', 
    );
  }
}
