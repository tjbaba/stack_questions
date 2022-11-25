
import 'dart:convert';

QuestionModel questionModelFromJson(String str) => QuestionModel.fromJson(json.decode(str));


class QuestionModel {
  QuestionModel({
    required this.items,
  });

  final List<Item> items;

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );

}

class Item {
  Item({
    required this.tags,
    required this.owner,
    required this.isAnswered,
    required this.viewCount,
    required this.answerCount,
    required this.creationDate,
    required this.questionId,
    required this.title,
    required this.body,
    this.answers,
    this.score,
    this.bodyMarkdown
  });

  final List<String> tags;
  final Owner owner;
  final bool isAnswered;
  final int viewCount;
  final int answerCount;
  final int creationDate;
  final int questionId;
  final String title;
  final body, bodyMarkdown;
  final answers, score;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    tags: List<String>.from(json["tags"].map((x) => x)),
    owner: Owner.fromJson(json["owner"]),
    isAnswered: json["is_answered"],
    viewCount: json["view_count"],
    answerCount: json["answer_count"],
    creationDate: json["creation_date"],
    questionId: json["question_id"],
    title: "${json["title"]}",
    body: json['body'],
    bodyMarkdown: json['body_markdown'],
    answers: json.containsKey('answers')? List.from(json["answers"].map((x) => x)) : [],
    score: json['score']
  );
}

class Owner {
  Owner({
    required this.profileImage,
    required this.displayName,
  });

  final String profileImage;
  final String displayName;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    profileImage: "${json["profile_image"]}",
    displayName: "${json["display_name"]}",
  );

}
