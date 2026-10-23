class CountryDial {
  const CountryDial({
    required this.iso,
    required this.dial,
    required this.nameEn,
    required this.nameAr,
    required this.flag,
  });

  final String iso;
  final String dial;
  final String nameEn;
  final String nameAr;
  final String flag;

  String name(String languageCode) => languageCode == 'ar' ? nameAr : nameEn;
}

const countries = <CountryDial>[
  CountryDial(iso: 'AE', dial: '+971', nameEn: 'United Arab Emirates', nameAr: 'الإمارات', flag: '🇦🇪'),
  CountryDial(iso: 'SA', dial: '+966', nameEn: 'Saudi Arabia', nameAr: 'السعودية', flag: '🇸🇦'),
  CountryDial(iso: 'KW', dial: '+965', nameEn: 'Kuwait', nameAr: 'الكويت', flag: '🇰🇼'),
  CountryDial(iso: 'QA', dial: '+974', nameEn: 'Qatar', nameAr: 'قطر', flag: '🇶🇦'),
  CountryDial(iso: 'BH', dial: '+973', nameEn: 'Bahrain', nameAr: 'البحرين', flag: '🇧🇭'),
  CountryDial(iso: 'OM', dial: '+968', nameEn: 'Oman', nameAr: 'عُمان', flag: '🇴🇲'),
  CountryDial(iso: 'EG', dial: '+20', nameEn: 'Egypt', nameAr: 'مصر', flag: '🇪🇬'),
  CountryDial(iso: 'JO', dial: '+962', nameEn: 'Jordan', nameAr: 'الأردن', flag: '🇯🇴'),
  CountryDial(iso: 'LB', dial: '+961', nameEn: 'Lebanon', nameAr: 'لبنان', flag: '🇱🇧'),
  CountryDial(iso: 'IQ', dial: '+964', nameEn: 'Iraq', nameAr: 'العراق', flag: '🇮🇶'),
  CountryDial(iso: 'MA', dial: '+212', nameEn: 'Morocco', nameAr: 'المغرب', flag: '🇲🇦'),
  CountryDial(iso: 'TN', dial: '+216', nameEn: 'Tunisia', nameAr: 'تونس', flag: '🇹🇳'),
  CountryDial(iso: 'DZ', dial: '+213', nameEn: 'Algeria', nameAr: 'الجزائر', flag: '🇩🇿'),
  CountryDial(iso: 'PS', dial: '+970', nameEn: 'Palestine', nameAr: 'فلسطين', flag: '🇵🇸'),
  CountryDial(iso: 'TR', dial: '+90', nameEn: 'Turkey', nameAr: 'تركيا', flag: '🇹🇷'),
  CountryDial(iso: 'GB', dial: '+44', nameEn: 'United Kingdom', nameAr: 'المملكة المتحدة', flag: '🇬🇧'),
  CountryDial(iso: 'US', dial: '+1', nameEn: 'United States', nameAr: 'الولايات المتحدة', flag: '🇺🇸'),
  CountryDial(iso: 'IN', dial: '+91', nameEn: 'India', nameAr: 'الهند', flag: '🇮🇳'),
];

CountryDial countryByDial(String dial) {
  return countries.firstWhere((item) => item.dial == dial, orElse: () => countries.first);
}
