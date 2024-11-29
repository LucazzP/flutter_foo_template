import 'package:flutter/foundation.dart';
import 'package:foo/src/core/failures.dart';
import 'package:foo/src/core/page_data_state.dart';
import 'package:foo/src/presentation/base/controller/form_store.dart';
import 'package:foo/src/presentation/base/controller/value_state.store.dart';
import 'package:foo/src/presentation/base/disposable.dart';
import 'package:mobx/mobx.dart';

part 'base.store.g.dart';

abstract class BaseStore = _BaseStoreBase with _$BaseStore;

abstract class _BaseStoreBase with Store, Disposable {
  ReactionDisposer? _loadingDisposer;

  @mustCallSuper
  void init() {
    _loadingDisposer = reaction((_) {
      for (final state in states) {
        if (state.isLoading) {
          return true;
        }
      }
      return false;
    }, (isLoading) {
      _setIsLoading(isLoading);
    }, delay: 100);

    for (final store in childStores) {
      store.init();
    }
  }

  /// Used internally within the [BaseStore] to access all available states
  /// in the implementing class.
  ///
  /// IMPORTANT: Whenever adding a state within a controller,
  /// it must also be added to the [getStates] list using @override.
  @protected
  Iterable<ValueState> get getStates;

  @protected
  Iterable<BaseStore> get childStores => [];

  @protected
  List<FormStore> get getForms => [];

  Future<bool> validateForms() async {
    final forms = getForms;

    var hasError = false;
    for (var i = 0; i < forms.length; i++) {
      final item = forms.elementAt(i);
      final validated = await item.validate();
      if (!validated) {
        hasError = true;
      }
    }
    return !hasError;
  }

  Computed<PageDataState>? _getPageDataStateComputed;

  @protected
  PageDataState getPageDataState(bool Function() hasData) {
    _getPageDataStateComputed ??= Computed<PageDataState>(
      () {
        if (hasData()) {
          if (isLoading) {
            return PageDataState.updating;
          } else if (hasFailure) {
            return PageDataState.updatingFailed;
          }
          return PageDataState.populated;
        }
        if (isLoading) {
          return PageDataState.loading;
        }
        if (hasFailure) {
          return PageDataState.loadingFailed;
        }
        return PageDataState.empty;
      },
      name: '_BaseStoreBase.getPageDataState',
    );
    return _getPageDataStateComputed!.value;
  }

  /// Same purpose as [getStates], the difference is that this is a `computed` property
  /// that will notify other `computed` properties that are listening to it.
  ///
  /// It is necessary to have these two attributes and not just one because MobX
  /// requires me to implement all `computed` properties. Therefore, I cannot make
  /// [getStates] a `computed` property because it must be implemented by the
  /// implementing class, not by the [BaseStore].
  @computed
  @visibleForTesting
  Iterable<ValueState> get states => [...getStates];

  /// Retrieves the first [Failure] found within all states.
  @computed
  Failure? get failure {
    try {
      return states.firstWhere((element) => element.hasFailure).failure;
    } on StateError catch (e) {
      if (e.toString() == 'Bad state: No element') {
        return null;
      } else {
        rethrow;
      }
    }
  }

  /// Returns `true` if at least one of the states is loading.
  @observable
  bool _isLoading = false;

  @action
  void _setIsLoading(bool value) => _isLoading = value;

  @computed
  bool get isLoading => _isLoading;

  /// Returns `true` if at least one of the states has any [Failure].
  @computed
  bool get hasFailure => states.any((element) => element.hasFailure);

  /// Retrieves all states that have any [Failure] and sets it to none().
  @nonVirtual
  void clearErrors() {
    states.where((state) => state.hasFailure).forEach((state) => state.setFailure(null));
  }

  @override
  @mustCallSuper
  void dispose() {
    _loadingDisposer?.call();

    // Future necessary to finish the animation transition
    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      for (var form in getForms) {
        form.dispose();
      }
    });

    for (var store in childStores) {
      store.dispose();
    }

    for (var state in states) {
      state.dispose();
    }
  }
}
