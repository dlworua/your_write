// lib/ui/pages/random/random_write/random_write_state.dart

class RandomWriteState {
  final String title;
  final String author;
  final String content;
  final List<String> keywords;

  const RandomWriteState({
    required this.title,
    required this.author,
    required this.content,
    required this.keywords,
  });

  factory RandomWriteState.initial() {
    return const RandomWriteState(
      title: '',
      author: '',
      content: '',
      keywords: [],
    );
  }

  RandomWriteState copyWith({
    String? title,
    String? author,
    String? content,
    List<String>? keywords,
  }) {
    return RandomWriteState(
      title: title ?? this.title,
      author: author ?? this.author,
      content: content ?? this.content,
      keywords: keywords ?? this.keywords,
    );
  }
}
