import "package:vibration/vibration.dart";

class VibrationService {
  VibrationService._();

  static void light() => Vibration.vibrate(duration: 50, amplitude: 10);
  static void medium() => Vibration.vibrate(duration: 100, amplitude: 50);
  static void heavy() => Vibration.vibrate(duration: 100, amplitude: 100);

  static void deleteVibration() =>
      Vibration.vibrate(pattern: [0, 50, 50, 50], intensities: [0, 100, 0, 100]);

  static void cancelVibration() =>
      Vibration.vibrate(pattern: [0, 30, 40, 30], intensities: [0, 50, 0, 50]);

  static void successVibration() => Vibration.vibrate(
    pattern: [0, 40, 30, 40, 30, 60],
    intensities: [0, 80, 0, 80, 0, 120],
  );
}
