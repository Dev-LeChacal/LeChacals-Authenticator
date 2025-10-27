import "dart:async";
import "package:lechacals_authenticator/data/services/otp_service.dart";

class TimerManager {
  Timer? _timer;
  int remainingSeconds = 30;

  void startTimer(Function(int) onTick, Function() onCycleComplete) {
    remainingSeconds = OTPService.getRemainingSeconds();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingSeconds = OTPService.getRemainingSeconds();
      onTick(remainingSeconds);

      if (remainingSeconds == 30) {
        onCycleComplete();
      }
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}
