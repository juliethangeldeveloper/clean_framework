import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bloc.dart';

// TODO See if this works later
// extension BlocProviderExtension on BuildContext {
//   B bloc<B extends Bloc>() => Provider.of<B>(this, listen: false);
// }

/// If provider of same type is found above [BlocProvider],
/// new instance won't be create. i.e. [create] will be ignored.
class BlocProvider<B extends Bloc> extends StatefulWidget {
  final B Function(BuildContext) create;
  final Widget child;

  const BlocProvider({
    Key key,
    this.create,
    @required this.child,
  }) : super(key: key);

  static of<B extends Bloc>(BuildContext context) {
    return Provider.of<B>(context, listen: false);
  }

  @override
  _BlocProviderState createState() => _BlocProviderState<B>();
}

class _BlocProviderState<B extends Bloc> extends State<BlocProvider<B>> {
  B _bloc;

  @override
  void initState() {
    super.initState();

    if (_bloc == null) {
      try {
        setState(() {
          _bloc = Provider.of<B>(context, listen: false);
        });
      } on ProviderNotFoundException catch (e) {
        if (widget.create != null)
          setState(() {
            _bloc = widget.create(context);
          });
        else
          throw e;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider<B>(
      create: (_) => _bloc,
      child: widget.child,
      dispose: (_, __) => _bloc.dispose(),
    );
  }
}
