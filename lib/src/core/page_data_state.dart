enum PageDataState {
  loading,
  loadingFailed,
  updating,
  updatingFailed,
  populated,
  empty;

  bool get isLoading => this == PageDataState.loading || this == PageDataState.updating;
}
