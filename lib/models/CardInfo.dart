import 'package:yupcity_admin/constants.dart';
import 'package:flutter/material.dart';

class CardInfo {
  final String? svgSrc, title, route;
  final int? total, percentage;
  final Color? color;

  CardInfo({
    this.svgSrc,
    this.title,
    this.route,
    this.total,
    this.percentage,
    this.color,
  });
}

List demoCardInfo = [
  CardInfo(
    title: "Usuarios",
    total: 1328,
    svgSrc: "assets/icons/menu_profile.svg",
    route: "users",
    color: primaryColor,
    percentage: 35,
  ),
  CardInfo(
    title: "Usos",
    total: 1328,
    svgSrc: "assets/icons/key.svg",
    route: "users",
    color: Color(0xFFFFA113),
    percentage: 35,
  ),
  CardInfo(
    title: "Traps",
    total: 5328,
    svgSrc: "assets/icons/scooter.svg",
    route: "devices",
    color: Colors.blue,
    percentage: 10,
  ),
  CardInfo(
    title: "Traps ocupados",
    total: 328,
    svgSrc: "assets/icons/lock.svg",
    route: "devices",
    color: Color(0xFF007EE5),
    percentage: 78,
  ),
];
