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

  static String generateNextTOTP(
    String secret, {
    int length = 6,
    int period = 30,
    Algorithm algorithm = Algorithm.SHA1,
  }) {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final currentPeriod = now ~/ (period * 1000);
      final nextPeriodTimestamp = (currentPeriod + 1) * period * 1000;

      return OTP.generateTOTPCodeString(
        secret.replaceAll(" ", "").toUpperCase(),
        nextPeriodTimestamp,
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
