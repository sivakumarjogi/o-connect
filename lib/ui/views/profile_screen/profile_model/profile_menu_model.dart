import 'package:flutter/material.dart';

class ProfileMenuModel {
  final String title;
  final String? icon;
  final VoidCallback onTap;
  final IconData? iconData;

  ProfileMenuModel({required this.title, this.icon, required this.onTap, this.iconData});
}
