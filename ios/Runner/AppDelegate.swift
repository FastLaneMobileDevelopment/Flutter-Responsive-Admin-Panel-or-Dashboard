import UIKit
import Flutter
import GoogleMaps


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  func registerPluginsFunc(registry: FlutterPluginRegistry) {
        GeneratedPluginRegistrant.register(with: registry)
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    GMSServices.provideAPIKey("AIzaSyBL1yZOaZAyLe2CPCsFlYoIVNddjhKm3wM")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
