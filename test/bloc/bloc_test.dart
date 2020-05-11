import 'package:clean_framework/bloc/bloc.dart';
import 'package:test/test.dart';

class TestModel extends BlocStorageModel {
  String test = 'foo';
}

main() {
  test('BlocBase storage actions', () async {
    var bloc = Bloc();

    expect(bloc.getStoredModel(BlocStorageKey.preSelectedAccount), isNull);

    bloc.storeModel(BlocStorageKey.preSelectedAccount, TestModel());

    TestModel model = bloc.getStoredModel(BlocStorageKey.preSelectedAccount);
    expect(model, isNotNull);
    expect(model.test, 'foo');

    bloc.clearStoredModel(BlocStorageKey.preSelectedAccount);
    model = bloc.getStoredModel(BlocStorageKey.preSelectedAccount);
    expect(model, isNull);

    bloc.storeModel(BlocStorageKey.preSelectedAccount, TestModel());
    bloc.clearStorage();
    model = bloc.getStoredModel(BlocStorageKey.preSelectedAccount);
    expect(model, isNull);
    bloc.dispose();
  });
}
