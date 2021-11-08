import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passenger_app/pages/home/map_screens/widgets/smooth_star_rating.dart';
import 'package:passenger_app/theme/colors.dart';
import 'package:passenger_app/widgets/secondary_button.dart';

class RateAndComment extends StatelessWidget {
  RateAndComment({
    Key? key,
    this.onPressed,
    this.onCancel,
    required this.rating,
    this.onRatingChanged1,
    this.onRatingChanged2,
    this.onRatingChanged3,
    this.onRatingChanged4,
    this.onRatingChanged5,
    required this.comment,
    required this.loadingGreen,
    required this.loadingRed,
    required this.greenTopic,
    required this.redTopic,
    required this.complain,
    required this.onComplain,
  }) : super(key: key);
  final onRatingChanged1;
  final onRatingChanged2;
  final onRatingChanged3;
  final onRatingChanged4;
  final onRatingChanged5;
  final onPressed;
  final onCancel;
  final int rating;
  final TextEditingController comment;
  final bool loadingGreen;
  final bool loadingRed;
  final String greenTopic;
  final String redTopic;
  final bool complain;
  final onComplain;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: primaryColorDark,
                  borderRadius: BorderRadius.all(Radius.circular(17)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: primaryColorDark,
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 28,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Rate and comment",
                        style: TextStyle(
                          color: primaryColorBlack,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Rate your driver",
                      style: TextStyle(
                        color: primaryColorBlack,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SmoothStarRating(
                        rating: rating,
                        starCount: 5,
                        onRatingChanged1: onRatingChanged1,
                        onRatingChanged2: onRatingChanged2,
                        onRatingChanged3: onRatingChanged3,
                        onRatingChanged4: onRatingChanged4,
                        onRatingChanged5: onRatingChanged5,
                      ),
                    ),
                    Text(
                      "Comment about your rider",
                      style: TextStyle(
                        color: primaryColorBlack,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 5,
                        top: 10,
                        bottom: 5,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          color: primaryColorWhite,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            style: TextStyle(
                              color: primaryColorDark,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            controller: comment,
                            minLines: 1,
                            maxLines: 2,
                            keyboardType: TextInputType.multiline,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type your comment here ....",
                              hintStyle: TextStyle(
                                color: primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: complain,
                          onChanged: onComplain,
                          activeColor: primaryColor,
                        ),
                        Text(
                          "Make a complain?",
                          style: TextStyle(
                            color: primaryColorBlack,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 10,
                          child: SecondaryButton(
                            width: MediaQuery.of(context).size.width * 0.4,
                            onPressed: onPressed,
                            loading: loadingGreen,
                            text: greenTopic,
                            boxColor: primaryColorLight,
                            shadowColor: Colors.transparent,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 10,
                          child: SecondaryButton(
                            width: MediaQuery.of(context).size.width * 0.4,
                            onPressed: onCancel,
                            loading: loadingRed,
                            text: redTopic,
                            boxColor: Color(0xFFD7A7A7),
                            shadowColor: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
