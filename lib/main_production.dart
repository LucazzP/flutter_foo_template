import 'package:foo/src/core/constants.dart';
import 'package:foo/src/core/flavor/build_config.model.dart';
import 'package:foo/src/core/run_app.dart';
import 'package:foo/src/presentation/app_widget.dart';

Future<void> main() async {
  RunApp(
    const AppWidget(),
    flavorValues: kFlavorProd,
    flavor: Flavor.production,
  );
}
