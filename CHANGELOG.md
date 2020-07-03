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
