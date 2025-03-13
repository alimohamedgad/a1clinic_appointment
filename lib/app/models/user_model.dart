import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../common/uuid.dart';
import '../services/settings_service.dart';
import 'media_model.dart';
import 'parents/model.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';
import 'dart:typed_data';
class User extends Model {

  String key = "A1h2m3e4d5a1c6l7";  // تأكد أن المفتاح هو 16 بايت فقط

  String? _name;
  String? _email;
  String? _password;
  Media? _avatar;
  String? _apiToken;
  String? _deviceToken;
  String? _phoneNumber;
  bool? _verifiedPhone;
  String? _verificationId;
  String? _address;
  String? _bio;
  bool? _auth;
  String otpCode = "00000";

  User(
      {String? id,
        String? name,
        String? email,
        String? password,
        String? apiToken,
        String? deviceToken,
        String? phoneNumber,
        String? verificationId,
        String? address,
        String? bio,
        Media? avatar,
        bool? auth}) {
    this.id = id;
    _auth = auth;
    _bio = bio;
    _address = address;
    _verificationId = verificationId;
    _phoneNumber = phoneNumber;
    _deviceToken = deviceToken;
    _apiToken = apiToken;
    _avatar = avatar;
    _password = password;
    _email = email;
    _name = name;
  }

  User.fromJson(Map<String, dynamic>? json) {
    _name = decryptData(stringFromJson(json, 'name'), key);
    _email = decryptData(stringFromJson(json, 'email'), key);
    _apiToken = stringFromJson(json, 'api_token');
    _deviceToken = stringFromJson(json, 'device_token');
    _phoneNumber = decryptData(stringFromJson(json, 'phone_number'), key);
    _verifiedPhone = boolFromJson(json, 'phone_verified_at');
    _avatar = mediaFromJson(json, 'avatar');
    _auth = boolFromJson(json, 'auth');
    try {
      _address = decryptData(json?['custom_fields']['address']['view'],key);
    } catch (e) {
      _address =decryptData(stringFromJson(json, 'address'), key);
    }
    try {
      _bio = decryptData(json?['custom_fields']['bio']['view'],key);
    } catch (e) {
      _bio = decryptData(stringFromJson(json, 'bio'), key);

    }
    super.fromJson(json);
  }

  String get address => _address ?? '';

  set address(String? value) {
    _address = value;
  }

  String get apiToken {
    if ((_auth ?? false)) {
      return _apiToken ?? '';
    } else {
      return '';
    }
  }

  set apiToken(String? value) {
    _apiToken = value;
  }

  bool? get auth => _auth;

  set auth(bool? value) {
    _auth = value;
  }

  Media get avatar => _avatar ?? Media();

  set avatar(Media? value) {
    _avatar = value;
  }

  String get bio => _bio ?? '';

  set bio(String? value) {
    _bio = value;
  }

  String get deviceToken => _deviceToken ?? '';

  set deviceToken(String? value) {
    _deviceToken = value;
  }

  String get email => _email ?? '';

  set email(String? value) {
    _email = value;
  }

  @override
  int get hashCode =>
      super.hashCode ^
      name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      avatar.hashCode ^
      apiToken.hashCode ^
      deviceToken.hashCode ^
      phoneNumber.hashCode ^
      verifiedPhone.hashCode ^
      verificationId.hashCode ^
      address.hashCode ^
      bio.hashCode ^
      auth.hashCode;

  String get name => _name ?? '';

  set name(String? value) {
    _name = value;
  }

  String get password => _password ?? '';

  set password(String? value) {
    _password = value;
  }

  String get phoneNumber => _phoneNumber ?? '';

  set phoneNumber(String? value) {
    _phoneNumber = value;
  }

  String get verificationId => _verificationId ?? '';

  set verificationId(String? value) {
    _verificationId = value;
  }

  bool get verifiedPhone => _verifiedPhone ?? false;

  set verifiedPhone(bool value) {
    _verifiedPhone = value;
  }

  @override
  bool operator ==(dynamic other) =>
      super == other &&
          other is User &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email &&
          password == other.password &&
          avatar == other.avatar &&
          apiToken == other.apiToken &&
          deviceToken == other.deviceToken &&
          phoneNumber == other.phoneNumber &&
          verifiedPhone == other.verifiedPhone &&
          verificationId == other.verificationId &&
          address == other.address &&
          bio == other.bio &&
          auth == other.auth;

