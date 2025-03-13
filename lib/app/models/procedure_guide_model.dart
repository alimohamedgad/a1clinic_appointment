

import 'package:flutter/material.dart';

import 'doctor_model.dart';
import 'media_model.dart';
import 'parents/model.dart';

class ProcedureGuide extends Model {
  String? _name;
  String? _description;
  Media? _image;



  ProcedureGuide(
      {String? id,
      String? name,
      String? description,
      Media? image,
      }) {
    _name = name;
    _description = description;
    _image = image;
  }

  ProcedureGuide.fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    _name = transStringFromJson(json, 'name');
    _description = transStringFromJson(json, 'description');
    _image = mediaFromJson(json, 'image');

  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      super == other &&
          other is ProcedureGuide &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          image == other.image;

  @override
  int get hashCode =>
      super.hashCode ^ id.hashCode ^ name.hashCode ^ description.hashCode ^ image.hashCode;

  String get name => _name ?? '';

  set name(String value) {
    _name = value;
  }

  String get description => _description ?? '';

  set description(String value) {
    _description = value;
  }



  Media get image => _image ?? Media();

  set image(Media value) {
    _image = value;
  }





}
