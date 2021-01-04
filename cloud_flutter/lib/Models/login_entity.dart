class LoginEntity {
	LoginData data;
	String message;
	int status;

	LoginEntity({this.data, this.message, this.status});

	LoginEntity.fromJson(Map<String, dynamic> json) {
		data = json['data'] != null ? new LoginData.fromJson(json['data']) : null;
		message = json['message'];
		status = json['status'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.data != null) {
      data['data'] = this.data.toJson();
    }
		data['message'] = this.message;
		data['status'] = this.status;
		return data;
	}
}

class LoginData {
	int role;
	int createTime;
	String phone;
	String nickname;
	String headimgurl;
	String id;
	String userName;

	LoginData({this.role, this.createTime, this.phone, this.nickname, this.headimgurl, this.id, this.userName});

	LoginData.fromJson(Map<String, dynamic> json) {
		role = json['role'];
		createTime = json['createTime'];
		phone = json['phone'];
		nickname = json['nickname'];
		headimgurl = json['headimgurl'];
		id = json['id'];
		userName = json['userName'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['role'] = this.role;
		data['createTime'] = this.createTime;
		data['phone'] = this.phone;
		data['nickname'] = this.nickname;
		data['headimgurl'] = this.headimgurl;
		data['id'] = this.id;
		data['userName'] = this.userName;
		return data;
	}
}
