class TsRoleRequest {
  final String roleName;
  TsRoleRequest({
    required this.roleName,
  });

  Map<String, dynamic> toJson() {
    return {
      'roleName': roleName,
    };
  }
  debugPrint(){
    print('Role Name: $roleName');
  }
}