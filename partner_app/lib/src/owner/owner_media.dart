enum OwnerMediaType { image, video, unknown }

OwnerMediaType ownerMediaTypeFromString(String? value) {
  switch (value?.toLowerCase()) {
    case 'image': return OwnerMediaType.image;
    case 'video': return OwnerMediaType.video;
    default: return OwnerMediaType.unknown;
  }
}

class OwnerMediaAsset {
  const OwnerMediaAsset({
    required this.assetId,
    required this.propertyId,
    this.unitId,
    required this.url,
    required this.type,
    required this.sortOrder,
  });

  final String assetId;
  final String propertyId;
  final String? unitId;
  final String url;
  final OwnerMediaType type;
  final int sortOrder;
}
