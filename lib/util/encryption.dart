import 'package:encrypt/encrypt.dart';
import 'package:notes/_app_packages.dart';

class Encrypt {
  Encrypt(String password) {
    final myKey = password.padLeft(32, '#');
    key = Key.fromUtf8(myKey);
    iv = IV.fromLength(16);
    encrypter = Encrypter(
      AES(key),
    );
  }

  late Key key;

  late IV iv;

  late Encrypter encrypter;

  void resetDetails(String password) {
    final myKey = password.padLeft(32, '#');
    key = Key.fromUtf8(myKey);
    iv = IV.fromLength(16);
    encrypter = Encrypter(
      AES(key),
    );
  }

  void encrypt(Note copiedNote) {
    if (copiedNote.title.isNotEmpty) {
      copiedNote.title = encrypter.encrypt(copiedNote.title, iv: iv).base64;
    }
    if (copiedNote.content.isNotEmpty) {
      copiedNote.content = encrypter.encrypt(copiedNote.content, iv: iv).base64;
    }
  }

  void decrypt(Note copiedNote) {
    if (copiedNote.title.isNotEmpty) {
      copiedNote.title = encrypter.decrypt64(copiedNote.title, iv: iv);
    }
    if (copiedNote.content.isNotEmpty) {
      copiedNote.content = encrypter.decrypt64(copiedNote.content, iv: iv);
    }
  }
  String? decryptStr(String? str) {
    if (str == null) {
      return null;
    }
    return encrypter.decrypt64(str, iv: iv);
  }
  String encryptStr(String str) {
    return encrypter.encrypt(str, iv: iv).base64;
  }
}