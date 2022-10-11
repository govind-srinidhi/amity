import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:amity/utils/widget_utils.dart';
import 'package:amity/widgets/discover/discovered_profiles_page_view.dart';
import 'package:amity/widgets/matched_profiles_screen.dart';
import 'package:amity/widgets/profile/view_my_profile_screen.dart';

class DiscoverProfilesScreen extends StatefulWidget {
  static String routeName = "/discover-profiles";

  const DiscoverProfilesScreen({super.key});

  @override
  State<DiscoverProfilesScreen> createState() => _DiscoverProfilesScreenState();
}

class _DiscoverProfilesScreenState extends State<DiscoverProfilesScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingAllDirection = screenWidth / 14;
    return Container(
      color: Color.fromRGBO(252, 245, 227, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("assets/images/happy_seniors.png"),
          Flexible(child: DiscoveredProfilesPageView()),
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
    );
  }
}
