import 'package:fasting_api/fasting_api.dart';
import 'package:fasting_entities/fasting_entities.dart';

class FastingRepository {
  final FastingApi _fastingApi;

  const FastingRepository({
    required FastingApi fastingApi,
  }) : _fastingApi = fastingApi;

  Future<void> createFast(Fast fast) => throw UnimplementedError();
}
