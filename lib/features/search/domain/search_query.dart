import '../../../core/models/guest_composition.dart';

class SearchQuery {
  const SearchQuery({
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    this.text,
  });

  final DateTime checkIn;
  final DateTime checkOut;
  final GuestComposition guests;
  final String? text;

  int get nights => checkOut.difference(checkIn).inDays;

  bool get hasValidDateRange => checkOut.isAfter(checkIn);

  SearchQuery copyWith({
    DateTime? checkIn,
    DateTime? checkOut,
    GuestComposition? guests,
    String? text,
  }) => SearchQuery(
        checkIn: checkIn ?? this.checkIn,
        checkOut: checkOut ?? this.checkOut,
        guests: guests ?? this.guests,
        text: text ?? this.text,
      );
}
