import 'package:flutter/material.dart';

enum MazeTile
{
  path(Colors.white),
  wall(Colors.black),
  undecided(null);

  const MazeTile(this.color);

  final Color? color;
}