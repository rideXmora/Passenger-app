// Driver OneServiceFromJson(String str) =>
//     Driver.fromJson(json.decode(str));

// String OneServiceToJson(OneService data) => json.encode(data.toJson());

//chnaged
// image: json["image"],
//       name: json["name"],
//       number: json["number"],
//       rating: json["rating"],
class Passenger {
  Passenger({
    required this.id,
    required this.phone,
    required this.email,
    required this.name,
    required this.totalRating,
    required this.totalRides,
    required this.pastRides,
    required this.token,
    required this.refreshToken,
    required this.enabled,
    required this.suspend,
    required this.notificationToken,
  });

  String id;
  String phone;
  String email;
  String name;
  int totalRating;
  int totalRides;
  List<String> pastRides;
  String token;
  String refreshToken;
  bool enabled;
  bool suspend;
  String notificationToken;

  factory Passenger.fromJson(Map<dynamic, dynamic> json) => Passenger(
        id: json["id"],
        phone: json["phone"],
        email: json["email"],
        name: json["name"],
        totalRating: json["totalRating"],
        totalRides: json["totalRides"],
        pastRides: json["pastRides"],
        token: json["token"],
        refreshToken: json["refreshToken"],
        enabled: json["enabled"],
        suspend: json["suspend"],
        notificationToken: json["notificationToken"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
        "email": email,
        "name": name,
        "totalRating": totalRating,
        "totalRides": totalRides,
        "pastRides": pastRides,
        "token": token,
        "refreshToken": refreshToken,
        "enabled": enabled,
        "suspend": suspend,
        "notificationToken": notificationToken,
      };
}
