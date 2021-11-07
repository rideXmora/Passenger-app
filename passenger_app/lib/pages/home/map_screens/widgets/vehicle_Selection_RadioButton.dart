import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passenger_app/pages/home/map_screens/widgets/vechicle_box.dart';

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
            icon: "assets/images/images/car.png",
            title: "Car",
            subTitle: "",
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
            icon: "assets/images/images/tuk.png",
            title: "Tuk",
            subTitle: "",
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
            icon: "assets/images/images/bike.png",
            title: "Moto",
            subTitle: "",
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
