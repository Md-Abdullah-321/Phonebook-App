// contact_model.dart

class ContactModel {
  String id;
  String firstName;
  String lastName;
  List<PhoneNumber> phoneNumbers;
  List<EmailAddress> emailAddresses;
  List<AddressElement> addresses;
  DateTime birthdate;
  String category;
  DateTime creationDate;
  DateTime lastUpdated;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String? profile; // Make profile nullable

  ContactModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumbers,
    required this.emailAddresses,
    required this.addresses,
    required this.birthdate,
    required this.category,
    required this.creationDate,
    required this.lastUpdated,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.profile, // Include profile as optional parameter
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumbers: (json['phoneNumbers'] as List<dynamic>)
          .map((phoneNumberJson) => PhoneNumber.fromJson(phoneNumberJson))
          .toList(),
      emailAddresses: (json['emailAddresses'] as List<dynamic>)
          .map((emailAddressJson) => EmailAddress.fromJson(emailAddressJson))
          .toList(),
      addresses: (json['addresses'] as List<dynamic>)
          .map((addressElementJson) =>
              AddressElement.fromJson(addressElementJson))
          .toList(),
      birthdate: DateTime.parse(json['birthdate']),
      category: json['category'],
      creationDate: DateTime.parse(json['creationDate']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
      profile: json['profile'], // Assign profile value from JSON
    );
  }
}

class AddressElement {
  Address address;
  String type;
  String id;

  AddressElement({
    required this.address,
    required this.type,
    required this.id,
  });

  factory AddressElement.fromJson(Map<String, dynamic> json) {
    return AddressElement(
      address: Address.fromJson(json['address']),
      type: json['type'],
      id: json['_id'],
    );
  }
}

class Address {
  String division;
  String district;
  String thana;
  String union;

  Address({
    required this.division,
    required this.district,
    required this.thana,
    required this.union,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      division: json['division'],
      district: json['district'],
      thana: json['thana'],
      union: json['union'],
    );
  }
}

class EmailAddress {
  String type;
  String email;
  String id;

  EmailAddress({
    required this.type,
    required this.email,
    required this.id,
  });

  factory EmailAddress.fromJson(Map<String, dynamic> json) {
    return EmailAddress(
      type: json['type'],
      email: json['email'],
      id: json['_id'],
    );
  }
}

class PhoneNumber {
  String type;
  String number;
  String id;

  PhoneNumber({
    required this.type,
    required this.number,
    required this.id,
  });

  factory PhoneNumber.fromJson(Map<String, dynamic> json) {
    return PhoneNumber(
      type: json['type'],
      number: json['number'],
      id: json['_id'],
    );
  }
}
