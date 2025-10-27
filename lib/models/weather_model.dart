import 'dart:convert';

class WeatherModel {
  final String cityName;
  final String description;
  final double temperature;
  final String iconCode;
  WeatherModel({
    required this.cityName,
    required this.description,
    required this.temperature,
    required this.iconCode,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final main = json['main'];

    return WeatherModel(
      cityName: json['name'] ?? 'Unknown City',
      description: weather['description'] ?? 'No description',
      temperature: (main['temp'] as num?)?.toDouble() ?? 0.0,
      iconCode: weather['icon'] ?? '01d',
    );
  }

  String getIconUrl() {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}

WeatherModel weatherModelFromJson(String str) =>
    WeatherModel.fromJson(json.decode(str));
