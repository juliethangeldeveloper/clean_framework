export 'bloc_inherited_provider.dart';
export 'bloc_provider.dart';
export 'handled_response_type.dart';
export 'pipes.dart';

/// For each storage type, we are allowed to share ONE model, and each requires
/// an entry on this enum. Please name the key with the same name of the class
/// of the model that it's shared.
enum BlocStorageKey {
  preSelectedAccount, // Included because we share a model between payments
  offersResponseHub,
  offersMessageResponseHub,
  offersResponseSpendSetter,
  offersMessageResponseSpendSetter,
  offersResponseSpendAnalysis,
  offersMessageResponseSpendAnalysis,
  customerContactsStorageModel
  // and transfers for pre-selected from and to accounts.
}

/// Any model that needs to be stored in the bloc needs to extend or implement
/// this class
abstract class BlocStorageModel {}

/// Base class for all BLoCs, handles the logic for the bloc storage
class Bloc {
  static Map<BlocStorageKey, BlocStorageModel> _storage = {};

  void storeModel(BlocStorageKey key, BlocStorageModel model) {
    _storage[key] = model;
  }

  BlocStorageModel getStoredModel(BlocStorageKey key) => _storage[key];

  void clearStoredModel(BlocStorageKey key) => _storage.remove(key);
//be sure to clearStorage after the data is not needed, very important for tests
  void clearStorage() => _storage = {};

  void dispose() {}
}
