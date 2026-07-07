import 'dart:async';
import 'dart:typed_data';

import 'package:arari_next/data/services/datasource/data_source_interface.dart';
import 'package:arari_next/data/services/pipeline/mavlink_mapper.dart';
import 'package:arari_next/data/services/pipeline/telemetry_source_interface.dart';
import 'package:arari_next/domain/telemetry/iboat_data.dart';
import 'package:arari_next/utils/mavlink/mavlink_dialect/arariboat.dart';
import 'package:dart_mavlink/mavlink_frame.dart';
import 'package:dart_mavlink/mavlink_parser.dart';

class MavlinkTelemetrySource implements ITelemetrySource {
  final IDataSource _source;
  final MavlinkMapper _mapper;
  late StreamSubscription _sourceSubscription;
  late StreamSubscription _mapperSubscription;

  final MavlinkParser _parser = MavlinkParser(MavlinkDialectArariboat());

  final StreamController<IBoatData> _streamController =
      StreamController.broadcast();

  @override
  Stream<IBoatData> get stream => _streamController.stream;

  MavlinkTelemetrySource({
    required IDataSource source,
    required MavlinkMapper mapper,
  }) : _source = source,
       _mapper = mapper {
    _sourceSubscription = _source.stream.listen(
      (data) => _handleRawBytes(data),
    );
    _mapperSubscription = _parser.stream.listen(_handleMavlinkFrame);
  }

  void _handleRawBytes(Uint8List bytes) {
    _parser.parse(bytes);
  }

  void _handleMavlinkFrame(MavlinkFrame frame) {
    IBoatData? data = _mapper.map(frame);
    if (data == null) return;

    _streamController.add(data);
  }

  @override
  Future<void> dispose() async {
    await _sourceSubscription.cancel();
    await _mapperSubscription.cancel();
    await _streamController.close();
  }
}
