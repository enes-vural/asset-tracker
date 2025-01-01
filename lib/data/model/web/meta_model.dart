// ignore_for_file: unnecessary_getters_setters

class Meta {
  int _time; // private field

  Meta({required int time}) : _time = time;

  // Getter
  int get time => _time;

  // Setter
  set time(int value) {
    _time = value;
  }

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': _time,
    };
  }
}
