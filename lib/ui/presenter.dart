import 'dart:async';

import 'package:clean_framework/bloc/bloc.dart';
import 'package:clean_framework/models.dart';
import 'package:flutter/widgets.dart';

export 'dart:async';

abstract class Presenter<B extends Bloc, V extends ViewModel>
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    B bloc = BlocInheritedProvider.of<B>(context);
    return StreamBuilder<V>(
        stream: getViewModelStream(bloc),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return buildLoadingScreen(context);
          else if (snapshot.hasError)
            return buildErrorScreen(context);
          else if (snapshot.hasData) return buildScreen(context, snapshot.data);

          // If there is no data or error, the builder is on an inconsistent
          // state, thus defaulting to error:
          return buildErrorScreen(context);
        });
  }

  Stream<V> getViewModelStream(B bloc);

  Widget buildScreen(BuildContext context, V viewModel);

  Widget buildLoadingScreen(BuildContext context) {
    return Container(key: Key('waitingFromStream'));
  }

  Widget buildErrorScreen(BuildContext context) {
    return Container(key: Key('noContentFromStream'));
  }
}
