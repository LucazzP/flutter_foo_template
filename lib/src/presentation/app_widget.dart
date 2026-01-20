import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:foo/src/presentation/localization/app_localizations.dart';
import 'package:foo/src/presentation/routes/router_config.dart';
import 'package:foo/src/presentation/styles/app_theme_data.dart';

import 'widgets/flavor_banner/flavor_banner.widget.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter app',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      routerConfig: routerConfig,
      // Providing a restorationScopeId allows the Navigator built by the
      // MaterialApp to restore the navigation stack when a user leaves and
      // returns to the app after it has been killed while running in the
      // background.
      restorationScopeId: 'app',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      localeResolutionCallback: (locale, supportedLocales) {
        for (final supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode) {
            return supportedLocale;
          }
        }

        return supportedLocales.first;
      },
      onGenerateTitle: (BuildContext context) => AppLocalizations.of(context).appTitle,
      builder: (context, child) {
        AppThemeData.setIsDark(context);
        return FlavorBannerWidget(
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}

final navigatorKey = GlobalKey<NavigatorState>();
