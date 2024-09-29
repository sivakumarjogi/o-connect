import 'package:equatable/equatable.dart';
import 'package:o_connect/ui/views/meeting/model/model.dart';

class GuestUser extends Equatable {
  final int ocUid;
  final String firstName;
  final String lastName;
  final String profilePic;
  final String nationality;
  final String emailId;
  final String? ri;

  const GuestUser({
    required this.ocUid,
    required this.firstName,
    required this.lastName,
    required this.profilePic,
    required this.nationality,
    required this.emailId,
    this.ri,
  });

  factory GuestUser.fromJson(Map<String, dynamic> json, int ocUid) {
    return GuestUser(
      ocUid: ocUid,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      profilePic: json['profilePic'] ?? '',
      nationality: json['nationality'] ?? '',
      emailId: json['emailId'] ?? '',
      ri: json['ri'],
    );
  }

  factory GuestUser.fromHubUser(HubUserData hubUser) {
    return GuestUser(
      ocUid: hubUser.id!,
      firstName: hubUser.displayName ?? "",
      lastName: "",
      profilePic: hubUser.profilePic ?? "",
      nationality: hubUser.country ?? "",
      emailId: hubUser.email ?? "",
      ri: hubUser.roomId,
    );
  }

  @override
  List<Object?> get props => [ocUid, firstName, lastName, emailId, ri];
}
