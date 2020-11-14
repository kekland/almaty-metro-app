import 'dart:convert';

import 'package:almaty_metro/api/model/line.dart';
import 'package:almaty_metro/api/model/schedule_type.dart';
import 'package:almaty_metro/api/model/station.dart';
import 'package:almaty_metro/api/model/subway.dart';
import 'package:almaty_metro/api/time.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

export 'model/line.dart';
export 'model/schedule_type.dart';
export 'model/segment.dart';
export 'model/station.dart';
export 'model/subway.dart';

export 'db.dart';
export 'extensions.dart';
export 'time.dart';

abstract class Api {
  Future<Map<String, dynamic>> downloadSubwayData();
  Subway getSubwayFromResponse(Map<String, dynamic> response);
}

class AlmetroApi implements Api {
  Future<Map<String, dynamic>> downloadSubwayData() async {
    final response = await http.get(
      'http://metro.witharts.kz/metro/api/0/all',
      headers: {
        'X-Requested-With': 'com.witharts.metro',
      },
    );

    return jsonDecode(response.body);
  }

  Tuple2<int, List<Time>> _parseScheduleInfo(String data) {
    final _data = data.split(',');
    final _station = int.parse(_data[0]);
    final _schedule = _data
        .skip(1)
        .map(
          (v) => Time.parse(v),
        )
        .toList();

    return Tuple2(_station, _schedule);
  }

  SubwayData _getSubwayWithScheduleTypeFromResponse(
    Map<String, dynamic> response,
    ScheduleType type,
  ) {
    final suffix = type == ScheduleType.normal ? 'workday' : 'holiday';

    final _stations = response['stations'];

    final line = SubwayLine(id: 0, stations: [], segments: []);
    final _forwardSchedule = <int, Tuple2<int, List<Time>>>{};
    final _reverseSchedule = <int, Tuple2<int, List<Time>>>{};

    for (final _station in _stations) {
      final station = SubwayStation(
        id: int.parse(_station['id']),
        name: _station['name'],
        order: int.parse(_station['station_order']),
        latitude: double.parse(_station['latitude']),
        longitude: double.parse(_station['longitude']),
        connections: {},
        schedule: {},
      );

      final _forwardScheduleInfo = _station['next_station_schedule_$suffix'];
      if (_forwardScheduleInfo.isNotEmpty) {
        final _schedule = _parseScheduleInfo(_forwardScheduleInfo);
        _forwardSchedule[station.id] = _schedule;

        station.populateSchedule(
          stationId: _schedule.item1,
          schedule: _schedule.item2,
        );
      }

      final _reverseScheduleInfo = _station['prev_station_schedule_$suffix'];
      if (_reverseScheduleInfo.isNotEmpty) {
        final _schedule = _parseScheduleInfo(_reverseScheduleInfo);
        _reverseSchedule[station.id] = _schedule;

        station.populateSchedule(
          stationId: _schedule.item1,
          schedule: _schedule.item2,
        );
      }

      line.stations.add(station);
    }

    line.stations.sort((a, b) => b.order - a.order);

    return SubwayData(
      lines: [line],
      lineConnections: {},
    );
  }

  Subway getSubwayFromResponse(Map<String, dynamic> response) {
    return Subway(
      holidays: response['holidays']
          .map(
            (v) => DateTime.parse(v['date']),
          )
          .cast<DateTime>()
          .toList(),
      schedules: Map.fromEntries(
        ScheduleType.values.map(
          (v) => MapEntry(
            v,
            _getSubwayWithScheduleTypeFromResponse(response, v),
          ),
        ),
      ),
    );
  }
}