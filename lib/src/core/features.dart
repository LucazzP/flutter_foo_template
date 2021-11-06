
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class Features {
  static ValueNotifier<Map<String, dynamic>>? _features;

  static Map<String, dynamic> get _baseFeatures {
    final features = <String, dynamic>{
      'feature1': true,
      'feature2': true,
    };
    return features;
  }

  static Map<String, dynamic> get dev {
    final features = Map<String, dynamic>.from(_baseFeatures);
    remoteConfig(features);
    return _features!.value;
  }

  static Map<String, dynamic> get qa {
    final features = Map<String, dynamic>.from(_baseFeatures);
    remoteConfig(features);
    return _features!.value;
  }

  static Map<String, dynamic> get prod {
    final features = Map<String, dynamic>.from(_baseFeatures);
    remoteConfig(features);
    return _features!.value;
  }

  static Future<void> remoteConfig(Map<String, dynamic> env) async {
    if (_features != null) return;

    WidgetsFlutterBinding.ensureInitialized();
    _features = ValueNotifier(env);
    // final remoteConfig = RemoteConfig.instance;
    // remoteConfig.addListener(() {
    //   _features.value = remoteConfig.getAll().map(
    //     (key, value) {
    //       switch (key) {
    //         case Feature.tutorialListsIds:
    //           return MapEntry(key, jsonDecode(value.asString()));
    //       }

    //       return MapEntry(key, value.asBool());
    //     },
    //   );
    //   print(_features.value);
    // });
    // await remoteConfig.setDefaults(env);
    // await remoteConfig.setConfigSettings(
    //   RemoteConfigSettings(
    //     fetchTimeout: Duration(minutes: 2),
    //     minimumFetchInterval: Duration(minutes: 30),
    //   ),
    // );
    // try {
    //   await remoteConfig.fetchAndActivate();
    // } catch (e) {}
  }
}
