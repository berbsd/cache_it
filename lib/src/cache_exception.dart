///
abstract class CacheException implements Exception {
  ///
  const CacheException([this._message]);

  final String _message;

  @override
  String toString() => _message;
}

///
class TypeException extends CacheException {
  ///
  const TypeException() : super('object is not of type Cache');
}

///
class DuplicateEntryException extends CacheException {
  ///
  const DuplicateEntryException() : super('object is alredy present');
}
