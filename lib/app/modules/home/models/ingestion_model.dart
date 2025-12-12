class IngestionResponse {
  final bool ok;
  final bool allowed;
  final String? reason;
  final Map<String, dynamic>? details;

  IngestionResponse({
    required this.ok,
    required this.allowed,
    this.reason,
    this.details,
  });

  factory IngestionResponse.fromJson(Map<String, dynamic> json) {
    return IngestionResponse(
      ok: json['ok'] == true,
      allowed: json['allowed'] == true,
      reason: json['reason'] as String?,
      details: (json['details'] as Map?)?.cast<String, dynamic>(),
    );
  }
}
