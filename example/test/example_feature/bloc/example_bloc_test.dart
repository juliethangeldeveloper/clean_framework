import 'package:clean_framework_example/example_feature/bloc/example_bloc.dart';
import 'package:clean_framework_example/example_feature/model/example_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ExampleBloc gets model from service', () {
    final bloc = ExampleBloc();

    bloc.exampleViewModelPipe.receive.listen(expectAsync1((model) {
      expect(model, isA<ExampleViewModel>());
      expect(model.loginCount, 3);
      expect(model.lastLogin.toString(), '2020-05-01 00:00:00.000');
    }));

    // The pipe uses the onListen callback to trigger the creation of the
    // view model, so there is no need to do anything else
  });
}
