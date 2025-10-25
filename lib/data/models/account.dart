class Account {
  final String id;
  final String name;
  final String secret;

  Account({required this.id, required this.name, required this.secret});

  Map<String, dynamic> toJson() => {"id": id, "name": name, "secret": secret};

  factory Account.fromJson(Map<String, dynamic> json) =>
      Account(id: json["id"], name: json["name"], secret: json["secret"]);
}
