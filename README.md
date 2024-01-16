[![CI-iOS](https://github.com/Marian25/Foodybite/actions/workflows/ios.yml/badge.svg)](https://github.com/Marian25/Foodybite/actions/workflows/ios.yml)

# Foodybite

💡 My vision for this project is centered around a simple yet powerful way to create a user-friendly app that helps you find the best restaurant near you based on location, radius, and number of stars. Additionally, users can see details, like opening hours, address, reviews, or photos for each restaurant found and give a review. The app allows users to search directly for a restaurant and enables them to give a review right away.

1. [Motivation](#motivation)
2. [Installation Guide](#installation-guide)
3. [Demo Videos](./Readme_Sections/Demo_Videos/Demo_Videos.md#demo-videos)
4. [Requirements](#tools)
5. [Frameworks](#frameworks)
6. [Concepts](#concepts)
7. [Architecture](./Readme_Sections/Architecture/Architecture.md#architecture)
    1. [Overview](./Readme_Sections/Architecture/Architecture.md#overview)
    2. [Domain](./Readme_Sections/Architecture/Architecture.md#domain)
        1. [User Session Feature](./Readme_Sections/Architecture/Architecture.md#1-user-session-feature)
        2. [Update/Delete Account Feature](./Readme_Sections/Architecture/Architecture.md#2-updatedelete-account-feature)
        3. [Store/Retrieve User Preferences Feature](./Readme_Sections/Architecture/Architecture.md#3-storeretrieve-user-preferences-feature)
        4. [Nearby Restaurants Feature](./Readme_Sections/Architecture/Architecture.md#4-nearby-restaurants-feature)
        5. [Fetch Restaurant Photo Feature](./Readme_Sections/Architecture/Architecture.md#5-fetch-restaurant-photo-feature)
        6. [Restaurant Details Feature](./Readme_Sections/Architecture/Architecture.md#6-restaurant-details-feature)
        7. [Autocomplete Restaurants Feature](./Readme_Sections/Architecture/Architecture.md#7-autocomplete-restaurants-feature)
        8. [Add Review Feature](./Readme_Sections/Architecture/Architecture.md#8-add-review-feature)
        9. [Get Reviews Feature](./Readme_Sections/Architecture/Architecture.md#9-get-reviews-feature)
        10. [Location Feature](./Readme_Sections/Architecture/Architecture.md#10-location-feature)
    3. [Networking](./Readme_Sections/Architecture/Architecture.md#networking)
        1. [Refresh Token Strategy](./Readme_Sections/Architecture/Architecture.md#1-refresh-token-strategy)
        2. [Network Request Flow](./Readme_Sections/Architecture/Architecture.md#2-network-request-flow)
        3. [Endpoint Creation](./Readme_Sections/Architecture/Architecture.md#3-endpoint-creation)
        4. [Testing `Data` to `Decodable` Mapping](./Readme_Sections/Architecture/Architecture.md#4-testing-data-to-decodable-mapping)
        5. [Parsing JSON Response](./Readme_Sections/Architecture/Architecture.md#5-parsing-json-response)
    4. [Places](./Readme_Sections/Architecture/Architecture.md#places)
    5. [API Infra](./Readme_Sections/Architecture/Architecture.md#api-infra)
        1. [Mock Network Requests](./Readme_Sections/Architecture/Architecture.md#mock-network-requests)
    6. [Persistence](./Readme_Sections/Architecture/Architecture.md#persistence)
        1. [Cache Domain Models](./Readme_Sections/Architecture/Architecture.md#cache-domain-models)
        2. [Infrastructure](./Readme_Sections/Architecture/Architecture.md#infrastructure)
        3. [Store User Preferences](./Readme_Sections/Architecture/Architecture.md#store-user-preferences)
    7. [Location](./Readme_Sections/Architecture/Architecture.md#location)
        1. [From delegation to async/await](./Readme_Sections/Architecture/Architecture.md#from-delegation-to-asyncawait)
        2. [Get current location using TDD](./Readme_Sections/Architecture/Architecture.md#get-current-location-using-tdd)
    8. [Presentation](./Readme_Sections/Architecture/Architecture.md#presentation)
    9. [UI](./Readme_Sections/Architecture/Architecture.md#ui)
    10. [Main](./Readme_Sections/Architecture/Architecture.md#main)
        1. [Adding caching by intercepting network requests](./Readme_Sections/Architecture/Architecture.md#adding-caching-by-intercepting-network-requests) (`Decorator Pattern`)
        2. [Adding fallback strategies when network requests fail](./Readme_Sections/Architecture/Architecture.md#adding-fallback-strategies-when-network-requests-fail) (`Composite Pattern`)
        3. [Handling navigation](./Readme_Sections/Architecture/Architecture.md#handling-navigation) (flat and hierarchical navigation)
8. [Testing Strategy](./Readme_Sections/Testing_Strategy/Testing_Strategy.md#testing-strategy)
    1. [Summary Table](./Readme_Sections/Testing_Strategy/Testing_Strategy.md#summary-table)
    2. [Methodology](./Readme_Sections/Testing_Strategy/Testing_Strategy.md#methodology)
    3. [Unit Tests](./Readme_Sections/Testing_Strategy/Testing_Strategy.md#unit-tests)
    4. [Integration Tests](./Readme_Sections/Testing_Strategy/Testing_Strategy.md#integration-tests)
        1. [End-to-End Tests](./Readme_Sections/Testing_Strategy/Testing_Strategy.md#end-to-end-tests)
        2. [Cache Integration Tests](./Readme_Sections/Testing_Strategy/Testing_Strategy.md#cache-integration-tests)
    5. [Snapshot Tests](./Readme_Sections/Testing_Strategy/Testing_Strategy.md#snapshot-tests)
9. [CI/CD](./Readme_Sections/CI_Security.md#cicd)
10. [Security](./Readme_Sections/CI_Security.md#security)
    1. [API key for Google Places API](./Readme_Sections/CI_Security.md#api-key-for-google-places-api)
    2. [Store Tokens from FoodybiteServer in Keychain](./Readme_Sections/CI_Security.md#store-tokens-from-foodybiteserver-in-keychain)
    3. [Password Hashing](./Readme_Sections/CI_Security.md#password-hashing)
11. [Metrics](./Readme_Sections/Metrics/Metrics.md#metrics)
    1. [Test lines of code per production lines of code](./Readme_Sections/Metrics/Metrics.md#test-lines-of-code-per-production-lines-of-code)
    2. [Count of files changed](./Readme_Sections/Metrics/Metrics.md#count-of-files-changed)
    3. [Code coverage](./Readme_Sections/Metrics/Metrics.md#code-coverage)
12. [Credits](#credits)
13. [References](#references)

## Motivation

The initial spark of this project originated from my desire to dive deeper into `SwiftUI` since I had already been using the framework for testing purposes and was intrigued to use it in a larger project.

Once I had completed the UI, I challenged myself to design the app in the best possible way using all the best practices in order to create a high-quality, polished project and sharpen my skills. At the same time, my interest in `TDD` and modular design were emerging, that's the reason I only used `TDD` for all modules besides the UI, which I later used for snapshot tests. 😀

Through this process, I was able to significantly improve my `TDD` skills and acknowledge its value. First of all, it helped me understand better what I was trying to achieve and have a clear picture of what I wanted to test first before writing production code. On the other hand, the architecture seemed to materialize while I was writing the tests, and by using `TDD`, I could further improve the initial design.

You can find below the entire process I've gone through while designing this project, the decisions and trade-offs regarding the architecture, testing pyramid and security issues. Additionally, I've included some really cool metrics about the evolution of the codebase.

Thank you for reading and enjoy! 🚀

## Installation Guide

### 1. Setup `Foodybite` backend
- Download [`FoodybiteServer`](https://github.com/Marian25/FoodybiteServer) locally
- Follow the instructions to run it

### 2. Get your unique `API_Key` from `Google Places`
- Go to [Google Maps Platform](https://developers.google.com/maps/documentation/places/web-service/cloud-setup) to create a project
- Create the `API_KEY` following the [Use API Keys with Places API](https://developers.google.com/maps/documentation/places/web-service/get-api-key) documentation page (make sure you restrict your key to only be used with `Places API`)
- Create a property list called `GooglePlaces-Info.plist` in the `FoodybitePlaces` framework
- Add a row with `API_KEY` and the value of your key

### 3. (Optionally) Install SwiftLint
- run the following command in the terminal to install `swiftlint`

```bash
brew install swiftlint 
```

### 4. Validate the setup
Test that everything is wired up correctly by running tests for the `FoodybiteAPIEndtoEndTests` and `CI` targets to check the communication with both backends and validate that all tests pass.

## Tools
- ✅ Xcode 14.2
- ✅ Swift 5.7

## Frameworks
- ✅ SwiftUI
- ✅ Combine
- ✅ CoreData
- ✅ CoreLocation

## Concepts
- ✅ MVVM, Clean Architecture
- ✅ Modular Design
- ✅ SOLID Principles
- ✅ TDD, Unit Testing, Integration Testing, Snapshot Testing
- ✅ Composite, Decorator Patterns
- ✅ Domain-Driven Design

## "WorldOfPAYBACK" App - Requirements

Please create a SwiftUI App based on the following User-Stories:

✅ As a user of the App, I want to see a list of (mocked) transactions. Each item in the list displays `bookingDate`, `partnerDisplayName`, `transactionDetail.description`, `value.amount` and `value.currency`. *(see attached JSON File)*

✅ As a user of the App, I want to have the list of transactions sorted by `bookingDate` from newest (top) to oldest (bottom).

✅ As a user of the App, I want to get feedback when loading of the transactions is ongoing or an Error occurs. *(Just delay the mocked server response for 1-2 seconds and randomly fail it)*

✅ As a user of the App, I want to see an error if the device is offline.

✅ As a user of the App, I want to filter the list of transactions by `category`.

✅ As a user of the App, I want to see the sum of filtered transactions somewhere on the Transaction-list view. *(Sum of `value.amount`)*

✅ As a user of the App, I want to select a transaction and navigate to its details. The details-view should just display `partnerDisplayName` and `transactionDetail.description`.

✅ As a user of the App, I like to see nice UI in general. However, for this coding challenge fancy UI is not required.

## "WorldOfPAYBACK" App - General Information

* Attached you will find a JSON File (`PBTransactions.json`) which contains a list of transactions. Just assume that the Backend is not ready yet and the App needs to work with mocked data meanwhile. For now, the Backend-Team has just provided the name of the endpoints for the new Service: 
    * Production Environment: "GET https://api.payback.com/transactions"
    * Test Environment: "GET https://api-test.payback.com/transactions"
* The App is planned to be maintained over a long period of time. New Features will be added by a growing Team in the near future.
* The App is planned to be available worldwide supporting many different languages and region related formatting (e.g. Date and Number formatting).
* The Feature you are currently working on is the first out of many. Multiple Teams will add more features in the near future (overall Team size is about 8 Developers and growing). The following list of Features (which are not part of this coding challenge) will give you an idea of what's planned for the upcoming releases.
 
    1.     "Feed"-Feature: Displays different, user-targeted content (displayed via webviews, images, ads etc.). **Note:** It is also planned to display the sum of all Transactions from the "Transaction"-Feature.
    2. "Online Shopping"-Feature: Lists PAYBACK Partners and gives the possibility to jump to their App/Website.
    3. "Settings"-Feature: Gives the possibility to adjust general Settings.


## PAYBACK Environment(this code was build thinking in terms of the PAYBACK environment)
 # transition phase of moving from UIKit to SwiftUI.
- i didn't start with swiftui but rather with scene delegate so i could try to mimic coding enviroment cause i know a lot of the code would be in uikit and the transition to swiftUI would involve a lot of hosting view controlllers.
- navigation is a known issue in swiftui and decoupling it from the views is not ideal maybe with navigation stack it is but with the constrain of ios 16 so i prefer to use at the moment flows or coordinator with hosting view controllers to decouple the view from navigation .
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

