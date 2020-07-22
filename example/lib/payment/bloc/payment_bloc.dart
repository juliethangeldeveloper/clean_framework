import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/example_feature/api/example_service.dart';
import 'package:clean_framework_example/payment/bloc/payment_usecase.dart';
import 'package:clean_framework_example/payment/model/payment_view_model.dart';

class PaymentBloc extends Bloc {
  PaymentUseCase _paymentUseCase;

  final paymentViewModelPipe = Pipe<PaymentViewModel>();
  final amountPipe = Pipe<double>();
  final fromAccountPipe = Pipe<String>();
  final toAccountPipe = Pipe<String>();
  final submitPipe = EventPipe();

  @override
  void dispose() {
    paymentViewModelPipe.dispose();
    amountPipe.dispose();
    fromAccountPipe.dispose();
    toAccountPipe.dispose();
    submitPipe.dispose();
  }

  PaymentBloc({ExampleService exampleService}) {
    _paymentUseCase =
        PaymentUseCase((viewModel) => paymentViewModelPipe.send(viewModel));
    paymentViewModelPipe.onListen(() => _paymentUseCase.create());

    amountPipe.receive.listen(amountInputHandler);
    fromAccountPipe.receive.listen(fromAccountInputHandler);
    toAccountPipe.receive.listen(toAccountInputHandler);
    submitPipe.listen(submitHandler);
  }

  void amountInputHandler(double amount) {
    _paymentUseCase.updateAmount(amount);
  }

  void fromAccountInputHandler(String accountId) {
    _paymentUseCase.updateFromAccount(accountId);
  }

  void toAccountInputHandler(String accountId) {
    _paymentUseCase.updateToAccount(accountId);
  }

  void submitHandler() {
    _paymentUseCase.submit();
  }
}
