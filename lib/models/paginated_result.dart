import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:equatable/equatable.dart';

class PaginatedResult<T> extends Equatable {
  const PaginatedResult({required this.items, required this.lastDoc});

  final List<T> items;
  final DocumentSnapshot? lastDoc;

  @override
  List<Object?> get props => [items, lastDoc];
}
