abstract interface class BaseModel<T> {
  T toEntity();
}

abstract interface class BaseEntity<M> {
  M toModel();
}
