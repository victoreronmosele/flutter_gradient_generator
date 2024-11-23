class BannerAdConfig {
  final String supportingText;
  final String ctaButtonTitle;
  final String ctaButtonUrl;
  final bool isNew;

  BannerAdConfig({
    required this.supportingText,
    required this.ctaButtonTitle,
    required this.ctaButtonUrl,
    required this.isNew,
  });

  factory BannerAdConfig.fromJson(Map<String, dynamic> json) {
    return BannerAdConfig(
      supportingText: json['supporting_text'],
      ctaButtonTitle: json['cta_button_title'],
      ctaButtonUrl: json['cta_button_url'],
      isNew: json['is_new'],
    );
  }
}
