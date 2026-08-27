class GuestComposition {
  const GuestComposition({required this.adults, this.childAges = const []});

  final int adults;
  final List<int> childAges;

  int get childrenCount => childAges.length;
  int get totalGuests => adults + childrenCount;

  Map<String, dynamic> toMap() => {
        'adults': adults,
        'children_count': childrenCount,
        'child_ages': childAges,
      };
}
