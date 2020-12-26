/// Abstract exception class for [CacheIt]
abstract class CacheException implements Exception {
  /// Default constructor. Takes an optional message string.
  const CacheException([this._message]);

  final String? _message;

  @override
  String toString() => _message ?? '';
}

///An generic exception raised when a cache operation fails.
class TypeException extends CacheException {
  /// Default constructor
  const TypeException() : super('object is not of type Cache');
}

/// An exception raised when attemting to create a duplicate.
class DuplicateEntryException extends CacheException {
  /// Default constructor
  const DuplicateEntryException() : super('object is alredy present');
}
