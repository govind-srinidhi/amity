import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:amity/controllers/user_controller.dart';
import 'package:amity/providers/user_details_provider.dart';
import 'package:amity/schemas/configuration_schema.dart';
import 'package:amity/schemas/user_schema.dart';
import 'package:amity/utils/widget_utils.dart';
import 'package:amity/widgets/discover/discover_profiles_screen.dart';
import 'package:amity/widgets/matched_profiles_screen.dart';

class ViewMyProfileScreen extends StatefulWidget {
  static String routeName = "/view-my-profile";

  const ViewMyProfileScreen({super.key});

  @override
  State<ViewMyProfileScreen> createState() => _ViewMyProfileScreenState();
}

class _ViewMyProfileScreenState extends State<ViewMyProfileScreen> {
  UserSchema _user = UserSchema();
  bool _isInitialized = false;
  bool _showLoader = false;

  Future<void> _getUserDetails(int userId) async {
    setState(() {
      _showLoader = true;
    });
    final user = await UserController().getUser(userId);
    setState(() {
      _user = user;
      _showLoader = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInitialized) {
      ConfigurationSchema? configurationSchema =
          Provider.of<UserDetailsProvider>(context, listen: false)
              .getUserDetail('userId');
      if (configurationSchema != null) {
        _getUserDetails(configurationSchema.id as int);
      }
      _isInitialized = true;
    }
    super.didChangeDependencies();
  }

  Widget _getUserProfileWidget({required double paddingAllDirection}) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(paddingAllDirection),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${_user.firstName ?? ''}, ${_user.age ?? ''}",
            style: Theme.of(context)
                .textTheme
                .headline1
                ?.merge(TextStyle(fontWeight: FontWeight.w500)),
          ),
          Text(
            "Postal code: ${(_user.address)?['zipcode'] ?? ''}",
            style: Theme.of(context).textTheme.headline4,
          ),
          Padding(
            padding: EdgeInsets.only(top: paddingAllDirection),
            child: Text(
              _user.bio ?? "",
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: paddingAllDirection),
            child: Text("You're interested in:",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.merge(TextStyle(fontWeight: FontWeight.w600))),
          ),
          Text(_user.interests?.join(", ") ?? "",
              style: Theme.of(context).textTheme.headlineMedium),
          Padding(
            padding: EdgeInsets.only(
                top: paddingAllDirection, bottom: paddingAllDirection),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(216, 239, 243, 1)),
                      side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(color: Colors.black)),
                      elevation: MaterialStateProperty.all<double>(0),
                      padding:
                          MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                        (Set<MaterialState> states) {
                          return EdgeInsets.all(paddingAllDirection / 2);
                        },
                      ),
                    ),
                    child: Text("Edit my profile",
                        style: Theme.of(context).textTheme.button),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingAllDirection = screenWidth / 14;

    return LoadingOverlay(
      isLoading: _showLoader,
      progressIndicator: CircularProgressIndicator(
        color: Color.fromRGBO(231, 240, 117, 1),
      ),
      color: Color.fromRGBO(252, 245, 227, 1),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(252, 245, 227, 1),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/images/happy_seniors.png"),
              if (!_showLoader) ...[
                _getUserProfileWidget(paddingAllDirection: paddingAllDirection),
                Padding(
                  padding: EdgeInsets.all(paddingAllDirection),
                  child: Row(
                    children: [
                      Flexible(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: CommonWidgets.getFooterButton(
                              screenWidth: screenWidth,
                              icon: Icon(MdiIcons.eye),
                              iconText: 'Discover',
                              routeName: DiscoverProfilesScreen.routeName,
                              context: context),
                        ),
                      ),
                      Flexible(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: CommonWidgets.getFooterButton(
                              screenWidth: screenWidth,
                              icon: Icon(Icons.star_outline),
                              iconText: 'Matches',
                              routeName: MatchedProfilesScreen.routeName,
                              context: context),
                        ),
                      ),
                      Flexible(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: CommonWidgets.getFooterButton(
                              screenWidth: screenWidth,
                              icon: Icon(MdiIcons.faceManOutline),
                              iconText: 'Profile',
                              context: context),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }
}
