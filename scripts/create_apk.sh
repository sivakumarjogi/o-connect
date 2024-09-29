flutter clean
flutter pub get
flutter build apk --release --split-per-abi -t lib/main.dart --dart-define-from-file=config/qa.json
current_dir=$(pwd)
echo "Current directory is: $current_dir"
cd "${current_dir}/build/app/outputs/flutter-apk/"
mv app-arm64-v8a-release.apk OCONNECT"($1)".apk
start .