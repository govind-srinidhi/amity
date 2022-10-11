/// Sign up page, where user can enter his desired pin.

import "package:flutter/material.dart";
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:amity/constants/app_constants.dart';
import 'package:amity/controllers/user_controller.dart';
import 'package:amity/providers/user_details_provider.dart';
import 'package:amity/schemas/configuration_schema.dart';
import 'package:amity/schemas/user_schema.dart';
import "package:amity/utils/widget_utils.dart";
import 'package:amity/widgets/profile/profile_completion_success_screen.dart';

class AdditionalDetailsScreen extends StatefulWidget {
  static String routeName = "profile/additional-info";

  const AdditionalDetailsScreen({super.key});
  @override
  _AdditionalDetailsScreen createState() => _AdditionalDetailsScreen();
}

class _AdditionalDetailsScreen extends State<AdditionalDetailsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showLoader = false;
  final List<String> _selectedInterests = [];
  final TextEditingController _bioController = TextEditingController();

  Widget _prepareSelectableChip(String interest) {
    int selectedInterestIndex = _selectedInterests.indexOf(interest);
    return InkWell(
      child: Chip(
          label: Text(
            interest,
            style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          ),
          avatar: (selectedInterestIndex != -1) ? Icon(Icons.check) : null,
          backgroundColor: (selectedInterestIndex != -1)
              ? Color.fromRGBO(231, 240, 117, 1)
              : Color.fromRGBO(216, 239, 243, 1),
          side: BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)))),
      onTap: () {
        setState(() {
          if (selectedInterestIndex != -1) {
            _selectedInterests.removeAt(selectedInterestIndex);
          } else {
            _selectedInterests.add(interest);
          }
        });
      },
    );
  }

  void _finishSetup(context) async {
    try {
      setState(() {
        showLoader = true;
      });
      List<ConfigurationSchema> configurationSchemas =
          await Provider.of<UserDetailsProvider>(context, listen: false)
              .getUserDetails();

      configurationSchemas.removeWhere(
          (element) => element.key == "bio" || element.key == "interests");
      configurationSchemas.addAll([
        ConfigurationSchema(key: "bio", value: _bioController.text),
        ConfigurationSchema(key: "interests", values: _selectedInterests)
      ]);

      int index = configurationSchemas.indexWhere(
          (element) => element.key == "userId" && element.id != null);

      // If user is already present, update the details otherwise create a new user.
      if (index != -1) {
        await UserController().updateUser(
            configurationSchemas[index].id as int,
            UserSchema.prepareUserSchemaFromConfigurations(
                configurationSchemas));
      } else {
        UserSchema userSchema = await UserController().saveUser(
            UserSchema.prepareUserSchemaFromConfigurations(
                configurationSchemas));
        configurationSchemas
            .add(ConfigurationSchema(key: "userId", id: userSchema.userId));
      }

      await Provider.of<UserDetailsProvider>(context, listen: false)
          .saveUserDetailsToFile(configurationSchemas);

      await Provider.of<UserDetailsProvider>(context, listen: false)
          .loadUserDetails();

      Navigator.of(context)
          .pushReplacementNamed(ProfileCompletionSuccessScreen.routeName);

      setState(() {
        showLoader = false;
      });
    } catch (e) {
      setState(() {
        showLoader = false;
      });
      print(e);
      CommonWidgets.showSnackbar("Something went wrong. Please try again.",
          Constants.MESSAGE_ERROR, _scaffoldKey.currentContext as BuildContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    final paddingAllDirection = MediaQuery.of(context).size.width / 14;
    final pillWidth =
        MediaQuery.of(context).size.width / 3 - paddingAllDirection;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
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
                  Color.fromRGBO(231, 240, 117, 1),
                ], pillWidth, 10),
              ),
              Padding(
                padding: EdgeInsets.only(top: paddingAllDirection),
                child: Center(
                  child: Text(
                    "Step 3 of 3",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: paddingAllDirection, bottom: paddingAllDirection),
                child: Text(
                  'Tell us a little about yourself',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              TextFormField(
                maxLines: 7,
                controller: _bioController,
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: paddingAllDirection, bottom: paddingAllDirection),
                child: Text(
                  'Pick as many interests as you want. You can also change this in your profile later.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Wrap(
                spacing: 10,
                children: Constants.USER_INTERESTS
                    .map((interest) => _prepareSelectableChip(interest))
                    .toList(),
              ),
              Padding(
                padding: EdgeInsets.only(top: paddingAllDirection),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(216, 239, 243, 1)),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(color: Colors.black, fontSize: 20)),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 30)),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(6))),
                          elevation: MaterialStateProperty.all<double>(0)),
                      child: Text("Go back"),
                    ),
                    ElevatedButton(
                      onPressed: () => _finishSetup(context),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(216, 239, 243, 1)),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            TextStyle(color: Colors.black, fontSize: 20)),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30)),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                side: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(6))),
                      ),
                      child: Text("Finish"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
