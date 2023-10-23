class user {
  int? user_id;
  String? user_type;
  String? organization_name;
  String? office_location;
  String? username;
  String? password_hash;
  String? email;
  String? role;
  int? created_by;
  String? created_at;

  user({this.user_id,this.user_type,this.organization_name,this.office_location,this.username,this.password_hash,this.email,this.role,
    this.created_by,this.created_at});

  user.fromJson(Map<String, dynamic> json) {
    user_id= json['user_id'];
    user_type=json['user_type'];
    organization_name=json['organization_name'];
    office_location=json['office_location'];
    username=json['username'];
    password_hash=json['password_hash'];
    email=json['email'];
    role=json['role'];
    created_by=json['created_by'];
    created_at=json['created_at'];
  }
}