import 'package:yupcity_admin/constants.dart';
import 'package:flutter/material.dart';

class CloudStorageInfo {
  final String? svgSrc, title, route;
  final int? total, percentage;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.route,
    this.total,
    this.percentage,
    this.color,
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "Usuarios",
    total: 1328,
    svgSrc: "assets/icons/menu_profile.svg",
    route: "users",
    color: primaryColor,
    percentage: 100,
  ),
  CloudStorageInfo(
    title: "Usos",
    total: 1328,
    svgSrc: "assets/icons/key.svg",
    route: "users",
    color: Color(0xFFFFA113),
    percentage: 100,
  ),
  CloudStorageInfo(
    title: "Traps",
    total: 5328,
    svgSrc: "assets/icons/scooter.svg",
    route: "devices",
    color: Colors.blue,
    percentage: 100,
  ),
  CloudStorageInfo(
    title: "Traps ocupados",
    total: 328,
    svgSrc: "assets/icons/lock.svg",
    route: "devices",
    color: Color(0xFF007EE5),
    percentage: 100,
  ),
];
