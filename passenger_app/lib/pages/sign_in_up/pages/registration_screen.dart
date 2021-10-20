import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';
import 'package:passenger_app/controllers/auth_controller.dart';
import 'package:passenger_app/controllers/user_controller.dart';
import 'package:passenger_app/pages/bottom_navigation_bar_handler.dart';
import 'package:passenger_app/theme/colors.dart';
import 'package:passenger_app/widgets/custom_back_button.dart';
import 'package:passenger_app/widgets/custom_text_field.dart';
import 'package:passenger_app/widgets/main_button.dart';

class RegistrationScreen extends StatefulWidget {
  final String phoneNo;

  RegistrationScreen({
    Key? key,
    required this.phoneNo,
  }) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool edit = true;
  String dropdownValue = "+94";
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      mobileNumberController.text = widget.phoneNo.substring(3, 5) +
          " " +
          widget.phoneNo.substring(5, 8) +
          " " +
          widget.phoneNo.substring(8, 12);
    });
  }

  void onSubmitButton() async {
    if (!loading) {
      setState(() {
        loading = true;
      });

      String phoneNumber = dropdownValue.trim() +
          mobileNumberController.text.replaceAll(" ", "");
      await Get.find<AuthController>().register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
      );
      setState(() {
        loading = false;
      });
    }
  }

  void onSubmitText(String value) async {
    if (!loading) {
      setState(() {
        loading = true;
      });

      String phoneNumber = dropdownValue.trim() +
          mobileNumberController.text.replaceAll(" ", "");
      if (phoneNumber.length == 12) {
        await Get.find<AuthController>().register(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
        );
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future _pickImageFromToProfile(BuildContext context) async {
    // final pickImagefile = await PickMedia.pickImageToUpload(
    //   cropImage: cropSquareImage,
    // );

    // setState(() {
    //   if (pickImagefile == null) {
    //     print('No image selected.');
    //   } else {
    //     _imageProfile = File(pickImagefile.path);
    //     uploadProfileImage(context);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: primaryColorWhite,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          debugPrint(
              Get.find<UserController>().passenger.value.toJson().toString());
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 45,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomBackButton(),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Let's be a\nRideX Passenger",
                    style: TextStyle(
                      color: primaryColorDark,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  Center(
                    child: Container(
                      height: 115,
                      width: 115,
                      child: Stack(
                        children: [
                          // * Image
                          Container(
                            width: 115,
                            height: 115,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    "assets/images/images/user_icon.png"),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(200),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.camera_alt),
                                color: Colors.white,
                                iconSize: 18,
                                onPressed: () {
                                  _pickImageFromToProfile(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 34,
                  ),
                  CustomTextField(
                    readOnly: edit ? false : true,
                    height: height,
                    width: width,
                    controller: nameController,
                    hintText: "Name",
                    prefixBoxColor: primaryColorBlack,
                    prefixIcon: Icon(
                      Icons.person,
                      color: primaryColorLight,
                    ),
                    dropDown: SizedBox(),
                    onChanged: () {},
                    phoneNumberPrefix: SizedBox(),
                    suffix: SizedBox(),
                    inputFormatters: [],
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  CustomTextField(
                    readOnly: edit ? false : true,
                    height: height,
                    width: width,
                    controller: emailController,
                    hintText: "Email",
                    prefixBoxColor: primaryColorBlack,
                    prefixIcon: Icon(
                      Icons.email,
                      color: primaryColorLight,
                    ),
                    dropDown: SizedBox(),
                    onChanged: () {},
                    phoneNumberPrefix: SizedBox(),
                    suffix: SizedBox(),
                    inputFormatters: [],
                    onSubmit: onSubmitText,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  CustomTextField(
                    readOnly: true,
                    height: height,
                    width: width,
                    controller: mobileNumberController,
                    hintText: "Mobile Number",
                    prefixBoxColor: primaryColorBlack,
                    prefixIcon: Icon(
                      Icons.phone,
                      color: primaryColorLight,
                    ),
                    dropDown: SizedBox(),
                    keyboardType: TextInputType.number,
                    onChanged: () {},
                    phoneNumberPrefixWidth: 110,
                    inputFormatters: [
                      MaskedInputFormatter("## ### ####",
                          anyCharMatcher: RegExp(r'\d')),
                    ],
                    phoneNumberPrefix: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        IgnorePointer(
                          ignoring: true,
                          child: DropdownButton<String>(
                            underline: SizedBox(),
                            value: dropdownValue,
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: primaryColorWhite,
                            ),
                            style: TextStyle(
                              color: primaryColorWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue.toString();
                              });
                            },
                            dropdownColor: primaryColorLight,
                            items: <String>['+94']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: primaryColorWhite,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          margin:
                              const EdgeInsets.only(top: 13.0, bottom: 13.0),
                          child: VerticalDivider(
                            color: primaryColorWhite,
                            width: 1,
                          ),
                        ),
                      ],
                    ),
                    suffix: SizedBox(),
                  ),
                  SizedBox(
                    height: 90,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: MainButton(
          loading: loading,
          width: width,
          height: height,
          onPressed: onSubmitButton,
          text: "CONTINUE",
          boxColor: primaryColorDark,
          shadowColor: primaryColorDark,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
