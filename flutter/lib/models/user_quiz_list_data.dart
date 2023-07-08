class UserQuizListData{
  final int id;
  final int userId;
  late String name;
  late List<int> signIDs;
  late DateTime lastPracticedDate;
  late int lastPracticedIndex;

  UserQuizListData({required this.id, required this.userId, required this.name, required this.signIDs, required this.lastPracticedDate, required this.lastPracticedIndex});

  factory UserQuizListData.fromJson(Map<String, dynamic> json) {
    return UserQuizListData(
      id: json['id'],
      userId: json['user'],
      name: json['name'],
      signIDs: List<int>.from(json['sign_ids']),
      lastPracticedDate: DateTime.parse(json['last_practiced']),
      lastPracticedIndex: json['last_sign_index'],
    );
  }

  static List<UserQuizListData> listFromJson(List<dynamic> json) {
    return json
        .map((data) => UserQuizListData.fromJson(data as Map<String, dynamic>))
        .toList()
        .cast<UserQuizListData>();
  }

  Map<String, dynamic> toJson() => {
    'user': userId,
    'name': name,
    'sign_ids': signIDs,
    'last_practiced': lastPracticedDate.toString(),
    'last_sign_index': lastPracticedIndex,
  };
}