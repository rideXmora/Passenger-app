import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passenger_app/theme/colors.dart';
import 'package:passenger_app/widgets/main_button.dart';
import 'package:passenger_app/widgets/secondary_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapScreen extends StatefulWidget {
  MapScreen({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final onTap;
  @override
  _MapScreenState createState() => _MapScreenState();
}

Completer<GoogleMapController> _controller = Completer();

final CameraPosition _kGooglePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

class _MapScreenState extends State<MapScreen> {
  bool loading = false;
  TextEditingController paymentMethod = TextEditingController();
  int slectedMethod = 0;
  List<Map<String, dynamic>> methods = [
    {
      "Icon": Icons.money,
      "method": "Cash Payment",
      "index": 0,
    },
    {
      "Icon": Icons.credit_card,
      "method": "Card Payment",
      "index": 1,
    }
  ];
  @override
  void initState() {
    super.initState();
    setState(() {
      paymentMethod.text = methods[0]["method"];
      slectedMethod = 0;
    });
  }

  Widget _floatingCollapsed() {
    return Container(
      decoration: BoxDecoration(
        color: primaryColorDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(17),
          topRight: Radius.circular(17),
        ),
      ),
      margin: const EdgeInsets.only(
        left: 15,
        right: 15,
        bottom: 0,
        top: 24,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(
                Icons.keyboard_arrow_up,
                color: primaryColorWhite,
                size: 35,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Confirm ride",
                    style: TextStyle(
                      color: primaryColorWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _floatingPanel() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          color: primaryColorDark,
          borderRadius: BorderRadius.all(Radius.circular(17)),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: primaryColorDark,
            ),
          ]),
      margin: const EdgeInsets.only(
        left: 15,
        right: 15,
        bottom: 10,
        top: 24,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: VehicleSelectionRadioButton(),
              ),
            ),
            Container(
              height: 40,
              child: TextField(
                readOnly: true,
                style: TextStyle(
                  color: primaryColorWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                controller: paymentMethod,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 8),
                  prefixIcon: Icon(
                    methods[slectedMethod]["Icon"],
                    color: primaryColor,
                  ),
                  suffixIcon: PopupMenuButton<String>(
                    padding: EdgeInsets.all(0),
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: primaryColorWhite,
                    ),
                    onSelected: (String value) {
                      setState(() {
                        debugPrint(value);
                        paymentMethod.text =
                            methods[int.parse(value)]["method"];
                        slectedMethod = int.parse(value);
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return methods.map<PopupMenuItem<String>>((Map method) {
                        return PopupMenuItem(
                            child: Text(method["method"]),
                            value: method["index"].toString());
                      }).toList();
                    },
                  ),
                  suffixIconConstraints: BoxConstraints(
                    minWidth: 0,
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 20,
                  ),
                ),
              ),
            ),
            SecondaryButton(
              width: MediaQuery.of(context).size.width * 0.4,
              onPressed: () {},
              loading: loading,
              text: "Confirm",
              boxColor: primaryColorLight,
              shadowColor: Colors.transparent,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primaryColorWhite,
      appBar: AppBar(
        backgroundColor: primaryColorWhite,
        title: Text(
          "Map",
          style: TextStyle(
            color: primaryColorBlack,
            fontSize: 23,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: Container(),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
              ],
            ),
            SlidingUpPanel(
              renderPanelSheet: false,
              panel: _floatingPanel(),
              collapsed: _floatingCollapsed(),
              backdropColor: Colors.transparent,
              defaultPanelState: PanelState.OPEN,
              maxHeight: 360,
            )
          ],
        ),
      ),
    );
  }
}

class VehicleSelectionRadioButton extends StatefulWidget {
  VehicleSelectionRadioButton({Key? key}) : super(key: key);

  @override
  _VehicleSelectionRadioButtonState createState() =>
      _VehicleSelectionRadioButtonState();
}

class _VehicleSelectionRadioButtonState
    extends State<VehicleSelectionRadioButton> {
  int selected = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selected = 1;
            });
          },
          child: VehicleBox(
            icon: Icons.home_rounded,
            title: "Home",
            subTitle: "Anandarama Rd, Moratuwa.",
            value: 1,
            groupValue: selected,
            onChanged: (value) {
              setState(() {
                selected = 1;
              });
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              selected = 2;
            });
          },
          child: VehicleBox(
            icon: Icons.home_rounded,
            title: "Home",
            subTitle: "Anandarama Rd, Moratuwa.",
            value: 2,
            groupValue: selected,
            onChanged: (value) {
              setState(() {
                selected = 2;
              });
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              selected = 3;
            });
          },
          child: VehicleBox(
            icon: Icons.home_rounded,
            title: "Home",
            subTitle: "Anandarama Rd, Moratuwa.",
            value: 3,
            groupValue: selected,
            onChanged: (value) {
              setState(() {
                selected = 3;
              });
            },
          ),
        ),
      ],
    );
  }
}

class VehicleBox extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final int value;
  final int groupValue;
  final onChanged;
  VehicleBox({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: primaryColorWhite,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: primaryColorBlack,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    icon,
                    color: primaryColor,
                    size: 35,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Container(
                      height: 35,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: primaryColorBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            subTitle,
                            style: TextStyle(
                              color: primaryColorBlack,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primaryColorDark,
                    shape: BoxShape.circle,
                  ),
                  child: Radio(
                    value: value,
                    groupValue: groupValue,
                    onChanged: onChanged,
                    activeColor: primaryColorWhite,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Divider(
            thickness: 1,
            color: primaryColorBlack,
            height: 0,
          ),
        ),
      ],
    );
  }
}
