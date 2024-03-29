class TokenData{

  final String token;
  final dynamic expiry;

  const TokenData({
    required this.token,
    this.expiry = "",
  });

  factory TokenData.fromJson(Map<String, dynamic> json){
    return TokenData(
      token: json['token'],
      expiry: json['expiry'],
    );
  }
}