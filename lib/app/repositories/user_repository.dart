import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/user_model.dart';
import '../providers/firebase_provider.dart';
import '../providers/laravel_provider.dart';
import '../services/auth_service.dart';

class UserRepository {
  late LaravelApiClient _laravelApiClient;
  late FirebaseProvider _firebaseProvider;

  UserRepository() {}

 /* Future<User> login(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.login(user);
  }*/

  Future<User> checkOtpAndLogin(User user,String smsCode) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.checkOtpAndLogin(user,smsCode);
  }
  Future<User> loginWithOutOtp(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.loginWithOutOtp(user);
  }

  Future<String> sendOtpUserProfile(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.sendOtpUserProfile(user);
  }
  Future<User> updateUserWithOutOtp(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.updateUserWithOutOtp(user);
  }

  Future<String> checkUser(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.checkUser(user);
  }

  Future<User> get(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getUser(user);
  }

  Future<User> update(User user,[String smsCode="0"]) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.updateUser(user,smsCode);
  }

  Future<bool> sendResetLinkEmail(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.sendResetLinkEmail(user);
  }

  Future<User> getCurrentUser() {
    return this.get(Get.find<AuthService>().user.value);
  }

  Future<void> deleteCurrentUser() async {
    _laravelApiClient = Get.find<LaravelApiClient>();
    _firebaseProvider = Get.find<FirebaseProvider>();
    await _laravelApiClient.deleteUser(Get.find<AuthService>().user.value);
    await _firebaseProvider.deleteCurrentUser();
    Get.find<AuthService>().user.value = new User();
    GetStorage().remove('current_user');
  }

 /* Future<User> register(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.register(user);
  }*/

  Future<String> registerByPhone(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.registerByPhone(user);
  }


  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.signInWithEmailAndPassword(email, password);
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.signUpWithEmailAndPassword(email, password);
  }

  Future<void> verifyPhone(String smsCode) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.verifyPhone(smsCode);
  }

  Future<void> sendCodeToPhone() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.sendCodeToPhone();


  }

  Future<String>resendOTPCode(User user,String smsCode) async {

    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.resendOTPCode(user,smsCode);
  }

  Future signOut() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return await _firebaseProvider.signOut();
  }
  Future deleteAccount() async{
      _firebaseProvider = Get.find<FirebaseProvider>();
      return await _firebaseProvider.signOut();
  }
}
