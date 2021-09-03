class UserModel {
  String id;
  String firstName;
  String surName;
  String fullName;
  String email;
  String birthDate;
  String profilePhoto;
  List friendIds;

  UserModel(
      {this.birthDate,
      this.email,
      this.firstName,
      this.friendIds,
      this.fullName,
      this.id,
      this.profilePhoto,
      this.surName});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    firstName = json['FirstName'];
    surName = json['LastName'];
    fullName = json['FullName'];
    email = json['Email'];
    birthDate = json['BirthDate'];
    profilePhoto = json['ProfilePhoto'];
    friendIds = json['FriendIds'];
  }
}
