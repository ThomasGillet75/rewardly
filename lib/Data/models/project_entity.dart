class Project {
  String id;
  String name;
  String reward;

  Project({
    required this.name,
    required this.id,
    this.reward = "",
  });

  Project copyWith({
    String? name,
    String? id,
    String? reward,
  }) {
    return Project(
      name: name ?? this.name,
      id: id ?? this.id,
      reward: reward ?? this.reward,
    );
  }
}
