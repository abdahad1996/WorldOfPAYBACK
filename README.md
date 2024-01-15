
## "WorldOfPAYBACK" App - Requirements

Please create a SwiftUI App based on the following User-Stories:

✅* As a user of the App, I want to see a list of (mocked) transactions. Each item in the list displays `bookingDate`, `partnerDisplayName`, `transactionDetail.description`, `value.amount` and `value.currency`. *(see attached JSON File)*
✅* As a user of the App, I want to have the list of transactions sorted by `bookingDate` from newest (top) to oldest (bottom).
✅* As a user of the App, I want to get feedback when loading of the transactions is ongoing or an Error occurs. *(Just delay the mocked server response for 1-2 seconds and randomly fail it)*
✅* As a user of the App, I want to see an error if the device is offline.
✅* As a user of the App, I want to filter the list of transactions by `category`.
✅* As a user of the App, I want to see the sum of filtered transactions somewhere on the Transaction-list view. *(Sum of `value.amount`)*
✅* As a user of the App, I want to select a transaction and navigate to its details. The details-view should just display `partnerDisplayName` and `transactionDetail.description`.
✅* As a user of the App, I like to see nice UI in general. However, for this coding challenge fancy UI is not required.

## "WorldOfPAYBACK" App - General Information

* Attached you will find a JSON File (`PBTransactions.json`) which contains a list of transactions. Just assume that the Backend is not ready yet and the App needs to work with mocked data meanwhile. For now, the Backend-Team has just provided the name of the endpoints for the new Service: 
	* Production Environment: "GET https://api.payback.com/transactions"
	* Test Environment: "GET https://api-test.payback.com/transactions"
* The App is planned to be maintained over a long period of time. New Features will be added by a growing Team in the near future.
* The App is planned to be available worldwide supporting many different languages and region related formatting (e.g. Date and Number formatting).
* The Feature you are currently working on is the first out of many. Multiple Teams will add more features in the near future (overall Team size is about 8 Developers and growing). The following list of Features (which are not part of this coding challenge) will give you an idea of what's planned for the upcoming releases.
 
	1. 	"Feed"-Feature: Displays different, user-targeted content (displayed via webviews, images, ads etc.). **Note:** It is also planned to display the sum of all Transactions from the "Transaction"-Feature.
	2. "Online Shopping"-Feature: Lists PAYBACK Partners and gives the possibility to jump to their App/Website.
	3. "Settings"-Feature: Gives the possibility to adjust general Settings.


## PAYBACK Environment

* We are currently in a transition phase of moving from UIKit to SwiftUI.
* We use Reactive programming and are currently moving from a self built Reactive-Library to Combine. For asynchronous code we are moving to Swift Concurrency.
* We try to keep to as few external dependencies as possible. However, we use Swift Package Manager when we need to add a dependency.
* We are using Jenkins to build, test and deploy our Apps.


# this code was build thinking in terms of the PAYBACK environment:
 # transition phase of moving from UIKit to SwiftUI.
- i didn't start with swiftui but rather with scene delegate so i could try to mimic coding enviroment cause i know a lot of the code would be in uikit and the transition to swiftUI would involve a lot of hosting view controlllers
- navigation is a known issue in swiftui and decoupling it from the views is not ideal maybe with navigation stack it is but with the constrain of ios 16  i prefer to use at the moment flows or coordinator with hosting view controllers to decouple the view from navigation .
- i tried to compose swiftui views using multiple child views so we can easily reuse a view anywhere in the codebase if needed
- i stuck to @state and @stateobjects and not the new @observable macro again due to ios version constraints

# We use Reactive programming and are currently moving from a self built Reactive-Library to Combine. For asynchronous code we are moving to Swift Concurrency.
- again keeping in mind the environment of moving i started out with closure for asynchronous code like networking backed by tests and then i provided the clients the option to use async await using the checkedthrowing api provided by apple . the goal is to let the clients use the new async await while slowly moving away from closure based syntax or delegate if you use that but i guess completion handlers are more common. its important to test your async concurrent code and this involves a difference here as with completion handlers it's very easy to use a spy and capture it and complete whenever and however you want but we don't have that luxery with async await so i moved from spying to stubbing . 
- i limited the use of combine to the presentation layer only for my view models.
- ideally combine or any 3rd party frameworks shouldn't be coupled with your layers especially your domain layer . your domain layer shouldn't depend on anything to allow for decoupled code
- if you want to decouple one layer more you can add in an adapter layer which would adapt bw your domain and presentation layer and this way your presentation and domain don't know about each other. The adapter lives in the composition root so it knows about both the layers . you can also use universal abstractions to move away from dependency injection and just compose .

# We try to keep to as few external dependencies as possible. However, we use Swift Package Manager when we need to add a dependency.
keeping this point in mind i used spm only snapshot my views for regression using SnapshotTesting library and nothing else

#  We are using Jenkins to build, test and deploy our Apps.
i tried to use github actions to achive some sort CI

## Disclaimer

All rights reserved, 2022 Loyalty Partner GmbH. Any transfer to third parties and/or reproduction is not permitted.
