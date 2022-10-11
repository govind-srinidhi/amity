/// All the routes navigated across the application is registered here.
///
import 'package:amity/widgets/authentication/signup_success_screen.dart';
import "package:amity/widgets/authentication/welcome_screen.dart";
import 'package:amity/widgets/discover/discover_profiles_screen.dart';
import 'package:amity/widgets/matched_profiles_screen.dart';
import 'package:amity/widgets/profile/additional_details_screen.dart';
import 'package:amity/widgets/profile/personal_details_screen.dart';
import 'package:amity/widgets/profile/profile_completion_success_screen.dart';
import 'package:amity/widgets/profile/view_my_profile_screen.dart';
import 'package:amity/widgets/profile/view_profile_screen.dart';
import "widgets/authentication/login_screen.dart";
import "package:amity/widgets/authentication/signup_screen.dart";
import "widgets/authentication/auth.dart";

class RouteConfig {
  static final routes = {
    Auth.routeName: (_) => Auth(),
    SignupScreen.routeName: (_) => SignupScreen(),
    SignupSuccessScreen.routeName: (_) => SignupSuccessScreen(),
    LoginScreen.routeName: (_) => LoginScreen(),
    WelcomeScreen.routeName: (_) => WelcomeScreen(),
    PersonalDetailsScreen.routeName: (_) => PersonalDetailsScreen(),
    AdditionalDetailsScreen.routeName: (_) => AdditionalDetailsScreen(),
    ProfileCompletionSuccessScreen.routeName: (_) =>
        ProfileCompletionSuccessScreen(),
    MatchedProfilesScreen.routeName: (_) => MatchedProfilesScreen(),
    DiscoverProfilesScreen.routeName: (_) => DiscoverProfilesScreen(),
    ViewProfileScreen.routeName: (_) => ViewProfileScreen(),
    ViewMyProfileScreen.routeName: (_) => ViewMyProfileScreen()
  };
}
