class UserProfile {
  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.countryCode,
    required this.phoneNational,
    required this.phoneE164,
    required this.role,
    required this.isActive,
    required this.isBanned,
    required this.isVerified,
    required this.createdAt,
    this.lastLoginAt,
  });

  final String id;
  final String fullName;
  final String email;
  final String countryCode;
  final String phoneNational;
  final String phoneE164;
  final String role;
  final bool isActive;
  final bool isBanned;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  bool get isAdmin => role == 'admin';

  String get statusKey {
    if (isBanned) return 'banned';
    if (!isActive) return 'inactive';
    return 'active';
  }

  UserProfile copyWith({
    String? fullName,
    String? countryCode,
    String? phoneNational,
    String? phoneE164,
    String? role,
    bool? isActive,
    bool? isBanned,
    DateTime? lastLoginAt,
  }) {
    return UserProfile(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email,
      countryCode: countryCode ?? this.countryCode,
      phoneNational: phoneNational ?? this.phoneNational,
      phoneE164: phoneE164 ?? this.phoneE164,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      isBanned: isBanned ?? this.isBanned,
      isVerified: isVerified,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'].toString(),
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      countryCode: json['country_code'] as String,
      phoneNational: json['phone_national'] as String,
      phoneE164: json['phone_e164'] as String,
      role: json['role'] as String,
      isActive: json['is_active'] as bool,
      isBanned: json['is_banned'] as bool,
      isVerified: json['is_verified'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      lastLoginAt: json['last_login_at'] == null ? null : DateTime.parse(json['last_login_at'] as String).toLocal(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'email': email,
        'country_code': countryCode,
        'phone_national': phoneNational,
        'phone_e164': phoneE164,
        'role': role,
        'is_active': isActive,
        'is_banned': isBanned,
        'is_verified': isVerified,
        'created_at': createdAt.toUtc().toIso8601String(),
        'last_login_at': lastLoginAt?.toUtc().toIso8601String(),
      };
}

class OtpChallenge {
  const OtpChallenge({
    required this.id,
    required this.maskedPhone,
    required this.purpose,
    required this.expiresIn,
    required this.resendIn,
    this.attemptsLeft = 5,
    this.devCode,
  });

  final String id;
  final String maskedPhone;
  final String purpose;
  final int expiresIn;
  final int resendIn;
  final int attemptsLeft;
  final String? devCode;

  factory OtpChallenge.fromJson(Map<String, dynamic> json) {
    return OtpChallenge(
      id: json['challenge_id'].toString(),
      maskedPhone: json['masked_phone'] as String,
      purpose: json['purpose'] as String,
      expiresIn: json['expires_in'] as int,
      resendIn: json['resend_in'] as int,
      attemptsLeft: (json['attempts_left'] as int?) ?? 5,
      devCode: json['dev_code'] as String?,
    );
  }
}

class AuthResult {
  const AuthResult({
    this.accessToken,
    this.refreshToken,
    this.user,
    this.resetToken,
  });

  final String? accessToken;
  final String? refreshToken;
  final UserProfile? user;
  final String? resetToken;

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
      user: json['user'] == null ? null : UserProfile.fromJson(json['user'] as Map<String, dynamic>),
      resetToken: json['reset_token'] as String?,
    );
  }
}

class UserStats {
  const UserStats({required this.total, required this.active, required this.banned, required this.inactive});

  final int total;
  final int active;
  final int banned;
  final int inactive;

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      total: json['total'] as int,
      active: json['active'] as int,
      banned: json['banned'] as int,
      inactive: json['inactive'] as int,
    );
  }
}

class LoginActivity {
  const LoginActivity({
    required this.id,
    required this.email,
    required this.success,
    required this.deviceName,
    required this.ipAddress,
    required this.createdAt,
    this.userName,
    this.reason,
  });

  final String id;
  final String? userName;
  final String email;
  final bool success;
  final String deviceName;
  final String ipAddress;
  final String? reason;
  final DateTime createdAt;

  factory LoginActivity.fromJson(Map<String, dynamic> json) {
    return LoginActivity(
      id: json['id'].toString(),
      userName: json['user_name'] as String?,
      email: json['email'] as String,
      success: json['success'] as bool,
      deviceName: (json['device_name'] as String?)?.isNotEmpty == true ? json['device_name'] as String : '',
      ipAddress: (json['ip_address'] as String?) ?? '',
      reason: json['failure_reason'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
    );
  }
}

class UserSession {
  const UserSession({
    required this.id,
    required this.deviceName,
    required this.ipAddress,
    required this.createdAt,
    required this.lastUsedAt,
    required this.current,
  });

  final String id;
  final String deviceName;
  final String ipAddress;
  final DateTime createdAt;
  final DateTime lastUsedAt;
  final bool current;

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      id: json['id'].toString(),
      deviceName: (json['device_name'] as String?) ?? '',
      ipAddress: (json['ip_address'] as String?) ?? '',
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      lastUsedAt: DateTime.parse(json['last_used_at'] as String).toLocal(),
      current: json['current'] as bool? ?? false,
    );
  }
}
