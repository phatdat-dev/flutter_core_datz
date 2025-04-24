import 'package:flutter/material.dart';
import 'package:flutter_core_datz/flutter_core_datz.dart';

import '../core/base_view.dart';
import 'response/state_response.dart';

class UserModel extends BaseModel<UserModel> {
  String? userName;
  String? password;
  int? userId;
  ResPartner? resPartner;
  String? token;

  final ValueNotifier<RolesEnum> role = ValueNotifier(RolesEnum.admin);

  UserModel({
    this.userName,
    this.password,
    this.userId,
    this.resPartner,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userName: json['user_name'],
        password: json['password'] ?? json['pwd'],
        userId: (json['user_id'] as num?)?.toInt(),
        resPartner: json['res_partner'] != null ? ResPartner().fromJson(json['res_partner']) : null,
      );

  @override
  UserModel fromJson(Map<String, dynamic> json) => UserModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (userName != null) {
      data['user_name'] = userName;
      data['uname'] = userName;
    }
    if (password != null) {
      data['password'] = password;
      data['pwd'] = password;
    }
    if (userId != null) {
      data['user_id'] = userId;
    }
    if (resPartner != null) {
      data['res_partner'] = resPartner?.toJson();
    }
    data["company"] = [1, 2];
    return data;
  }

  UserModel copyWith({
    String? userName,
    String? password,
    int? userId,
    ResPartner? resPartner,
  }) {
    return UserModel(
      userName: userName ?? this.userName,
      password: password ?? this.password,
      userId: userId ?? this.userId,
      resPartner: resPartner ?? this.resPartner,
    );
  }
}

class ResPartner extends BaseModel<ResPartner> {
  int? id;
  String? name;
  String? phone;
  String? idNo;
  String? yob;
  String? gender;
  String? email;
  StateResponse? countryId;

  ResPartner({
    this.id,
    this.name,
    this.phone,
    this.idNo,
    this.yob,
    this.gender,
    this.email,
    this.countryId,
  });

  factory ResPartner.fromJson(Map<String, dynamic> json) => ResPartner(
        id: (json['id'] as num?)?.toInt(),
        name: json['name'],
        phone: json['phone'] ?? json['mobile'],
        idNo: json['id_no'] is String? ? json['id_no'] : null,
        yob: json['yob']?.toString(),
        gender: json['gender'],
        email: json['email'],
        countryId: json['country_id'] != null ? StateResponse(id: json['country_id'][0], name: json['country_id'][1]) : null,
      );

  @override
  ResPartner fromJson(Map<String, dynamic> json) => ResPartner.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    if (name != null) {
      data['name'] = name;
    }
    if (phone != null) {
      data['mobile'] = phone;
    }
    if (idNo != null) {
      data['id_no'] = idNo;
    }
    if (yob != null) {
      data['yob'] = yob;
    }
    if (gender != null) {
      data['gender'] = gender;
    }
    if (email != null) {
      data['email'] = email;
    }
    if (countryId != null) {
      data['country_id'] = countryId?.id;
    }
    return data;
  }

  ResPartner copyWith({
    int? id,
    String? name,
    String? mobile,
    String? idNo,
    String? yob,
    String? gender,
    String? email,
    StateResponse? countryId,
  }) {
    return ResPartner(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: mobile ?? phone,
      idNo: idNo ?? this.idNo,
      yob: yob ?? this.yob,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      countryId: countryId ?? this.countryId,
    );
  }
}
