import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var replayKitChannel: FlutterMethodChannel! = nil
    var observeTimer: Timer?
    var hasEmittedFirstSample = false
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
       replayKitChannel = FlutterMethodChannel(name: "oconnect_screenshare_listener",binaryMessenger: controller.binaryMessenger)
    replayKitChannel.setMethodCallHandler({
    (call: FlutterMethodCall, result: @escaping  FlutterResult)  -> Void in
            self.handleReplayKitFromFlutter(result: result, call:call)
        })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    func handleReplayKitFromFlutter(result:FlutterResult, call: FlutterMethodCall){
        switch (call.method) {
        case "closeReplayKitFromFlutter":
            let group=UserDefaults(suiteName: "group.com.onpassive.oconnect")
            group!.set(true,forKey: "closeReplayKitFromFlutter")
            group!.set(false, forKey: "hasSampleBroadcast")
            return result(true)
        case "startReplayKit":
            self.hasEmittedFirstSample = false
            let group=UserDefaults(suiteName: "group.com.onpassive.oconnect")
            group!.set(false, forKey: "closeReplayKitFromNative")
            group!.set(false, forKey: "closeReplayKitFromFlutter")
            group!.set(false, forKey: "hasSampleBroadcast")
            self.observeReplayKitState()
        default:
            return result(FlutterMethodNotImplemented)
        }
    }
    
    func observeReplayKitState(){
        if (self.observeTimer != nil) {
            return
        }
        
        let group=UserDefaults(suiteName: "group.com.onpassive.oconnect")
        self.observeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            let closeReplayKitFromNative=group!.bool(forKey: "closeReplayKitFromNative")
            let closeReplayKitFromFlutter=group!.bool(forKey: "closeReplayKitFromFlutter")
            let hasSampleBroadcast=group!.bool(forKey: "hasSampleBroadcast")
            if (closeReplayKitFromNative) {
                self.hasEmittedFirstSample = false
                self.replayKitChannel.invokeMethod("closeReplayKitFromNative", arguments: true)
            } else if (hasSampleBroadcast) {
                if (!self.hasEmittedFirstSample) {
                    self.hasEmittedFirstSample = true
                    self.replayKitChannel.invokeMethod("hasSampleBroadcast", arguments: true)
                }
            }
        }
    }
}
