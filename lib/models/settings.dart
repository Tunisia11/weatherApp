class SettingsModel {
  final String language;
  final bool darkTheme;
  final bool enableAlerts;
  final bool enableNotifications;

  SettingsModel({
    required this.language,
    required this.darkTheme,
    required this.enableAlerts,
    required this.enableNotifications,
  });

  SettingsModel copyWith({
    String? language,
    bool? darkTheme,
    bool? enableAlerts,
    bool? enableNotifications,
  }) {
    return SettingsModel(
      language: language ?? this.language,
      darkTheme: darkTheme ?? this.darkTheme,
      enableAlerts: enableAlerts ?? this.enableAlerts,
      enableNotifications: enableNotifications ?? this.enableNotifications,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'language': language,
      'darkTheme': darkTheme,
      'enableAlerts': enableAlerts,
      'enableNotifications': enableNotifications,
    };
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      language: map['language'] ?? 'en',
      darkTheme: map['darkTheme'] ?? false,
      enableAlerts: map['enableAlerts'] ?? true,
      enableNotifications: map['enableNotifications'] ?? true,
    );
  }

  factory SettingsModel.defaultSettings() {
    return SettingsModel(
      language: 'en',
      darkTheme: false,
      enableAlerts: true,
      enableNotifications: true,
    );
  }
}