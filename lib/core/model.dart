class Model {
  final String arThekr;
  final String enThekr;
  final String arThekrMean;
  final String enThekrMean;
  final int reps;
  final String groupName;

  Model({
    required this.groupName,
    required this.arThekr,
    required this.arThekrMean,
    required this.enThekr,
    required this.enThekrMean,
    required this.reps,
  });

  // Create an instance from a JSON map
  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      groupName: json['GroupName'] ?? '',
      arThekr: json['arThekr'] ?? '',
      arThekrMean: json['arThekrMean'] ?? '',
      enThekr: json['enThekr'] ?? '',
      enThekrMean: json['enThekrMean'] ?? '',
      reps: json['reps'] ?? 0,
    );
  }

  // Convert an instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'GroupName': groupName,
      'arThekr': arThekr,
      'arThekrMean': arThekrMean,
      'enThekr': enThekr,
      'enThekrMean': enThekrMean,
      'reps': reps,
    };
  }

  // Create a modified copy of the current object safely
  Model copyWith({
    String? groupName,
    String? arThekr,
    String? arThekrMean,
    String? enThekr,
    String? enThekrMean,
    int? reps,
  }) {
    return Model(
      groupName: groupName ?? this.groupName,
      arThekr: arThekr ?? this.arThekr,
      arThekrMean: arThekrMean ?? this.arThekrMean,
      enThekr: enThekr ?? this.enThekr,
      enThekrMean: enThekrMean ?? this.enThekrMean,
      reps: reps ?? this.reps,
    );
  }

  // Value equality — needed so indexOf() works correctly in the library screen
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Model &&
          runtimeType == other.runtimeType &&
          arThekr == other.arThekr &&
          enThekr == other.enThekr &&
          arThekrMean == other.arThekrMean &&
          enThekrMean == other.enThekrMean &&
          reps == other.reps &&
          groupName == other.groupName;

  @override
  int get hashCode => Object.hash(
        arThekr,
        enThekr,
        arThekrMean,
        enThekrMean,
        reps,
        groupName,
      );
}