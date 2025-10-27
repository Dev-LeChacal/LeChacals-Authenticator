import "package:home_widget/home_widget.dart";
import "package:lechacals_authenticator/data/models/account.dart";

class WidgetUpdater {
  static void updateWidget(Account account, String code, String path) {
    // save data
    HomeWidget.saveWidgetData<String>("account_name", account.name);
    HomeWidget.saveWidgetData<String>("account_code", code);
    HomeWidget.saveWidgetData<String>("screenshot", path);

    HomeWidget.updateWidget(androidName: "LeChacalsAuthenticatorWidget");
  }
}
