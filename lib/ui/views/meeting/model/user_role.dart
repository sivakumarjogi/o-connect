enum UserRole {
  host("Host"),
  coHost("Co-host"),
  guest("Guest"),
  speaker("Attendee"),
  // app specific roles. doesn't exit in server. used to control actions
  // displayed to the user
  activeHost("activeHost"),
  tempBlocked("tempBlocked"),
  unknown("None");

  final String roleKey;

  const UserRole(this.roleKey);

  static UserRole fromKey(String key) {
    final matched = UserRole.values.where((e) => e.roleKey == key);
    if (matched.isNotEmpty) return matched.first;
    return UserRole.unknown;
  }
}
