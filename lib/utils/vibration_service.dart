import "package:vibration/vibration.dart";

class VibrationService {
  VibrationService._();

  static void copyVibration() => Vibration.vibrate(duration: 50, amplitude: 10);
  static void reorderVibration() => Vibration.vibrate(duration: 100, amplitude: 50);
  static void deleteDialogVibration() => Vibration.vibrate(duration: 100, amplitude: 100);
}
