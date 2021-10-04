class Weather {
  var lon;
  var lat;
  var description;
  var temp;
  var humidity;
  var country;
  var name;
  var timezone;

  Weather(
      {this.name,
      this.country,
      this.description,
      this.humidity,
      this.lat,
      this.lon,
      this.temp,
      this.timezone});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      country: json['sys']['country'] ?? "",
      description: json['weather']['description'] ?? "",
      humidity: json['main']['humidity'] ?? "",
      temp: json['main']['temp'] ?? "",
      lon: json['coord']['lon'] ?? "",
      lat: json['coord']['lat'] ?? "",
      name: json['name'] ?? "",
      timezone: json['timezone'] ?? "",
    );
  }
}
