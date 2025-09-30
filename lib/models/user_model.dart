import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final DateTime createdAt;
  final bool isAnonymous;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.createdAt,
    this.isAnonymous = false,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    DateTime? createdAt,
    bool? isAnonymous,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'createdAt': createdAt.toIso8601String(),
      'isAnonymous': isAnonymous,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      avatar: map['avatar'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      isAnonymous: map['isAnonymous'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, avatar: $avatar, createdAt: $createdAt, isAnonymous: $isAnonymous)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is User &&
      other.id == id &&
      other.name == name &&
      other.email == email &&
      other.avatar == avatar &&
      other.createdAt == createdAt &&
      other.isAnonymous == isAnonymous;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      avatar.hashCode ^
      createdAt.hashCode ^
      isAnonymous.hashCode;
  }
}