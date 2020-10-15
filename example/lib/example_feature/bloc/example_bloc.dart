import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/example_feature/api/example_service.dart';
import 'package:clean_framework_example/example_feature/bloc/example_usecase.dart';
import 'package:clean_framework_example/example_feature/model/example_view_model.dart';

export 'package:clean_framework_example/example_feature/model/example_view_model.dart';

class ExampleBloc extends Bloc {
  ExampleUseCase _useCase;

  final exampleViewModelPipe = Pipe<ExampleViewModel>();

  @override
  void dispose() {
    exampleViewModelPipe.dispose();
  }

  ExampleBloc({ExampleService exampleService}) {
    _useCase =
        ExampleUseCase((viewModel) => exampleViewModelPipe.send(viewModel));
    exampleViewModelPipe.whenListenedDo(() => _useCase.execute());
  }
}
