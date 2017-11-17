func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("DeviceToken1: \(deviceToken)")
    let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    print("DeviceToken: \(token)")
}
