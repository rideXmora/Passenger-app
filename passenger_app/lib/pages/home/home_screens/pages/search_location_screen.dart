import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passenger_app/api/utils.dart';
import 'package:passenger_app/controllers/map_controller.dart';
import 'package:passenger_app/theme/colors.dart';
import 'package:passenger_app/widgets/custom_text_field.dart';
import 'package:passenger_app/widgets/previous_location.dart';
import 'package:passenger_app/widgets/secondary_button_with_icon.dart';

class SearchLocationScreen extends StatefulWidget {
  SearchLocationScreen({Key? key, required this.onBack, required this.toMap})
      : super(key: key);
  final onBack;
  final toMap;
  @override
  _SearchLocationScreenState createState() => _SearchLocationScreenState();
}

TextEditingController startController = TextEditingController();
TextEditingController endController = TextEditingController();
MapController mapController = Get.find<MapController>();
bool startChanging = false;
bool endChanging = false;

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primaryColorWhite,
      appBar: AppBar(
        backgroundColor: primaryColorWhite,
        title: Text(
          "Search Location",
          style: TextStyle(
            color: primaryColorBlack,
            fontSize: 23,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: widget.onBack,
          child: Icon(
            Icons.keyboard_arrow_left_sharp,
            size: 30,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 17),
              child: Row(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 18,
                      ),
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: primaryColorDark,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 4,
                        height: 54,
                        color: primaryColorDark,
                      ),
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: primaryColorDark,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 27),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 18,
                          ),
                          CustomTextField(
                            readOnly: false,
                            height: height,
                            width: width,
                            controller: startController,
                            hintText: "Current location",
                            prefixBoxColor: primaryColorBlack,
                            prefixIcon: Icon(
                              Icons.gps_fixed,
                              color: primaryColorLight,
                            ),
                            dropDown: SizedBox(),
                            onChanged: (String value) {
                              mapController.findStartPlace(value);
                              setState(() {
                                startChanging = true;
                                endChanging = false;
                              });
                            },
                            phoneNumberPrefix: SizedBox(),
                            suffix: SizedBox(),
                            inputFormatters: [],
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          CustomTextField(
                            readOnly: false,
                            height: height,
                            width: width,
                            controller: endController,
                            hintText: "Where to",
                            prefixBoxColor: primaryColorBlack,
                            prefixIcon: Icon(
                              Icons.location_on_rounded,
                              color: primaryColorLight,
                            ),
                            dropDown: SizedBox(),
                            onChanged: (String value) {
                              mapController.findEndPlace(value);
                              setState(() {
                                startChanging = false;
                                endChanging = true;
                              });
                            },
                            phoneNumberPrefix: SizedBox(),
                            suffix: SizedBox(),
                            inputFormatters: [],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SecondaryButtonWithIcon(
                      icon: Icons.electric_car_sharp,
                      iconColor: primaryColorWhite,
                      onPressed: widget.toMap,
                      text: "get ride",
                      boxColor: primaryColorDark,
                      shadowColor: primaryColorDark,
                      width: width,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(
                () => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 37, right: 27),
                      child: mapController.predictionList.value.length != 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  mapController.predictionList.value.length,
                              itemBuilder: (BuildContext context, int index) {
                                return PreviousLocation(
                                  icon: Icons.location_on_rounded,
                                  divider: true,
                                  title: mapController
                                      .predictionList.value[index].mainText,
                                  subTitle: mapController.predictionList
                                      .value[index].secondaryText,
                                  onTap: () {
                                    if (startChanging) {
                                      debugPrint("start : " +
                                          mapController.predictionList
                                              .value[index].mainText);
                                      setState(() {
                                        startController.text = mapController
                                            .predictionList
                                            .value[index]
                                            .mainText;
                                      });
                                      mapController.start.value = mapController
                                          .predictionList.value[index];
                                    } else {
                                      debugPrint("end : " +
                                          mapController.predictionList
                                              .value[index].mainText);
                                      setState(() {
                                        endController.text = mapController
                                            .predictionList
                                            .value[index]
                                            .mainText;
                                      });
                                      mapController.to.value = mapController
                                          .predictionList.value[index];
                                    }
                                  },
                                );
                              })
                          : Column(
                              children: [
                                PreviousLocation(
                                  icon: Icons.home_rounded,
                                  divider: true,
                                  title: "Home",
                                  subTitle: "Anandarama Rd, Moratuwa.",
                                  onTap: () {},
                                ),
                                PreviousLocation(
                                  icon: Icons.history,
                                  divider: true,
                                  title: "Katubedda Bus Stop",
                                  subTitle: "Anandarama Rd, Moratuwa.",
                                  onTap: () {},
                                ),
                                PreviousLocation(
                                  icon: Icons.history,
                                  divider: true,
                                  title: "Katubedda Bus Stop",
                                  subTitle: "Anandarama Rd, Moratuwa.",
                                  onTap: () {},
                                ),
                                PreviousLocation(
                                  icon: Icons.history,
                                  divider: true,
                                  title: "Katubedda Bus Stop",
                                  subTitle: "Anandarama Rd, Moratuwa.",
                                  onTap: () {},
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
