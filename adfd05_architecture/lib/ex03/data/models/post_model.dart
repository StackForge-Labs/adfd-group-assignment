import '../../domain/entities/post_entity.dart';

class PostModel {
  final int? id;
  final String title;
  final String content;
  final int isLike;

  PostModel({
    this.id,
    required this.title,
    required this.content,
    this.isLike = 0,
  });

  // Flow 3 - PostModel → PostEntity.
  PostEntity toEntity() {
    return PostEntity(
      id: id,
      title: title,
      content: content,
      isLike: isLike == 1,
    );
  }

  // Flow 3 - PostEntity → PostModel.
  factory PostModel.fromEntity(PostEntity entity) {
    return PostModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      isLike: entity.isLike ? 1 : 0,
    );
  }
}

/*
FLOW

	PostModel
		↕
	Mapping
		↕
	PostEntity

	isLike
		PostModel  → int
		PostEntity → bool
*/
