import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:foo/src/presentation/base/pages/base.page.dart';

import 'home_controller.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage, HomeController> {
  @override
  PreferredSizeWidget appBar(BuildContext ctx) => AppBar();

  @override
  Widget child(context, constrains) {
    return Column(
      children: [
        Observer(builder: (_) {
          return Text(controller.counter.value.toString());
        }),
        TextButton(
          onPressed: () {
            controller.counter.setValue(controller.counter.value + 1);
          },
          child: const Text('aumentar'),
        )
      ],
    );
  }
}
