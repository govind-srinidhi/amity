import 'package:amity/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:amity/controllers/user_matches_controller.dart';
import 'package:amity/providers/user_details_provider.dart';
import 'package:amity/schemas/configuration_schema.dart';
import 'package:amity/schemas/user_schema.dart';
import 'package:amity/widgets/discover/discover_profiles_screen.dart';
import 'package:amity/widgets/profile/view_my_profile_screen.dart';
import 'package:amity/widgets/profile/view_profile_screen.dart';

class MatchedProfilesScreen extends StatefulWidget {
  static String routeName = "/matched-profiles";

  const MatchedProfilesScreen({super.key});

  @override
  State<MatchedProfilesScreen> createState() => _MatchedProfilesScreenState();
}

class _MatchedProfilesScreenState extends State<MatchedProfilesScreen> {
  bool _isInitialized = false;
  List<UserSchema> _matchedUserSchemas = [];
  bool _showLoader = false;

  Future<void> _determineMatchedProfiles(BuildContext context) async {
    setState(() {
      _showLoader = true;
    });
    final ConfigurationSchema? configurationSchema =
        Provider.of<UserDetailsProvider>(context).getUserDetail("userId");
    final List<UserSchema> matchedProfiles = configurationSchema != null
        ? await UserMatchesController()
            .getMatchedUsers(configurationSchema.id as int)
        : [];
    setState(() {
      _matchedUserSchemas = matchedProfiles;
      _showLoader = false;
    });
  }

  Widget _showMatchedUser(
      {required double screenWidth,
      required double paddingAllDirection,
      required UserSchema matchedUser,
      required BuildContext context}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.black,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: SizedBox(
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(paddingAllDirection / 2),
              child: Text(
                "${matchedUser.firstName}, ${matchedUser.age}",
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: paddingAllDirection / 2,
                  right: paddingAllDirection / 2,
                  bottom: paddingAllDirection / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: screenWidth / 2 - 2 * paddingAllDirection,
                    child: ElevatedButton(
                      onPressed: () =>
                          CommonUtils.launchUrl('tel:+31626238326'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(216, 239, 243, 1)),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(color: Colors.black)),
                        elevation: MaterialStateProperty.all<double>(0),
                      ),
                      child: Text("Call",
                          style: Theme.of(context).textTheme.button),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth / 2 - 2 * paddingAllDirection,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(ViewProfileScreen.routeName,
                              arguments: {"userId": matchedUser.userId as int}),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(216, 239, 243, 1)),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(color: Colors.black)),
                        elevation: MaterialStateProperty.all<double>(0),
                      ),
                      child: Text("View profile",
                          style: Theme.of(context).textTheme.button),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getFooterButton(
      {required double screenWidth,
      required Icon icon,
      required String iconText,
      String? routeName}) {
    return SizedBox(
      width: screenWidth / 4,
      height: screenWidth / 6,
      child: ClipRect(
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: const BorderSide(color: Colors.black, width: 1),
          ),
          color: routeName == null
              ? Color.fromRGBO(177, 223, 231, 1)
              : Color.fromRGBO(216, 239, 243, 1),
          child: InkWell(
            splashColor: Color.fromRGBO(216, 239, 243, 1),
            onTap: () => routeName != null
                ? Navigator.of(context).pushReplacementNamed(routeName)
                : {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                icon, // <-- Icon
                Text(
                  iconText,
                  style: Theme.of(context).textTheme.button,
                ), // <-- Text
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() async {
    if (_isInitialized == null || !this._isInitialized) {
      _determineMatchedProfiles(context);
      _isInitialized = true;
    }
    super.didChangeDependencies();
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
        backgroundColor: Theme.of(context).backgroundColor,
        body: Container(
          color: Color.fromRGBO(252, 245, 227, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: paddingAllDirection,
                    vertical: 2 * paddingAllDirection),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: paddingAllDirection,
                          bottom: paddingAllDirection),
                      child: Text(
                        "Matches",
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            ?.merge(TextStyle(fontWeight: FontWeight.w500)),
                      ),
                    ),
                    Wrap(
                        runSpacing: paddingAllDirection,
                        children: _matchedUserSchemas
                            .map((userSchema) => _showMatchedUser(
                                context: context,
                                screenWidth: screenWidth,
                                paddingAllDirection: paddingAllDirection,
                                matchedUser: userSchema))
                            .toList())
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(paddingAllDirection),
                child: Row(
                  children: [
                    Flexible(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: _getFooterButton(
                          screenWidth: screenWidth,
                          icon: Icon(MdiIcons.eye),
                          iconText: 'Discover',
                          routeName: DiscoverProfilesScreen.routeName,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: _getFooterButton(
                          screenWidth: screenWidth,
                          icon: Icon(Icons.star_outline),
                          iconText: 'Matches',
                        ),
                      ),
                    ),
                    Flexible(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: _getFooterButton(
                          screenWidth: screenWidth,
                          icon: Icon(MdiIcons.faceManOutline),
                          iconText: 'Profile',
                          routeName: ViewMyProfileScreen.routeName,
                        ),
                      ),
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
