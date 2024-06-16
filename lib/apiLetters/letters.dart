class Letters {
  List<String> _letters;

  Letters({
    required List<String> letters,
  }) :
        _letters = letters?? [];

  factory Letters.fromJson(dynamic json) {
    return Letters(
      letters: json['letters']!= null? json['letters'].cast<String>() : [],
    );
  }

  Letters copyWith({
    required List<String> letters,
  }) =>
      Letters(
        letters: letters?? _letters,
      );

  List<String> get letters => _letters;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['letters'] = _letters;
    return map;
  }
}
