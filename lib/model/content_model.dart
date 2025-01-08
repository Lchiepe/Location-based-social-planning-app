import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Content {
  final String name;
  final String image;
  final String coordinates;

  const Content({
    required this.name,
    required this.image,
    required this.coordinates,
  });
}