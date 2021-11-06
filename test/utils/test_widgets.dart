import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foo/src/localization/app_localizations.dart';
import 'package:foo/src/presentation/styles/app_theme_data.dart';

import '../mocks/mocks.dart';
import '../mocks/navigation.mocks.dart';

extension WidgetTesterExtension on WidgetTester {
  Future<BuildContext> pumpPage(
    Widget page, {
    bool? asSmallDevice,
    NavigatorObserver? navigatorObserver,
    GlobalKey<NavigatorState>? navigatorKey,
    NavigatorStateMock? navigatorState,
    bool isDark = false,
  }) async {
    final completer = Completer<BuildContext>();

    if (asSmallDevice != null) {
      if (asSmallDevice) {
        binding.window.physicalSizeTestValue = const Size(620 - 50, 650);
        binding.window.devicePixelRatioTestValue = 1.0;
        addTearDown(binding.window.clearPhysicalSizeTestValue);
        addTearDown(binding.window.clearDevicePixelRatioTestValue);
      } else {
        binding.window.physicalSizeTestValue = const Size(620 + 20, 750);
        binding.window.devicePixelRatioTestValue = 1.0;
        addTearDown(binding.window.clearPhysicalSizeTestValue);
        addTearDown(binding.window.clearDevicePixelRatioTestValue);
      }
    }

    AppThemeData.setIsDark(BuildContextMock(), isDark: isDark);

    await pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt'),
        ],
        home: NavigatorMock(
          navigatorState,
          key: navigatorKey,
          observers: navigatorObserver == null
              ? <NavigatorObserver>[]
              : <NavigatorObserver>[navigatorObserver],
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) {
              if (!completer.isCompleted) completer.complete(context);
              return page;
            },
            settings: settings,
          ),
        ),
      ),
    );
    return completer.future;
  }

  T findWidget<T extends Widget>() {
    final _finder = find.byType(T);
    expect(_finder, findsOneWidget);
    return firstWidget<T>(_finder);
  }

  T findWidgetByKey<T extends Widget>(Key key) {
    final _finder = find.byKey(key);
    expect(_finder, findsOneWidget);
    return firstWidget<T>(_finder);
  }

  Future<void> tapAndPump(Type type) async {
    Finder finder;
    finder = find.byType(type);
    await tap(finder);
    await pump();
  }
}
