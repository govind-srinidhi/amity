import 'package:amity/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:amity/controllers/user_controller.dart';
import 'package:amity/schemas/user_schema.dart';
import 'package:amity/utils/widget_utils.dart';
import 'package:amity/widgets/discover/discover_profiles_screen.dart';
import 'package:amity/widgets/matched_profiles_screen.dart';

import 'view_my_profile_screen.dart';

class ViewProfileScreen extends StatefulWidget {
  static String routeName = "/view-profile";

  const ViewProfileScreen({super.key});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  UserSchema _friend = UserSchema();
  bool _isInitialized = false;
  bool _showLoader = false;

  Future<void> _getUserDetails(int friendId) async {
    setState(() {
      _showLoader = true;
    });
    final friend = await UserController().getUser(friendId);
    setState(() {
      _friend = friend;
      _showLoader = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInitialized) {
      final routeArguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, int>;
      _getUserDetails(routeArguments["userId"] as int);
      _isInitialized = true;
    }
    super.didChangeDependencies();
  }

  Widget _getFriendDetails({required double paddingAllDirection}) {
    return Container(
      padding: EdgeInsets.only(
          left: paddingAllDirection, right: paddingAllDirection),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${_friend.firstName}, ${_friend.age}",
            style: Theme.of(context)
                .textTheme
                .headline1
                ?.merge(TextStyle(fontWeight: FontWeight.w500)),
          ),
          Text(
            "lives within 5km",
            style: Theme.of(context).textTheme.headline4,
          ),
          Padding(
            padding: EdgeInsets.only(top: paddingAllDirection),
            child: Text(
              _friend.bio ?? "",
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: paddingAllDirection),
            child: Text("You're both interested in:",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.merge(TextStyle(fontWeight: FontWeight.w600))),
          ),
          Text(_friend.interests?.join(", ") ?? "",
              style: Theme.of(context).textTheme.headlineMedium),
          Padding(
            padding: EdgeInsets.only(
                top: paddingAllDirection, bottom: paddingAllDirection),
            child: Row(
              children: [
                Expanded(
                  child: Material(
                    color: Color.fromRGBO(216, 239, 243, 1),
                    borderRadius: BorderRadius.circular(6),
                    child: IconButton(
                      onPressed: () =>
                          CommonUtils.launchUrl('tel:+31626238326'),
                      icon: Icon(MdiIcons.phone),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
      child: Container(
        color: Color.fromRGBO(252, 245, 227, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset("assets/images/happy_seniors.png"),
            _getFriendDetails(paddingAllDirection: paddingAllDirection),
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
                          routeName: ViewMyProfileScreen.routeName,
                          context: context),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
