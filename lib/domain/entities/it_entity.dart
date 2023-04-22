class ItEntity {
  final int id;
  final String name;
  final ItType type;
  final String asset;
  const ItEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.asset,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItEntity &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.asset == asset;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ type.hashCode ^ asset.hashCode;
  }

  @override
  String toString() {
    return 'ItEntity(id: $id, name: $name, type: $type, asset: $asset)';
  }
}

enum ItType {
  human,
}
