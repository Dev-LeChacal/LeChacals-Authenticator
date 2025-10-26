class Account {
  final String id;
  final String name;
  final String secret;

  Account({required this.id, required this.name, required this.secret});

  Account copyWith({String? id, String? name, String? secret}) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      secret: secret ?? this.secret,
    );
  }

  Map<String, dynamic> toJson() => {"id": id, "name": name, "secret": secret};

  factory Account.fromJson(Map<String, dynamic> json) =>
      Account(id: json["id"], name: json["name"], secret: json["secret"]);
}
