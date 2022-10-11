import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:amity/controllers/user_friends_controller.dart';
import 'package:amity/controllers/user_matches_controller.dart';
import 'package:amity/providers/user_details_provider.dart';
import 'package:amity/schemas/configuration_schema.dart';
import 'package:amity/schemas/user_friends_schema.dart';
import 'package:amity/schemas/user_schema.dart';
import 'package:amity/utils/overlay_screen.dart';

class DiscoveredProfilesPageView extends StatefulWidget {
  const DiscoveredProfilesPageView({super.key});

  @override
  State<DiscoveredProfilesPageView> createState() =>
      _DiscoveredProfilesPageViewState();
}

class _DiscoveredProfilesPageViewState
    extends State<DiscoveredProfilesPageView> {
  bool _isInitialized = false;
  bool _showLoader = false;
  List<UserFriendsSchema> _potentialFriends = [];
  List<UserSchema> _matchedUsers = [];

  Future<void> _discoverProfiles(BuildContext context) async {
    setState(() {
      _showLoader = true;
    });
    final ConfigurationSchema? configurationSchema =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getUserDetail("userId");

    List<UserFriendsSchema> potentialFriends = [];
    List<UserSchema> matchedUsers = [];
    if (configurationSchema != null) {
      potentialFriends = await UserFriendsController()
          .getFriends(configurationSchema.id as int);
      matchedUsers = await UserMatchesController()
          .getMatchedUsers(configurationSchema.id as int);
    }

    setState(() {
      _potentialFriends = potentialFriends;
      _matchedUsers = matchedUsers;
      _showLoader = false;
    });
  }

  bool _isPotentialUserMatched(UserFriendsSchema potentialFriend) {
    return _matchedUsers
            .firstWhere(
                (element) => element.userId == potentialFriend.user?.userId,
                orElse: () => UserSchema())
            .userId !=
        null;
  }

  Future<void> _removeMatchedUser(
      UserSchema matchedUser, BuildContext context) async {
    setState(() {
      _showLoader = true;
    });
    final ConfigurationSchema? configurationSchema =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getUserDetail("userId");
    if (configurationSchema != null) {
      await UserMatchesController().deleteMatchedUser(
          configurationSchema.id as int, matchedUser.userId as int);
      setState(() {
        _matchedUsers.removeWhere((user) => user.userId == matchedUser.userId);
        _showLoader = false;
      });
      Navigator.of(context).push(OverlayScreen(
          color: Color.fromRGBO(255, 163, 102, 1),
          message: "Your match has been removed",
          icon: Icon(MdiIcons.close)));
    }
  }

  Future<void> _addMatchedUser(
      UserSchema matchedUser, BuildContext context) async {
    setState(() {
      _showLoader = true;
    });
    final ConfigurationSchema? configurationSchema =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getUserDetail("userId");

    if (configurationSchema != null) {
      await UserMatchesController().addMatchedUser(
          configurationSchema.id as int, matchedUser.userId as int);
      setState(() {
        _matchedUsers.add(matchedUser);
        _showLoader = false;
      });
      Navigator.of(context).push(OverlayScreen(
          color: Color.fromRGBO(231, 240, 117, 1),
          message: "You've both matched!",
          icon: Icon(MdiIcons.check)));
    }
  }

  @override
  void didChangeDependencies() {
    if (!_isInitialized) {
      _discoverProfiles(context);
      _isInitialized = true;
    }
    super.didChangeDependencies();
  }

  Widget _getPotentialFriendDetails(
      {required UserFriendsSchema potentialFriend,
      required double paddingAllDirection}) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(paddingAllDirection),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${potentialFriend.user?.firstName}, ${potentialFriend.user?.age}",
            style: Theme.of(context)
                .textTheme
                .headline1
                ?.merge(TextStyle(fontWeight: FontWeight.w500)),
          ),
          Text(
            "lives within ${potentialFriend.distance?.toStringAsFixed(2)} km",
            style: Theme.of(context).textTheme.headline4,
          ),
          Padding(
            padding: EdgeInsets.only(top: paddingAllDirection),
            child: Text(
              potentialFriend.user?.bio ?? "",
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
          Text(potentialFriend.matchedInterests?.interests?.join(", ") ?? "",
              style: Theme.of(context).textTheme.headlineMedium),
          Padding(
            padding: EdgeInsets.only(
                top: 2 * paddingAllDirection, bottom: paddingAllDirection),
            child: Row(
              children: [
                Expanded(
                  child: _isPotentialUserMatched(potentialFriend)
                      ? Material(
                          color: Color.fromRGBO(255, 163, 102, 1),
                          borderRadius: BorderRadius.circular(6),
                          child: IconButton(
                            onPressed: () => _removeMatchedUser(
                                potentialFriend.user as UserSchema, context),
                            icon: Icon(MdiIcons.close),
                          ),
                        )
                      : Material(
                          color: Color.fromRGBO(231, 240, 117, 1),
                          borderRadius: BorderRadius.circular(6),
                          child: IconButton(
                            onPressed: () => _addMatchedUser(
                                potentialFriend.user as UserSchema, context),
                            icon: Icon(MdiIcons.check),
                          ),
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

    final PageController controller = PageController();
    return LoadingOverlay(
      isLoading: _showLoader,
      progressIndicator: CircularProgressIndicator(
        color: Color.fromRGBO(231, 240, 117, 1),
      ),
      color: Color.fromRGBO(252, 245, 227, 1),
      child: PageView(
        controller: controller,
        children: _potentialFriends
            .map((friend) => _getPotentialFriendDetails(
                potentialFriend: friend,
                paddingAllDirection: paddingAllDirection))
            .toList(),
      ),
    );
  }
}
