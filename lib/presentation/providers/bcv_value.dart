import 'package:bombonas_app/data/models/bcv_response.dart';
import 'package:bombonas_app/data/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bcv_value.g.dart';

@riverpod
Future<double> bcv(Ref ref) async {
  BcvResponse bcv = await Repository().fetchBcv();
  return bcv.price;
}
