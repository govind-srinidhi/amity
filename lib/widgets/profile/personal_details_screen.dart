/// Sign up page, where user can enter his desired pin.
import "package:flutter/material.dart";
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import "package:amity/constants/app_constants.dart";
import 'package:amity/providers/user_details_provider.dart';
import 'package:amity/schemas/configuration_schema.dart';
import "package:amity/utils/widget_utils.dart";
import 'package:amity/widgets/profile/additional_details_screen.dart';

class PersonalDetailsScreen extends StatefulWidget {
  static String routeName = "profile/personal-details/";

  const PersonalDetailsScreen({super.key});
  @override
  _PersonalDetailsScreen createState() => _PersonalDetailsScreen();
}

class _PersonalDetailsScreen extends State<PersonalDetailsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showLoader = false;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  void _addDetails(context) async {
    try {
      setState(() {
        showLoader = true;
      });
      List<ConfigurationSchema> configurationSchemas = [
        ConfigurationSchema(key: "firstName", value: _firstNameController.text),
        ConfigurationSchema(key: "lastName", value: _lastNameController.text),
        ConfigurationSchema(
            key: "phoneNumber", value: _phoneNumberController.text),
        ConfigurationSchema(key: "age", value: _ageController.text),
        ConfigurationSchema(
            key: "postalCode", value: _postalCodeController.text)
      ];
      ConfigurationSchema? emailConfiguration =
          Provider.of<UserDetailsProvider>(context, listen: false)
              .getUserDetail("emailId");
      if (emailConfiguration != null) {
        configurationSchemas.add(emailConfiguration);
      }

      await Provider.of<UserDetailsProvider>(context, listen: false)
          .saveUserDetailsToFile(configurationSchemas);

      Navigator.of(context).pushNamed(AdditionalDetailsScreen.routeName);
      setState(() {
        showLoader = false;
      });
    } catch (e) {
      setState(() {
        showLoader = false;
      });
      CommonWidgets.showSnackbar("Something went wrong. Please try again.",
          Constants.MESSAGE_ERROR, _scaffoldKey.currentContext as BuildContext);
    }
  }

  Widget prepareTextFormField(String labelText,
      TextEditingController controller, double paddingBottom) {
    return Padding(
      padding: EdgeInsets.only(bottom: paddingBottom),
      child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paddingAllDirection = MediaQuery.of(context).size.width / 14;
    final pillWidth =
        MediaQuery.of(context).size.width / 3 - paddingAllDirection;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      body: LoadingOverlay(
        isLoading: showLoader,
        progressIndicator: CircularProgressIndicator(
          color: Color.fromRGBO(231, 240, 117, 1),
        ),
        color: Color.fromRGBO(252, 245, 227, 1),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: paddingAllDirection,
              vertical: 2 * paddingAllDirection),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: paddingAllDirection),
                child: CommonWidgets.getProgressBars([
                  Color.fromRGBO(231, 240, 117, 1),
                  Color.fromRGBO(231, 240, 117, 1),
                  Colors.white
                ], pillWidth, 10),
              ),
              Padding(
                padding: EdgeInsets.only(top: paddingAllDirection),
                child: Center(
                  child: Text(
                    "Step 2 of 3",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: paddingAllDirection, bottom: paddingAllDirection),
                child: Text(
                  'Fill in your profile details',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              prepareTextFormField(
                  'First name', _firstNameController, paddingAllDirection),
              prepareTextFormField(
                  'Last name', _lastNameController, paddingAllDirection),
              prepareTextFormField('Age', _ageController, paddingAllDirection),
              prepareTextFormField(
                  'Phone number', _phoneNumberController, paddingAllDirection),
              prepareTextFormField(
                  'Postal code', _postalCodeController, paddingAllDirection),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () => _addDetails(context),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(216, 239, 243, 1)),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        TextStyle(color: Colors.black, fontSize: 20)),
                    padding: MaterialStateProperty.all(EdgeInsets.all(15.0)),
                    minimumSize: Constants.largeSizeButton,
                    elevation: MaterialStateProperty.all<double>(0),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(6))),
                  ),
                  child: Text(
                    "Continue",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
