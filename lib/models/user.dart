import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class User {
  final String id;
  final String username;
  final String password;
  final String phonenumber;
  final bool canAdd;
  final bool canEdit;
  final bool canEditAll;
  final bool canDelete;
  final bool canDeleteAll;
  final String sessionToken;

  const User({
    required this.id,
    required this.username,
    required this.password,
    required this.phonenumber,
    required this.canAdd,
    required this.canEdit,
    required this.canEditAll,
    required this.canDelete,
    required this.canDeleteAll,
    required this.sessionToken,
  });

  factory User.userFromParseUser(ParseUser parseUser) {
    return User(
      id: parseUser.objectId ?? '',
      username: parseUser.get<String>('username') ?? '',
      password: '', // Passwords aren't readable from ParseUser
      phonenumber: parseUser.get<String>('phonenumber') ?? '',
      canAdd: parseUser.get<bool>('canAdd') ?? false,
      canEdit: parseUser.get<bool>('canEdit') ?? false,
      canEditAll: parseUser.get<bool>('canEditAll') ?? false,
      canDelete: parseUser.get<bool>('canDelete') ?? false,
      canDeleteAll: parseUser.get<bool>('canDeleteAll') ?? false,
      sessionToken: parseUser.sessionToken ?? '',
    );
  }
}
