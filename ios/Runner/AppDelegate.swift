import UIKit
import Flutter
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let notificationChannel = FlutterMethodChannel(name: "notifications",
                                                  binaryMessenger: controller.binaryMessenger)
    notificationChannel.setMethodCallHandler({
          [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          // Note: this method is invoked on the UI thread.
          // Handle battery messages.
          guard call.method == "clearAppNotifications" else {
              result(FlutterMethodNotImplemented)
              return
            }
            self?.clearAppNotifications(result: result)
        })

    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func clearAppNotifications(result: FlutterResult){
    if #available(IOS 10.0, *){
        application.applicationIconBadgeNumber = 0;
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        result(true);
        }
  }

}
