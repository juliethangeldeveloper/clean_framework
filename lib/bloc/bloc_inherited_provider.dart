import 'package:flutter/material.dart';

import 'bloc.dart';

class BlocInheritedProvider<T extends Bloc> extends StatefulWidget {
  BlocInheritedProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  final Widget child;
  final T bloc;

  @override
  _BlocInheritedProviderState<T> createState() =>
      _BlocInheritedProviderState<T>();

  static T of<T extends Bloc>(BuildContext context) {
    var provider = context
        .getElementForInheritedWidgetOfExactType<_BlocProviderInherited<T>>();
    _BlocProviderInherited<T> widget = provider?.widget;
    return widget?.bloc;
  }
}

class _BlocInheritedProviderState<T extends Bloc>
    extends State<BlocInheritedProvider<T>> {
  T _bloc;
  T get bloc {
    if (_bloc == null) {
      _bloc = widget.bloc;
    }
    return _bloc;
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _BlocProviderInherited<T>(
        child: widget.child,
        bloc: bloc,
      ),
    );
  }
}

class _BlocProviderInherited<T> extends InheritedWidget {
  _BlocProviderInherited({
    Key key,
    @required Widget child,
    @required this.bloc,
  }) : super(key: key, child: child);

  final T bloc;

  @override
  bool updateShouldNotify(_BlocProviderInherited oldWidget) => false;
}
