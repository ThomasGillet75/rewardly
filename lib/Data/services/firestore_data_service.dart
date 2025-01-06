abstract class IDataService<T> {
  Future<void> add(T item);

  Future<void> delete(String id);

  Future<void> update(T item);

  Future<T> get(String id);

  Stream<List<T>> getAll();
}
