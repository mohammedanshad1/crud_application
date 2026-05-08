class User {
  final String uid;
  final String email;
  final String? displayName;
  final DateTime? createdAt;

  User({
    required this.uid,
    required this.email,
    this.displayName,
    this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> data, String uid) {
    return User(
      uid: uid,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? uid,
    String? email,
    String? displayName,
    DateTime? createdAt,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
