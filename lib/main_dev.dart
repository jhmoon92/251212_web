import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bootstrap.dart';
import 'flavors.dart';
import 'main.dart';

Future<void> main() async {
  F.appFlavor = Flavor.development;

  runApp(UncontrolledProviderScope(container: await bootstrap(), child: MyApp()));
}