  PhoneNumber getPhoneNumber() {
    if (this._phoneNumber != null && this._phoneNumber!.length > 4) {
      this.phoneNumber = this.phoneNumber.replaceAll(' ', '');
      String dialCode1 = this.phoneNumber.substring(1, 2);
      String dialCode2 = this.phoneNumber.substring(1, 3);
      String dialCode3 = this.phoneNumber.substring(1, 4);
      for (int i = 0; i < countries.length; i++) {
        if (countries[i].dialCode == dialCode1) {
          return new PhoneNumber(countryISOCode: countries[i].code, countryCode: dialCode1, number: this.phoneNumber.substring(2));
        } else if (countries[i].dialCode == dialCode2) {
          return new PhoneNumber(countryISOCode: countries[i].code, countryCode: dialCode2, number: this.phoneNumber.substring(3));
        } else if (countries[i].dialCode == dialCode3) {
          return new PhoneNumber(countryISOCode: countries[i].code, countryCode: dialCode3, number: this.phoneNumber.substring(4));
        }
      }
    }
    return new PhoneNumber(countryISOCode: Get.find<SettingsService>().setting.value.defaultCountryCode ?? '', countryCode: '1', number: '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = encryptData(this.name,key);
    data['email'] = encryptData(this.email,key);
    if (_password != null && _password != '') {
      data['password'] = this.password;
    }
    data['api_token'] = this._apiToken;
    if (_deviceToken != null) {
      data["device_token"] = deviceToken;
    }
    data["phone_number"] = encryptData(phoneNumber,key);
    if (verifiedPhone) {
      data["phone_verified_at"] = DateTime.now().toLocal().toString();
    }
    data["address"] = encryptData(address,key);
    data["bio"] = encryptData(bio,key);
    if (Uuid.isUuid(avatar.id)) {
      data['avatar'] = this.avatar.id;
    }
    data["media"] = [avatar.toJson()];
    data['auth'] = this.auth;
    data['otp_code'] =otpCode;
    return data;
  }

  Map toRestrictMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["thumb"] = avatar.thumb;
    map["device_token"] = deviceToken;
    return map;
  }

  String encryptData(String data, String key) {

    if (data.isEmpty) {
      return data;
    }

    final keyBytes = utf8.encode(key.padRight(16, ' ')); // تمديد المفتاح ليكون طوله 16 بايت
    final encrypter = encrypt.Encrypter(
      encrypt.AES(encrypt.Key.fromUtf8(String.fromCharCodes(keyBytes)), mode: encrypt.AESMode.ecb),
    );

    // تحويل البيانات إلى بايتات
    final dataBytes = utf8.encode(data);

    // تشفير البيانات
    final encrypted = encrypter.encryptBytes(dataBytes);

    // تحويل البيانات المشفرة إلى Base64 وإرجاعها
    return encrypted.base64;
  }

  static String decryptData(String encryptedData, String key) {
    // التأكد من أن طول المفتاح 16 بايت فقط
    if (key.length != 16) {
      throw Exception("المفتاح يجب أن يكون 16 بايت فقط.");
    }

    // التأكد من أن البيانات المشفرة ليست فارغة
    if (encryptedData.isEmpty) {
      //throw Exception("البيانات المشفرة فارغة.");
      return encryptedData;
    }

    // تحويل المفتاح إلى بايتات
    final keyBytes = utf8.encode(key);

    // تحويل البيانات المشفرة من Base64 إلى بايتات
    List<int> encryptedBytes;
    try {
      encryptedBytes = base64.decode(encryptedData);
    } catch (e) {
      return encryptedData;
     // throw Exception(" ${encryptedData} خطأ في فك تشفير البيانات من Base64.");
    }

    if (encryptedBytes.isEmpty) {
      return encryptedData;
     // throw Exception("البيانات المشفرة غير صالحة.");
    }

    // تحويل List<int> إلى Uint8List
    Uint8List encryptedUint8List = Uint8List.fromList(encryptedBytes);

    // إعداد خوارزمية AES-128-ECB
    final encrypter = encrypt.Encrypter(
      encrypt.AES(encrypt.Key.fromUtf8(String.fromCharCodes(keyBytes)), mode: encrypt.AESMode.ecb),
    );

    // فك تشفير البيانات
    final decrypted = encrypter.decryptBytes(encrypt.Encrypted(encryptedUint8List));

    // تحويل البيانات المفكوك تشفيرها إلى نص
    return utf8.decode(decrypted);
  }
}
