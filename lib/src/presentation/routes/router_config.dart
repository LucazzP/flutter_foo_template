import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:foo/src/modules/home/presentation/pages/home/home_page.dart';
import 'package:foo/src/presentation/app_widget.dart';
import 'package:foo/src/presentation/routes/routes.dart';
import 'package:go_router/go_router.dart';

final routerConfig = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: Routes.initialRoute.route(),
  observers: [
    FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
  ],
  routes: [
    GoRoute(
      path: Routes.initialRoute.route(),
      builder: (context, state) => const HomePage(),
    ),
  ],
);
