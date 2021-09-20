import 'package:passenger_app/pages/card_type.dart';

class CreditCard {
  String cardNumber;
  CardType cardType;
  String cardTypeString;
  String cardExpiry;
  String cardHolderName;
  String cardID;

  CreditCard({
    required this.cardNumber,
    required this.cardExpiry,
    required this.cardHolderName,
    required this.cardType,
    required this.cardTypeString,
    required this.cardID,
  });
}
