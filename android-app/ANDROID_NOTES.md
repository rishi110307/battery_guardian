# Android notes

This is a starter Android Studio project. It uses AndroidX NotificationCompat, so add the AndroidX Core dependency if your Gradle setup does not already provide it:

```gradle
dependencies {
    implementation 'androidx.core:core-ktx:1.13.1'
}
```

For a production release, move battery monitoring into a lifecycle-appropriate design and test on physical devices. Android 13+ requires notification permission. Android may restrict background behavior; this sample is intended to demonstrate notifications and does not promise continuous monitoring after the app is closed or force-stopped.
