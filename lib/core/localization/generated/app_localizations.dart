import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Cyber Sense'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'A clearer view of your digital security'**
  String get appTagline;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Security, with a clear identity'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Cyber Sense is your home for cybersecurity. A focused place to protect access to your digital life.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Accounts you can trust'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your email, then confirm with a WhatsApp code. Sessions stay under your control.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Ready for what comes next'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'User and admin access are already in place, so future security tools can be added without rebuilding the app.'**
  String get onboardingDesc3;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Cyber Sense'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Secure accounts, clear roles, and a foundation ready to grow.'**
  String get welcomeSubtitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginButton;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get signUpButton;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signInHere.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInHere;

  /// No description provided for @signUpHere.
  ///
  /// In en, this message translates to:
  /// **'Create one'**
  String get signUpHere;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your email and password. We will then send a code to your WhatsApp.'**
  String get loginSubtitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us who you are. We will verify the WhatsApp number before opening the account.'**
  String get createAccountSubtitle;

  /// No description provided for @whatsappOtpNote.
  ///
  /// In en, this message translates to:
  /// **'A 6-digit code will be sent to this WhatsApp number.'**
  String get whatsappOtpNote;

  /// No description provided for @passwordRules.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters, with upper and lower case, a number, and a symbol.'**
  String get passwordRules;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @searchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search country'**
  String get searchCountry;

  /// No description provided for @otpVerification.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get otpVerification;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a verification code to your WhatsApp'**
  String get otpSentTo;

  /// No description provided for @otpSentToNumber.
  ///
  /// In en, this message translates to:
  /// **'Code sent to {phoneNumber}'**
  String otpSentToNumber(String phoneNumber);

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get enterOtp;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyOtp;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendOtp;

  /// No description provided for @resendOtpIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String resendOtpIn(int seconds);

  /// No description provided for @otpVerified.
  ///
  /// In en, this message translates to:
  /// **'Verification successful'**
  String get otpVerified;

  /// No description provided for @otpFailed.
  ///
  /// In en, this message translates to:
  /// **'That code is not correct'**
  String get otpFailed;

  /// No description provided for @otpExpired.
  ///
  /// In en, this message translates to:
  /// **'This code has expired'**
  String get otpExpired;

  /// No description provided for @didntGetCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get the code?'**
  String get didntGetCode;

  /// No description provided for @attemptsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} attempts left'**
  String attemptsLeft(int count);

  /// No description provided for @devOtpHint.
  ///
  /// In en, this message translates to:
  /// **'Development code: {code}'**
  String devOtpHint(String code);

  /// No description provided for @codeResent.
  ///
  /// In en, this message translates to:
  /// **'A new code has been sent'**
  String get codeResent;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter the WhatsApp number on your account. We will send a reset code.'**
  String get forgotPasswordDesc;

  /// No description provided for @sendResetCode.
  ///
  /// In en, this message translates to:
  /// **'Send reset code'**
  String get sendResetCode;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated. You can sign in now.'**
  String get passwordResetSuccess;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Choose a new password'**
  String get createNewPassword;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get backToLogin;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @usersShort.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get usersShort;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @welcomeBackUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String welcomeBackUser(String name);

  /// No description provided for @userSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your account is ready. New security tools will appear here.'**
  String get userSubtitle;

  /// No description provided for @adminSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Workspace overview for accounts and access.'**
  String get adminSubtitle;

  /// No description provided for @totalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total accounts'**
  String get totalUsers;

  /// No description provided for @activeUsers.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeUsers;

  /// No description provided for @bannedUsers.
  ///
  /// In en, this message translates to:
  /// **'Banned'**
  String get bannedUsers;

  /// No description provided for @inactiveUsers.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactiveUsers;

  /// No description provided for @recentUsers.
  ///
  /// In en, this message translates to:
  /// **'Recent accounts'**
  String get recentUsers;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @upcomingTools.
  ///
  /// In en, this message translates to:
  /// **'Reserved for later'**
  String get upcomingTools;

  /// No description provided for @upcomingToolsBody.
  ///
  /// In en, this message translates to:
  /// **'These cards are placeholders. They do not scan mail, check links, or analyze threats.'**
  String get upcomingToolsBody;

  /// No description provided for @threatAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Threat analysis'**
  String get threatAnalysis;

  /// No description provided for @emailScanner.
  ///
  /// In en, this message translates to:
  /// **'Email scanner'**
  String get emailScanner;

  /// No description provided for @urlChecker.
  ///
  /// In en, this message translates to:
  /// **'Link checker'**
  String get urlChecker;

  /// No description provided for @securityReports.
  ///
  /// In en, this message translates to:
  /// **'Security reports'**
  String get securityReports;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get comingSoon;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This area is reserved for a future release.'**
  String get featureComingSoon;

  /// No description provided for @accountOverview.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountOverview;

  /// No description provided for @mockModeBanner.
  ///
  /// In en, this message translates to:
  /// **'Preview mode. Accounts stay on this device until you connect the API.'**
  String get mockModeBanner;

  /// No description provided for @userManagement.
  ///
  /// In en, this message translates to:
  /// **'User management'**
  String get userManagement;

  /// No description provided for @searchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search by name, email, or phone'**
  String get searchUsers;

  /// No description provided for @allUsers.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allUsers;

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeStatus;

  /// No description provided for @bannedStatus.
  ///
  /// In en, this message translates to:
  /// **'Banned'**
  String get bannedStatus;

  /// No description provided for @inactiveStatus.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactiveStatus;

  /// No description provided for @pendingStatus.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingStatus;

  /// No description provided for @editUser.
  ///
  /// In en, this message translates to:
  /// **'Account details'**
  String get editUser;

  /// No description provided for @banUser.
  ///
  /// In en, this message translates to:
  /// **'Ban'**
  String get banUser;

  /// No description provided for @unbanUser.
  ///
  /// In en, this message translates to:
  /// **'Remove ban'**
  String get unbanUser;

  /// No description provided for @deleteUser.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteUser;

  /// No description provided for @activateUser.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activateUser;

  /// No description provided for @deactivateUser.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivateUser;

  /// No description provided for @confirmBan.
  ///
  /// In en, this message translates to:
  /// **'Ban this account? The person will not be able to sign in.'**
  String get confirmBan;

  /// No description provided for @confirmUnban.
  ///
  /// In en, this message translates to:
  /// **'Remove the ban and allow this account to sign in?'**
  String get confirmUnban;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete this account? The person will no longer be able to sign in.'**
  String get confirmDelete;

  /// No description provided for @confirmDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate this account?'**
  String get confirmDeactivate;

  /// No description provided for @confirmActivate.
  ///
  /// In en, this message translates to:
  /// **'Activate this account?'**
  String get confirmActivate;

  /// No description provided for @userUpdated.
  ///
  /// In en, this message translates to:
  /// **'Account updated'**
  String get userUpdated;

  /// No description provided for @userBanned.
  ///
  /// In en, this message translates to:
  /// **'Account banned'**
  String get userBanned;

  /// No description provided for @userUnbanned.
  ///
  /// In en, this message translates to:
  /// **'Ban removed'**
  String get userUnbanned;

  /// No description provided for @userDeleted.
  ///
  /// In en, this message translates to:
  /// **'Account deleted'**
  String get userDeleted;

  /// No description provided for @userActivated.
  ///
  /// In en, this message translates to:
  /// **'Account activated'**
  String get userActivated;

  /// No description provided for @userDeactivated.
  ///
  /// In en, this message translates to:
  /// **'Account deactivated'**
  String get userDeactivated;

  /// No description provided for @roleUpdated.
  ///
  /// In en, this message translates to:
  /// **'Role updated'**
  String get roleUpdated;

  /// No description provided for @changeRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get changeRole;

  /// No description provided for @cannotChangeSelf.
  ///
  /// In en, this message translates to:
  /// **'You cannot change your own access.'**
  String get cannotChangeSelf;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No accounts match this search'**
  String get noUsersFound;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Access'**
  String get actions;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joined;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed'**
  String get passwordChanged;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @roleUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get roleUser;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since'**
  String get memberSince;

  /// No description provided for @accountStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get accountStatus;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get personalInformation;

  /// No description provided for @securitySettings.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get securitySettings;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get theme;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightMode;

  /// No description provided for @systemMode.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemMode;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSettings;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get termsOfService;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Log out of Cyber Sense on this device?'**
  String get logoutConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get success;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get noData;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get selectLanguage;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get selectTheme;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'Cyber Sense is a cybersecurity application foundation: accounts, verification, sessions, and roles. Security tools can be added later without replacing this structure.'**
  String get aboutBody;

  /// No description provided for @privacyBody.
  ///
  /// In en, this message translates to:
  /// **'Passwords are stored only as Argon2 hashes on the server. Verification codes are stored as hashes and expire after a short time. This device keeps session tokens in secure storage when you choose Remember me.'**
  String get privacyBody;

  /// No description provided for @termsBody.
  ///
  /// In en, this message translates to:
  /// **'Use the account issued to you. Admins manage access for the workspace. Do not share verification codes.'**
  String get termsBody;

  /// No description provided for @loginActivity.
  ///
  /// In en, this message translates to:
  /// **'Login activity'**
  String get loginActivity;

  /// No description provided for @activityHint.
  ///
  /// In en, this message translates to:
  /// **'Recent sign-in attempts for your account.'**
  String get activityHint;

  /// No description provided for @adminActivityHint.
  ///
  /// In en, this message translates to:
  /// **'Recent sign-in attempts across the workspace.'**
  String get adminActivityHint;

  /// No description provided for @loginTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get loginTime;

  /// No description provided for @device.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get device;

  /// No description provided for @ipAddress.
  ///
  /// In en, this message translates to:
  /// **'IP address'**
  String get ipAddress;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get loginSuccess;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get loginFailed;

  /// No description provided for @noActivity.
  ///
  /// In en, this message translates to:
  /// **'No sign-in activity yet'**
  String get noActivity;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @unknownDevice.
  ///
  /// In en, this message translates to:
  /// **'Unknown device'**
  String get unknownDevice;

  /// No description provided for @sessionManagement.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessionManagement;

  /// No description provided for @sessionsHint.
  ///
  /// In en, this message translates to:
  /// **'Devices that can still refresh this account.'**
  String get sessionsHint;

  /// No description provided for @activeSessions.
  ///
  /// In en, this message translates to:
  /// **'Active sessions'**
  String get activeSessions;

  /// No description provided for @endSession.
  ///
  /// In en, this message translates to:
  /// **'End session'**
  String get endSession;

  /// No description provided for @endAllSessions.
  ///
  /// In en, this message translates to:
  /// **'End all sessions'**
  String get endAllSessions;

  /// No description provided for @currentSession.
  ///
  /// In en, this message translates to:
  /// **'This device'**
  String get currentSession;

  /// No description provided for @confirmEndSession.
  ///
  /// In en, this message translates to:
  /// **'End this session?'**
  String get confirmEndSession;

  /// No description provided for @confirmEndAllSessions.
  ///
  /// In en, this message translates to:
  /// **'End every session, including this one?'**
  String get confirmEndAllSessions;

  /// No description provided for @sessionEnded.
  ///
  /// In en, this message translates to:
  /// **'Session ended'**
  String get sessionEnded;

  /// No description provided for @allSessionsEnded.
  ///
  /// In en, this message translates to:
  /// **'All sessions ended'**
  String get allSessionsEnded;

  /// No description provided for @noSessions.
  ///
  /// In en, this message translates to:
  /// **'No active sessions'**
  String get noSessions;

  /// No description provided for @lastActive.
  ///
  /// In en, this message translates to:
  /// **'Last active'**
  String get lastActive;

  /// No description provided for @started.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get started;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationRequired;

  /// No description provided for @validationEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get validationEmail;

  /// No description provided for @validationPassword.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters'**
  String get validationPassword;

  /// No description provided for @validationPasswordMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordMatch;

  /// No description provided for @validationPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get validationPhone;

  /// No description provided for @validationName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get validationName;

  /// No description provided for @validationOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter all 6 digits'**
  String get validationOtp;

  /// No description provided for @validationPasswordStrength.
  ///
  /// In en, this message translates to:
  /// **'Include upper and lower case, a number, and a symbol'**
  String get validationPasswordStrength;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Email or password is incorrect'**
  String get invalidCredentials;

  /// No description provided for @accountBanned.
  ///
  /// In en, this message translates to:
  /// **'This account is banned'**
  String get accountBanned;

  /// No description provided for @accountInactive.
  ///
  /// In en, this message translates to:
  /// **'This account is inactive'**
  String get accountInactive;

  /// No description provided for @tooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Request a new code.'**
  String get tooManyAttempts;

  /// No description provided for @resendTooSoon.
  ///
  /// In en, this message translates to:
  /// **'Please wait before requesting another code'**
  String get resendTooSoon;

  /// No description provided for @phoneNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account uses this WhatsApp number'**
  String get phoneNotFound;

  /// No description provided for @emailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists'**
  String get emailInUse;

  /// No description provided for @phoneInUse.
  ///
  /// In en, this message translates to:
  /// **'An account with this phone number already exists'**
  String get phoneInUse;

  /// No description provided for @otpSendFailed.
  ///
  /// In en, this message translates to:
  /// **'The code could not be sent. Try again.'**
  String get otpSendFailed;

  /// No description provided for @forbidden.
  ///
  /// In en, this message translates to:
  /// **'You do not have access to this action'**
  String get forbidden;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Check your connection.'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'The server could not complete this request.'**
  String get serverError;

  /// No description provided for @unauthorizedError.
  ///
  /// In en, this message translates to:
  /// **'Your session has ended. Sign in again.'**
  String get unauthorizedError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Something unexpected happened'**
  String get unknownError;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return SAr();
    case 'en':
      return SEn();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
