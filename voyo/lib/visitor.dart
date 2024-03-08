import 'dart:ffi';

class User {
  int? Id;
  String? Name;
  String? Email;
  String? Password;
  String? FirstName;
  String? City;
  bool? IsActive;
  String? PhoneNumber;
  String? ProfilPicture;

  User(
      {this.Id,
      this.Name,
      this.Email,
      this.Password,
      this.FirstName,
      this.City,
      this.IsActive,
      this.PhoneNumber,
      this.ProfilPicture});

  User.fromJson(Map<String, dynamic> json) {
    Id = json['Id'];
    Name = json['Name'];
    Email = json['Email'];
    Password = json['Password'];
    FirstName = json['FirstName'];
    City = json['City'];
    IsActive = json['IsActive'];
    PhoneNumber = json['PhoneNumber'];
    ProfilPicture = json['ProfilPicture'];
  }
}

class Visitor {
  int? Id;
  String? Name;
  String? FirstName;
  String? ProfilPicture;
  String? Street;
  double? HourlyRate;
  int? PostalCode;
  int? Rating;
  Float? Price;

  Visitor(
      {this.Id,
      this.Name,
      this.FirstName,
      this.ProfilPicture,
      this.Street,
      this.HourlyRate,
      this.PostalCode,
      this.Rating,
      this.Price});


  Visitor.fromJson(Map<String, dynamic> json) {
    Id = json['Id'];
    Name = json['User']['Name'];
    FirstName = json['User']['FirstName'];
    ProfilPicture = json['User']['ProfilPicture'];
    Street = json['Street'];
    HourlyRate = json['HourlyRate'];
    PostalCode = json['PostalCode'];
    Rating = json['Rating'];
    Price = json['Price'];
  }
}
