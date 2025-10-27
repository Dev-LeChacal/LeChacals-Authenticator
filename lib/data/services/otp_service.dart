import "package:otp/otp.dart";

class OTPService {
  OTPService._();

  static String generateTOTP(
    String secret, {
    int length = 6,
    Algorithm algorithm = Algorithm.SHA1,
  }) {
    try {
      return OTP.generateTOTPCodeString(
        secret.replaceAll(" ", "").toUpperCase(),
        DateTime.now().millisecondsSinceEpoch,
        length: length,
        algorithm: algorithm,
        isGoogle: true,
      );
    } catch (e) {
      return List.filled(length, "-").join();
    }
  }

  static int getRemainingSeconds({int period = 30}) {
    return period - (DateTime.now().second % period);
  }
}
