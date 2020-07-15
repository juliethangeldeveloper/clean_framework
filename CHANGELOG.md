## [0.1.3] Bloc Provider Bug Fix (2020-07-15)

## [0.1.2] Use Case and Entity (2020-07-03)

* Adding two new components to simplify the bloc code. A bloc is going to be used just as the bridge between UI components and use cases. A bloc will have multiple use cases that interact with one or more entities, each use case reflects one scenario and will be holding all the business logic. Entities will preserve the state of the business data (it is a direct replacement for the BusinessModel, which will be Deprecated on the next version)

## [0.1.1] Json Service POST fix (2020-07-03)

* A JsonService was not sending correctly the JSON body as a request parameter to RestAPI, so it was fixed.

## [0.1.0] First Minor Release (2020-05-17)

* Added the rest of the code to the example project, with tests.
* Fixed json encoding in JsonService. It is now assumed the RestApi implementation will return string responses (under evaluation, since it could be better to assume RestApi does the conversion).
* Fixed JsonService handler callbacks.
* Added tests for Presenter and Screen to showcase different ways to tests the components on flutter widget tests (driver tests are pending).

## [0.0.2] Example Fixes (2020-05-16)

* Fixed example folder, with some classes to showcause the usage of the main components. The UI is not finished.

## [0.0.1] Initial Release (2020-05-16)

* First batch of clean framework components, with tests.
