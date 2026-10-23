// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class SAr extends S {
  SAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'سايبر سينس';

  @override
  String get appTagline => 'رؤية أوضح لأمنك الرقمي';

  @override
  String get onboardingTitle1 => 'أمن سيبراني بهوية واضحة';

  @override
  String get onboardingDesc1 =>
      'سايبر سينس هو مساحتك في الأمن السيبراني. مكان مركز لحماية الوصول إلى حياتك الرقمية.';

  @override
  String get onboardingTitle2 => 'حسابات يمكن الوثوق بها';

  @override
  String get onboardingDesc2 =>
      'سجّل الدخول بالبريد، ثم أكّد الرمز عبر واتساب. تبقى الجلسات تحت إدارتك.';

  @override
  String get onboardingTitle3 => 'جاهز لما يأتي لاحقًا';

  @override
  String get onboardingDesc3 =>
      'صلاحيات المستخدم والمسؤول جاهزة، ويمكن إضافة أدوات الأمن لاحقًا دون إعادة بناء التطبيق.';

  @override
  String get next => 'التالي';

  @override
  String get skip => 'تخطي';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get back => 'رجوع';

  @override
  String get welcomeTitle => 'مرحبًا بك في سايبر سينس';

  @override
  String get welcomeSubtitle =>
      'حسابات آمنة، وصلاحيات واضحة، وأساس جاهز للتوسع.';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get loginButton => 'دخول';

  @override
  String get signUpButton => 'إنشاء الحساب';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get signInHere => 'سجّل الدخول';

  @override
  String get signUpHere => 'أنشئ حسابًا';

  @override
  String get loginSubtitle =>
      'أدخل بريدك وكلمة المرور، ثم نرسل رمزًا إلى واتساب.';

  @override
  String get createAccountSubtitle =>
      'عرّفنا بك. سنتحقق من رقم واتساب قبل فتح الحساب.';

  @override
  String get whatsappOtpNote => 'سيصلك رمز من 6 أرقام على رقم واتساب هذا.';

  @override
  String get passwordRules => '8 أحرف على الأقل، مع حرف كبير وصغير ورقم ورمز.';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get country => 'الدولة';

  @override
  String get searchCountry => 'ابحث عن الدولة';

  @override
  String get otpVerification => 'رمز التحقق';

  @override
  String get otpSentTo => 'أرسلنا رمز التحقق إلى واتساب';

  @override
  String otpSentToNumber(String phoneNumber) {
    return 'أُرسل الرمز إلى $phoneNumber';
  }

  @override
  String get enterOtp => 'أدخل الرمز المكوّن من 6 أرقام';

  @override
  String get verifyOtp => 'تحقق';

  @override
  String get resendOtp => 'إعادة إرسال الرمز';

  @override
  String resendOtpIn(int seconds) {
    return 'إعادة الإرسال خلال $seconds ث';
  }

  @override
  String get otpVerified => 'تم التحقق بنجاح';

  @override
  String get otpFailed => 'الرمز غير صحيح';

  @override
  String get otpExpired => 'انتهت صلاحية الرمز';

  @override
  String get didntGetCode => 'لم يصلك الرمز؟';

  @override
  String attemptsLeft(int count) {
    return 'المحاولات المتبقية: $count';
  }

  @override
  String devOtpHint(String code) {
    return 'رمز التطوير: $code';
  }

  @override
  String get codeResent => 'أُرسل رمز جديد';

  @override
  String get forgotPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get forgotPasswordDesc =>
      'أدخل رقم واتساب المسجّل في حسابك لنرسل رمز الاستعادة.';

  @override
  String get sendResetCode => 'إرسال رمز الاستعادة';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmNewPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get resetPassword => 'تحديث كلمة المرور';

  @override
  String get passwordResetSuccess =>
      'تم تحديث كلمة المرور. يمكنك تسجيل الدخول الآن.';

  @override
  String get createNewPassword => 'اختر كلمة مرور جديدة';

  @override
  String get backToLogin => 'العودة لتسجيل الدخول';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get activity => 'النشاط';

  @override
  String get usersShort => 'المستخدمون';

  @override
  String get welcomeBack => 'مرحبًا بعودتك';

  @override
  String welcomeBackUser(String name) {
    return 'مرحبًا بعودتك، $name';
  }

  @override
  String get userSubtitle => 'حسابك جاهز. ستظهر أدوات الأمن الجديدة هنا.';

  @override
  String get adminSubtitle => 'نظرة على الحسابات والصلاحيات في مساحة العمل.';

  @override
  String get totalUsers => 'إجمالي الحسابات';

  @override
  String get activeUsers => 'نشط';

  @override
  String get bannedUsers => 'محظور';

  @override
  String get inactiveUsers => 'غير نشط';

  @override
  String get recentUsers => 'أحدث الحسابات';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get upcomingTools => 'محجوز للإصدارات القادمة';

  @override
  String get upcomingToolsBody =>
      'هذه البطاقات عناصر نائبة. لا تفحص البريد ولا الروابط ولا تحلّل التهديدات.';

  @override
  String get threatAnalysis => 'تحليل التهديدات';

  @override
  String get emailScanner => 'فحص البريد';

  @override
  String get urlChecker => 'فحص الروابط';

  @override
  String get securityReports => 'تقارير الأمن';

  @override
  String get comingSoon => 'قريبًا';

  @override
  String get featureComingSoon => 'هذا الموضع محجوز لإصدار لاحق.';

  @override
  String get accountOverview => 'الحساب';

  @override
  String get mockModeBanner =>
      'وضع المعاينة. تبقى الحسابات على هذا الجهاز إلى أن تربط واجهة البرمجة.';

  @override
  String get userManagement => 'إدارة المستخدمين';

  @override
  String get searchUsers => 'ابحث بالاسم أو البريد أو الهاتف';

  @override
  String get allUsers => 'الكل';

  @override
  String get activeStatus => 'نشط';

  @override
  String get bannedStatus => 'محظور';

  @override
  String get inactiveStatus => 'غير نشط';

  @override
  String get pendingStatus => 'معلّق';

  @override
  String get editUser => 'تفاصيل الحساب';

  @override
  String get banUser => 'حظر';

  @override
  String get unbanUser => 'إلغاء الحظر';

  @override
  String get deleteUser => 'حذف الحساب';

  @override
  String get activateUser => 'تفعيل';

  @override
  String get deactivateUser => 'تعطيل';

  @override
  String get confirmBan => 'حظر هذا الحساب؟ لن يتمكن صاحبه من تسجيل الدخول.';

  @override
  String get confirmUnban => 'إلغاء الحظر والسماح بتسجيل الدخول؟';

  @override
  String get confirmDelete => 'حذف هذا الحساب؟ لن يتمكن صاحبه من تسجيل الدخول.';

  @override
  String get confirmDeactivate => 'تعطيل هذا الحساب؟';

  @override
  String get confirmActivate => 'تفعيل هذا الحساب؟';

  @override
  String get userUpdated => 'تم تحديث الحساب';

  @override
  String get userBanned => 'تم حظر الحساب';

  @override
  String get userUnbanned => 'تم إلغاء الحظر';

  @override
  String get userDeleted => 'تم حذف الحساب';

  @override
  String get userActivated => 'تم تفعيل الحساب';

  @override
  String get userDeactivated => 'تم تعطيل الحساب';

  @override
  String get roleUpdated => 'تم تحديث الدور';

  @override
  String get changeRole => 'الدور';

  @override
  String get cannotChangeSelf => 'لا يمكنك تغيير صلاحيات حسابك.';

  @override
  String get noUsersFound => 'لا توجد حسابات مطابقة';

  @override
  String get you => 'أنت';

  @override
  String get actions => 'الوصول';

  @override
  String get details => 'التفاصيل';

  @override
  String get joined => 'تاريخ الانضمام';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get editProfile => 'تعديل الملف';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get profileUpdated => 'تم تحديث الملف';

  @override
  String get passwordChanged => 'تم تغيير كلمة المرور';

  @override
  String get role => 'الدور';

  @override
  String get roleUser => 'مستخدم';

  @override
  String get roleAdmin => 'مسؤول';

  @override
  String get memberSince => 'عضو منذ';

  @override
  String get accountStatus => 'الحالة';

  @override
  String get personalInformation => 'البيانات الشخصية';

  @override
  String get securitySettings => 'كلمة المرور';

  @override
  String get verified => 'موثّق';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get theme => 'المظهر';

  @override
  String get darkMode => 'داكن';

  @override
  String get lightMode => 'فاتح';

  @override
  String get systemMode => 'تلقائي';

  @override
  String get accountSettings => 'الحساب';

  @override
  String get about => 'حول التطبيق';

  @override
  String get privacyPolicy => 'الخصوصية';

  @override
  String get termsOfService => 'الشروط';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirm => 'تسجيل الخروج من سايبر سينس على هذا الجهاز؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get ok => 'حسنًا';

  @override
  String get error => 'حدث خطأ';

  @override
  String get success => 'تم';

  @override
  String get loading => 'جارٍ التحميل';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get noData => 'لا يوجد شيء هنا بعد';

  @override
  String get save => 'حفظ';

  @override
  String get refresh => 'تحديث';

  @override
  String get appearance => 'المظهر';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get selectLanguage => 'اللغة';

  @override
  String get selectTheme => 'المظهر';

  @override
  String get version => 'الإصدار';

  @override
  String get aboutBody =>
      'سايبر سينس أساس لتطبيق أمن سيبراني: حسابات، وتحقق، وجلسات، وصلاحيات. يمكن إضافة أدوات الأمن لاحقًا دون استبدال هذا الهيكل.';

  @override
  String get privacyBody =>
      'تُحفظ كلمات المرور على الخادم بصيغة Argon2 فقط. تُحفظ رموز التحقق كبصمات وتنتهي خلال وقت قصير. يحتفظ هذا الجهاز برموز الجلسة في التخزين الآمن عند اختيار «تذكرني».';

  @override
  String get termsBody =>
      'استخدم الحساب المخصص لك. يدير المسؤولون صلاحيات مساحة العمل. لا تشارك رموز التحقق.';

  @override
  String get loginActivity => 'سجل الدخول';

  @override
  String get activityHint => 'محاولات تسجيل الدخول الأخيرة لحسابك.';

  @override
  String get adminActivityHint =>
      'محاولات تسجيل الدخول الأخيرة في مساحة العمل.';

  @override
  String get loginTime => 'الوقت';

  @override
  String get device => 'الجهاز';

  @override
  String get ipAddress => 'عنوان IP';

  @override
  String get status => 'الحالة';

  @override
  String get loginSuccess => 'ناجحة';

  @override
  String get loginFailed => 'فاشلة';

  @override
  String get noActivity => 'لا يوجد نشاط دخول بعد';

  @override
  String get reason => 'السبب';

  @override
  String get unknownDevice => 'جهاز غير معروف';

  @override
  String get sessionManagement => 'الجلسات';

  @override
  String get sessionsHint => 'الأجهزة التي ما زالت تستطيع تجديد هذا الحساب.';

  @override
  String get activeSessions => 'الجلسات النشطة';

  @override
  String get endSession => 'إنهاء الجلسة';

  @override
  String get endAllSessions => 'إنهاء كل الجلسات';

  @override
  String get currentSession => 'هذا الجهاز';

  @override
  String get confirmEndSession => 'إنهاء هذه الجلسة؟';

  @override
  String get confirmEndAllSessions => 'إنهاء كل الجلسات، بما فيها هذه الجلسة؟';

  @override
  String get sessionEnded => 'تم إنهاء الجلسة';

  @override
  String get allSessionsEnded => 'تم إنهاء كل الجلسات';

  @override
  String get noSessions => 'لا توجد جلسات نشطة';

  @override
  String get lastActive => 'آخر نشاط';

  @override
  String get started => 'بدأت';

  @override
  String get validationRequired => 'هذا الحقل مطلوب';

  @override
  String get validationEmail => 'أدخل بريدًا إلكترونيًا صحيحًا';

  @override
  String get validationPassword => 'استخدم 8 أحرف على الأقل';

  @override
  String get validationPasswordMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get validationPhone => 'أدخل رقم هاتف صحيحًا';

  @override
  String get validationName => 'أدخل اسمك';

  @override
  String get validationOtp => 'أدخل الأرقام الستة';

  @override
  String get validationPasswordStrength =>
      'أضف حرفًا كبيرًا وصغيرًا ورقمًا ورمزًا';

  @override
  String get invalidCredentials => 'البريد أو كلمة المرور غير صحيحة';

  @override
  String get accountBanned => 'هذا الحساب محظور';

  @override
  String get accountInactive => 'هذا الحساب غير نشط';

  @override
  String get tooManyAttempts => 'محاولات كثيرة. اطلب رمزًا جديدًا.';

  @override
  String get resendTooSoon => 'انتظر قليلًا قبل طلب رمز آخر';

  @override
  String get phoneNotFound => 'لا يوجد حساب مرتبط برقم واتساب هذا';

  @override
  String get emailInUse => 'يوجد حساب بهذا البريد بالفعل';

  @override
  String get phoneInUse => 'يوجد حساب بهذا الرقم بالفعل';

  @override
  String get otpSendFailed => 'تعذر إرسال الرمز. حاول مرة أخرى.';

  @override
  String get forbidden => 'ليست لديك صلاحية لهذا الإجراء';

  @override
  String get networkError => 'خطأ في الشبكة. تحقق من الاتصال.';

  @override
  String get serverError => 'تعذر على الخادم إكمال الطلب.';

  @override
  String get unauthorizedError => 'انتهت الجلسة. سجّل الدخول مرة أخرى.';

  @override
  String get unknownError => 'حدث أمر غير متوقع';
}
