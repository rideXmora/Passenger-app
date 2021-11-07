import 'package:passenger_app/modals/location.dart';
import 'package:passenger_app/utils/card_type_enum.dart';

class PlacePrediction {
  String secondaryText;
  String mainText;

  String placeId;
  Location location;

  PlacePrediction({
    required this.secondaryText,
    required this.mainText,
    required this.placeId,
    required this.location,
  });

  factory PlacePrediction.fromJson(Map<dynamic, dynamic> json) =>
      PlacePrediction(
        secondaryText: json["structured_formatting"]["secondary_text"],
        mainText: json["structured_formatting"]["main_text"],
        placeId: json["place_id"],
        location: Location(
          x: 0,
          y: 0,
        ),
      );

  String getLocationText() {
    return mainText + ", " + secondaryText;
  }
}
