import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'weather_model.g.dart';

@HiveType(typeId: 0)
class WeatherModel extends HiveObject {
  @HiveField(0)
  final String? name;

  @HiveField(1)
  final MainData? main;

  @HiveField(2)
  final List<WeatherData>? weather;

  @HiveField(3)
  final WindData? wind;

  WeatherModel({
    this.name,
    this.main,
    this.weather,
    this.wind,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      name: json['name'] as String?,
      main: json['main'] != null ? MainData.fromJson(json['main']) : null,
      weather: json['weather'] != null
          ? List<WeatherData>.from(
              (json['weather'] as List).map((x) => WeatherData.fromJson(x)))
          : null,
      wind: json['wind'] != null ? WindData.fromJson(json['wind']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'main': main?.toJson(),
      'weather': weather?.map((x) => x.toJson()).toList(),
      'wind': wind?.toJson(),
    };
  }
}

@HiveType(typeId: 3)
class MainData extends HiveObject {
  @HiveField(0)
  final double? temp;

  @HiveField(1)
  final int? humidity;

  @HiveField(2)
  final double? pressure;

  MainData({
    this.temp,
    this.humidity,
    this.pressure,
  });

  factory MainData.fromJson(Map<String, dynamic> json) {
    return MainData(
      temp: (json['temp'] as num?)?.toDouble(),
      humidity: json['humidity'] as int?,
      pressure: (json['pressure'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temp': temp,
      'humidity': humidity,
      'pressure': pressure,
    };
  }
}

@HiveType(typeId: 4)
class WeatherData extends HiveObject {
  @HiveField(0)
  final String? main;

  @HiveField(1)
  final String? description;

  WeatherData({
    this.main,
    this.description,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      main: json['main'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'main': main,
      'description': description,
    };
  }
}

@HiveType(typeId: 5)
class WindData extends HiveObject {
  @HiveField(0)
  final double? speed;

  @HiveField(1)
  final int? deg;

  WindData({
    this.speed,
    this.deg,
  });

  factory WindData.fromJson(Map<String, dynamic> json) {
    return WindData(
      speed: (json['speed'] as num?)?.toDouble(),
      deg: json['deg'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'speed': speed,
      'deg': deg,
    };
  }
}

WeatherModel weatherModelFromJson(String str) =>
    WeatherModel.fromJson(json.decode(str));
