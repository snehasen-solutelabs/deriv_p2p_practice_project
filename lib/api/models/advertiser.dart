/// Advertiser
class Advertiser {
  /// Advertiser const
  Advertiser(
      {this.firstName,
      this.id,
      this.lastName,
      this.name,
      this.totalCompletionRate});

  /// Advertiser const
  factory Advertiser.fromMap(Map<String, dynamic> advertiser) => Advertiser(
      firstName: advertiser['first_name'],
      id: advertiser['id'],
      lastName: advertiser['last_name'],
      name: advertiser['name'],
      totalCompletionRate: advertiser['completion_rate'] != null
          ? (advertiser['completion_rate'] as num).toDouble()
          : (advertiser['total_completion_rate'] != null
              ? (advertiser['total_completion_rate'] as num).toDouble()
              : null));

  /// firstName val
  final String? firstName;

  /// id val
  final String? id;

  /// lastName val
  final String? lastName;

  /// name val
  final String? name;

  // ignore: public_member_api_docs
  final double? totalCompletionRate;
}
