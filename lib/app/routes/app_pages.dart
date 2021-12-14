import '../bindings/location_access_binding.dart';
import '../ui/pages/location_access_page/location_access_page.dart';
      import '../bindings/test_binding.dart';
import '../ui/pages/test_page/test_page.dart';
import '../bindings/balance_binding.dart';
import '../bindings/rider_feedback_binding.dart';
import '../bindings/current_trip_binding.dart';
import '../bindings/completed_tips_binding.dart';
import '../bindings/wait_for_approval_binding.dart';
import '../bindings/rider_proffesional_info_binding.dart';
import '../bindings/rider_personal_info_binding.dart';
import '../bindings/otp_binding.dart';
import '../bindings/phone_input_binding.dart';
import '../bindings/introduction_binding.dart';
import '../bindings/splash_binding.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../bindings/home_binding.dart';
import '../ui/pages/pages.dart';
import 'app_routes.dart';

final _defaultTransition = Transition.native;

class AppPages {
  static final unknownRoutePage = GetPage(
    name: AppRoutes.UNKNOWN,
    page: () => UnknownRoutePage(),
    transition: _defaultTransition,
  );

  static final List<GetPage> pages = [
    unknownRoutePage,
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashPage(),
      binding: SplashBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.INTRODUCTION,
      page: () => IntroductionPage(),
      binding: IntroductionBinding(),
      transition: _defaultTransition,
    ),
    // GetPage(
    //   name: AppRoutes.PHONE_INPUT,
    //   page: () => PhoneInputPage(),
    //   binding: PhoneInputBinding(),
    //   transition: _defaultTransition,
    // ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => PhoneInputPage(),
      binding: PhoneInputBinding(isNewUser: false),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.SIGNUP,
      page: () => PhoneInputPage(),
      binding: PhoneInputBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.OTP,
      page: () => OtpPage(),
      binding: OtpBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.RIDER_PERSONAL_INFO,
      page: () => RiderPersonalInfoPage(),
      binding: RiderPersonalInfoBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.RIDER_PROFFESIONAL_INFO,
      page: () => RiderProffesionalInfoPage(),
      binding: RiderProffesionalInfoBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.WAIT_FOR_APPROVAL,
      page: () => WaitForApprovalPage(),
      binding: WaitForApprovalBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.COMPLETED_TIPS,
      page: () => CompletedTripsPage(),
      binding: CompletedTipsBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.CURRENT_TRIP,
      page: () => CurrentTripPage(),
      binding: CurrentTripBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.RIDER_FEEDBACK,
      page: () => RiderFeedbackPage(),
      binding: RiderFeedbackBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.BALANCE,
      page: () => BalancePage(),
      binding: BalanceBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.TEST,
      page: () => TestPage(),
      binding: TestBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.LOCATION_ACCESS,
      page: () => LocationAccessPage(),
      binding: LocationAccessBinding(),
      transition: _defaultTransition,
    ), 
];
}