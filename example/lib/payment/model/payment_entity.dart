import 'package:clean_framework/clean_framework.dart';

class PaymentEntity extends Entity {
  final String fromAccount;
  final String toAccount;
  final double amount;

  PaymentEntity(
      {List<EntityError> errors = const [],
      String fromAccount,
      String toAccount,
      this.amount = 0.0})
      : fromAccount = fromAccount ?? '',
        toAccount = toAccount ?? '',
        super(errors: errors);

  @override
  List<Object> get props => [errors, fromAccount, toAccount, amount];

  @override
  merge({errors, String fromAccount, String toAccount, double amount}) {
    return PaymentEntity(
        errors: errors ?? this.errors,
        fromAccount: fromAccount ?? this.fromAccount,
        toAccount: toAccount ?? this.toAccount,
        amount: amount ?? this.amount);
  }
}
