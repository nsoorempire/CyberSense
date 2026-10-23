// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Cyber Sense';

  @override
  String get appTagline => 'A clearer view of your digital security';

  @override
  String get onboardingTitle1 => 'Security, with a clear identity';

  @override
  String get onboardingDesc1 =>
      'Cyber Sense is your home for cybersecurity. A focused place to protect access to your digital life.';

  @override
  String get onboardingTitle2 => 'Accounts you can trust';

  @override
  String get onboardingDesc2 =>
      'Sign in with your email, then confirm with a WhatsApp code. Sessions stay under your control.';

  @override
  String get onboardingTitle3 => 'Ready for what comes next';

  @override
  String get onboardingDesc3 =>
      'User and admin access are already in place, so future security tools can be added without rebuilding the app.';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get getStarted => 'Get Started';

  @override
  String get back => 'Back';

  @override
  String get welcomeTitle => 'Welcome to Cyber Sense';

  @override
  String get welcomeSubtitle =>
      'Secure accounts, clear roles, and a foundation ready to grow.';

  @override
  String get login => 'Login';

  @override
  String get createAccount => 'Create Account';

  @override
  String get email => 'Email address';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get fullName => 'Full name';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get loginButton => 'Sign in';

  @override
  String get signUpButton => 'Create account';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signInHere => 'Sign in';

  @override
  String get signUpHere => 'Create one';

  @override
  String get loginSubtitle =>
      'Use your email and password. We will then send a code to your WhatsApp.';

  @override
  String get createAccountSubtitle =>
      'Tell us who you are. We will verify the WhatsApp number before opening the account.';

  @override
  String get whatsappOtpNote =>
      'A 6-digit code will be sent to this WhatsApp number.';

  @override
  String get passwordRules =>
      'At least 8 characters, with upper and lower case, a number, and a symbol.';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get country => 'Country';

  @override
  String get searchCountry => 'Search country';

  @override
  String get otpVerification => 'Verification code';

  @override
  String get otpSentTo => 'We sent a verification code to your WhatsApp';

  @override
  String otpSentToNumber(String phoneNumber) {
    return 'Code sent to $phoneNumber';
  }

  @override
  String get enterOtp => 'Enter the 6-digit code';

  @override
  String get verifyOtp => 'Verify';

  @override
  String get resendOtp => 'Resend code';

  @override
  String resendOtpIn(int seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get otpVerified => 'Verification successful';

  @override
  String get otpFailed => 'That code is not correct';

  @override
  String get otpExpired => 'This code has expired';

  @override
  String get didntGetCode => 'Didn\'t get the code?';

  @override
  String attemptsLeft(int count) {
    return '$count attempts left';
  }

  @override
  String devOtpHint(String code) {
    return 'Development code: $code';
  }

  @override
  String get codeResent => 'A new code has been sent';

  @override
  String get forgotPasswordTitle => 'Reset password';

  @override
  String get forgotPasswordDesc =>
      'Enter the WhatsApp number on your account. We will send a reset code.';

  @override
  String get sendResetCode => 'Send reset code';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get passwordResetSuccess => 'Password updated. You can sign in now.';

  @override
  String get createNewPassword => 'Choose a new password';

  @override
  String get backToLogin => 'Back to login';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get activity => 'Activity';

  @override
  String get usersShort => 'Users';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String welcomeBackUser(String name) {
    return 'Welcome back, $name';
  }

  @override
  String get userSubtitle =>
      'Your account is ready. New security tools will appear here.';

  @override
  String get adminSubtitle => 'Workspace overview for accounts and access.';

  @override
  String get totalUsers => 'Total accounts';

  @override
  String get activeUsers => 'Active';

  @override
  String get bannedUsers => 'Banned';

  @override
  String get inactiveUsers => 'Inactive';

  @override
  String get recentUsers => 'Recent accounts';

  @override
  String get viewAll => 'View all';

  @override
  String get upcomingTools => 'Reserved for later';

  @override
  String get upcomingToolsBody =>
      'These cards are placeholders. They do not scan mail, check links, or analyze threats.';

  @override
  String get threatAnalysis => 'Threat analysis';

  @override
  String get emailScanner => 'Email scanner';

  @override
  String get urlChecker => 'Link checker';

  @override
  String get securityReports => 'Security reports';

  @override
  String get comingSoon => 'Soon';

  @override
  String get featureComingSoon => 'This area is reserved for a future release.';

  @override
  String get accountOverview => 'Account';

  @override
  String get mockModeBanner =>
      'Preview mode. Accounts stay on this device until you connect the API.';

  @override
  String get userManagement => 'User management';

  @override
  String get searchUsers => 'Search by name, email, or phone';

  @override
  String get allUsers => 'All';

  @override
  String get activeStatus => 'Active';

  @override
  String get bannedStatus => 'Banned';

  @override
  String get inactiveStatus => 'Inactive';

  @override
  String get pendingStatus => 'Pending';

  @override
  String get editUser => 'Account details';

  @override
  String get banUser => 'Ban';

  @override
  String get unbanUser => 'Remove ban';

  @override
  String get deleteUser => 'Delete account';

  @override
  String get activateUser => 'Activate';

  @override
  String get deactivateUser => 'Deactivate';

  @override
  String get confirmBan =>
      'Ban this account? The person will not be able to sign in.';

  @override
  String get confirmUnban =>
      'Remove the ban and allow this account to sign in?';

  @override
  String get confirmDelete =>
      'Delete this account? The person will no longer be able to sign in.';

  @override
  String get confirmDeactivate => 'Deactivate this account?';

  @override
  String get confirmActivate => 'Activate this account?';

  @override
  String get userUpdated => 'Account updated';

  @override
  String get userBanned => 'Account banned';

  @override
  String get userUnbanned => 'Ban removed';

  @override
  String get userDeleted => 'Account deleted';

  @override
  String get userActivated => 'Account activated';

  @override
  String get userDeactivated => 'Account deactivated';

  @override
  String get roleUpdated => 'Role updated';

  @override
  String get changeRole => 'Role';

  @override
  String get cannotChangeSelf => 'You cannot change your own access.';

  @override
  String get noUsersFound => 'No accounts match this search';

  @override
  String get you => 'You';

  @override
  String get actions => 'Access';

  @override
  String get details => 'Details';

  @override
  String get joined => 'Joined';

  @override
  String get profile => 'Profile';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get changePassword => 'Change password';

  @override
  String get currentPassword => 'Current password';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get passwordChanged => 'Password changed';

  @override
  String get role => 'Role';

  @override
  String get roleUser => 'User';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get memberSince => 'Member since';

  @override
  String get accountStatus => 'Status';

  @override
  String get personalInformation => 'Personal information';

  @override
  String get securitySettings => 'Password';

  @override
  String get verified => 'Verified';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get theme => 'Appearance';

  @override
  String get darkMode => 'Dark';

  @override
  String get lightMode => 'Light';

  @override
  String get systemMode => 'System';

  @override
  String get accountSettings => 'Account';

  @override
  String get about => 'About';

  @override
  String get privacyPolicy => 'Privacy';

  @override
  String get termsOfService => 'Terms';

  @override
  String get logout => 'Log out';

  @override
  String get logoutConfirm => 'Log out of Cyber Sense on this device?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Something went wrong';

  @override
  String get success => 'Done';

  @override
  String get loading => 'Loading';

  @override
  String get retry => 'Try again';

  @override
  String get noData => 'Nothing here yet';

  @override
  String get save => 'Save';

  @override
  String get refresh => 'Refresh';

  @override
  String get appearance => 'Appearance';

  @override
  String get preferences => 'Preferences';

  @override
  String get selectLanguage => 'Language';

  @override
  String get selectTheme => 'Theme';

  @override
  String get version => 'Version';

  @override
  String get aboutBody =>
      'Cyber Sense is a cybersecurity application foundation: accounts, verification, sessions, and roles. Security tools can be added later without replacing this structure.';

  @override
  String get privacyBody =>
      'Passwords are stored only as Argon2 hashes on the server. Verification codes are stored as hashes and expire after a short time. This device keeps session tokens in secure storage when you choose Remember me.';

  @override
  String get termsBody =>
      'Use the account issued to you. Admins manage access for the workspace. Do not share verification codes.';

  @override
  String get loginActivity => 'Login activity';

  @override
  String get activityHint => 'Recent sign-in attempts for your account.';

  @override
  String get adminActivityHint =>
      'Recent sign-in attempts across the workspace.';

  @override
  String get loginTime => 'Time';

  @override
  String get device => 'Device';

  @override
  String get ipAddress => 'IP address';

  @override
  String get status => 'Status';

  @override
  String get loginSuccess => 'Success';

  @override
  String get loginFailed => 'Failed';

  @override
  String get noActivity => 'No sign-in activity yet';

  @override
  String get reason => 'Reason';

  @override
  String get unknownDevice => 'Unknown device';

  @override
  String get sessionManagement => 'Sessions';

  @override
  String get sessionsHint => 'Devices that can still refresh this account.';

  @override
  String get activeSessions => 'Active sessions';

  @override
  String get endSession => 'End session';

  @override
  String get endAllSessions => 'End all sessions';

  @override
  String get currentSession => 'This device';

  @override
  String get confirmEndSession => 'End this session?';

  @override
  String get confirmEndAllSessions => 'End every session, including this one?';

  @override
  String get sessionEnded => 'Session ended';

  @override
  String get allSessionsEnded => 'All sessions ended';

  @override
  String get noSessions => 'No active sessions';

  @override
  String get lastActive => 'Last active';

  @override
  String get started => 'Started';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get validationEmail => 'Enter a valid email address';

  @override
  String get validationPassword => 'Use at least 8 characters';

  @override
  String get validationPasswordMatch => 'Passwords do not match';

  @override
  String get validationPhone => 'Enter a valid phone number';

  @override
  String get validationName => 'Enter your name';

  @override
  String get validationOtp => 'Enter all 6 digits';

  @override
  String get validationPasswordStrength =>
      'Include upper and lower case, a number, and a symbol';

  @override
  String get invalidCredentials => 'Email or password is incorrect';

  @override
  String get accountBanned => 'This account is banned';

  @override
  String get accountInactive => 'This account is inactive';

  @override
  String get tooManyAttempts => 'Too many attempts. Request a new code.';

  @override
  String get resendTooSoon => 'Please wait before requesting another code';

  @override
  String get phoneNotFound => 'No account uses this WhatsApp number';

  @override
  String get emailInUse => 'An account with this email already exists';

  @override
  String get phoneInUse => 'An account with this phone number already exists';

  @override
  String get otpSendFailed => 'The code could not be sent. Try again.';

  @override
  String get forbidden => 'You do not have access to this action';

  @override
  String get networkError => 'Network error. Check your connection.';

  @override
  String get serverError => 'The server could not complete this request.';

  @override
  String get unauthorizedError => 'Your session has ended. Sign in again.';

  @override
  String get unknownError => 'Something unexpected happened';
}
