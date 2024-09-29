flutter clean
flutter pub get
flutter build appbundle --dart-define-from-file=config/qa.json
current_dir=$(pwd)
echo "Current directory is: $current_dir"
cd "${current_dir}/build/app/outputs/bundle/release/"
mv app-release.aab OCONNECT"($1)".aab
start .