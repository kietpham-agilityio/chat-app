import 'package:chat_app/core/app/my_app.dart';
import 'package:chat_app/core/flavors/flavor_config.dart';
import 'package:flutter/material.dart';

void mainCommon({
  required Flavor flavor,
  required String baseUrl,
  required String name,
}) {
  FlavorConfig(flavor: flavor, baseUrl: baseUrl, name: name);
  runApp(MyApp());
}
