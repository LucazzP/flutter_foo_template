BUNDLE=rbenv exec bundle
LANG_VAR=LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
FASTLANE=$(LANG_VAR) $(BUNDLE) exec fastlane

.PHONY: build

build:
	flutter gen-l10n
	flutter pub run build_runner build

build_clean:
	flutter gen-l10n
	flutter pub run build_runner build --delete-conflicting-outputs

watch:
	flutter gen-l10n
	flutter pub run build_runner watch

cleanup:
	rm -rf pubspec.lock .packages .flutter-plugins .flutter-plugins-dependencies ios/Podfile.lock ios/Pods && flutter clean && flutter pub get --verbose && cd ios && pod install --verbose && cd ..

cache_repair:
	flutter pub cache repair --verbose

clean_cache:
	rm -rf pubspec.lock .packages .flutter-plugins .flutter-plugins-dependencies

lint:
	flutter analyze

update_app_icon:
	flutter pub get
	flutter pub run flutter_launcher_icons:main

# Simulators
wipe:
	rm -rf ~/Library/Developer/Xcode/{DerivedData,Archives,Products}
	osascript -e 'tell application "iOS Simulator" to quit'
	osascript -e 'tell application "Simulator" to quit'
	xcrun simctl erase all

gen_cov:
	flutter test --coverage

	mkdir -p coverage/widgets
	mkdir -p coverage/logic
	mkdir -p coverage/models
	mkdir -p coverage/all
	cp coverage/lcov.info coverage/all/lcov.info

	lcov -e coverage/lcov.info '**/*.model.dart' '**/model/*.dart' -o coverage/models/lcov.info
	lcov -e coverage/lcov.info '**/*.page.dart' '**/*.ui.dart' -o coverage/widgets/lcov.info
	lcov -r coverage/lcov.info '**/*.page.dart' '**/*.ui.dart' '**/*.model.dart' '**/model/*.dart' -o coverage/logic/lcov.info

	genhtml coverage/logic/lcov.info  -o coverage/logic 
	genhtml coverage/widgets/lcov.info -o coverage/widgets
	genhtml coverage/models/lcov.info -o coverage/models
	genhtml coverage/all/lcov.info -o coverage/all
	open coverage/logic/index.html
	open coverage/widgets/index.html
	open coverage/models/index.html
	open coverage/all/index.html
