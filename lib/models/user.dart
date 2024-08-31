class User {
  final int id;
  final String username;
  final String password;
  final String phonenumber;
  final bool canAdd;
  final bool canEdit;
  final bool canEditAll;
  final bool canDelete;
  final bool canDeleteAll;

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
  });
}
