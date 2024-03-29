[![CI-iOS](https://github.com/abdahad1996/WorldOfPAYBACK/actions/workflows/ios.yml/badge.svg)](https://github.com/abdahad1996/WorldOfPAYBACK/actions/workflows/ios.yml) (I used up all my free credits)

<img width="484" alt="Screenshot 2024-01-16 at 08 26 51" src="https://github.com/abdahad1996/WorldOfPAYBACK/assets/28492677/8ab18738-881a-45af-b1d7-31d8833cf147">

# SUMMARY
`THIS PROJECT HAS 2 FEATURE LAYERS I VIRTUALLY SEPARATED IN FOLDERS CALLED TRANSACTION AND TRANSACTION DETAILS . THE FEATURE LAYERS CONTAINS THEIR OWN USECASES, API LAYER and Presentation layer . IN THE APP FOLDER IS THE COMPOSITION AND NAVIGATION WHERE I COMPOSE THE OVERALL OBJECT GRAPH AND PASS IT TO THE SCENE DELEGATE TO RUN. `

<img width="400" alt="Screenshot 2024-01-18 at 14 07 09" src="https://github.com/abdahad1996/WorldOfPAYBACK/assets/28492677/8d6ec0ac-c6f2-42e9-b33c-ce4c0e67cace">

# WorldOfPAYBACK

💡 My Motivation for this was based on simulating a real world making sure I think of the design in a critical and scalable way backed by tests which was very fun to do.
1. [Installation Guide](#installation-guide)
2. [Demo Videos](./Readme_Sections/Demo_Videos/Demo_Videos.md#demo-videos)
3. [Requirements](#Requirements)
4. [Tools](#tools)
5. [Frameworks](#frameworks)
6. [Concepts](#concepts)
7. [Architecture](./Readme_Sections/Architecture/Architecture.md#architecture)
    1. [Overview](./Readme_Sections/Architecture/Architecture.md#overview)
    2. [Domain](./Readme_Sections/Architecture/Architecture.md#domain)
        1. [Transaction Feature](./Readme_Sections/Architecture/Architecture.md#1-user-session-feature)
    3. [Networking](./Readme_Sections/Architecture/Architecture.md#networking)
    4. [API Infra](./Readme_Sections/Architecture/Architecture.md#api-infra)
    5. [Presentation](./Readme_Sections/Architecture/Architecture.md#presentation)
    6. [UI](./Readme_Sections/Architecture/Architecture.md#ui)
    7. [Main](./Readme_Sections/Architecture/Architecture.md#main)
8. [Testing Strategy](./Readme_Sections/Testing_Strategy/Testing_Strategy.md#testing-strategy)
    1. [Unit Tests](./Readme_Sections/Testing_Strategy/Testing_Strategy.md#unit-tests)
    2. [Integration Tests](./Readme_Sections/Testing_Strategy/Testing_Strategy.md#integration-tests)
        1. [End-to-End Tests](./Readme_Sections/Testing_Strategy/Testing_Strategy.md#end-to-end-tests)
    3. [Snapshot Tests](./Readme_Sections/Testing_Strategy/Testing_Strategy.md#snapshot-tests)
9. [CI/CD](./Readme_Sections/CI_Security.md#cicd)  
10. [Security](./Readme_Sections/CI_Security.md#security) 
    1. [API key for TransactionApi](./Readme_Sections/CI_Security.md#api-key-for-google-places-api)


Thank you for reading and enjoy! 🚀

## Installation Guide

### 1. Setup `WorldOfPAYBACK` 
- clone the project from the main branch and run the simulator.
- Mock Server completes with success or failure by randomness.
### 2. Validate the setup
Test that everything is wired up correctly by running tests for `CI_IOS` targets to check the communication with both mocked backend and validate that all tests pass.

## Tools
- ✅ Xcode 15.0
- ✅ swift-driver version: 1.87.1 Apple Swift version 5.9 (swiftlang-5.9.0.128.108 clang-1500.0.40.1)

## Frameworks
- ✅ SwiftUI
- ✅ Combine
- ✅ Foundation
- ✅ UIKit

## Concepts
- ✅ MVVM, Clean Architecture
- ✅ Modular Design
- ✅ SOLID Principles
- ✅ TDD, Unit Testing, Integration Testing, Snapshot Testing, and UI Testing using Page Object Pattern
- ✅ Dependency injection and Dependency Inversion
- ✅ Composition Root, Decorator Patterns
- ✅ Domain-Driven Design

## Requirements

Please create a SwiftUI App based on the following User-Stories:

✅ As a user of the App, I want to see a list of (mocked) transactions. Each item in the list displays `bookingDate`, `partnerDisplayName`, `transactionDetail.description`, `value.amount`, and `value.currency`. *(see attached JSON File)*

✅ As a user of the App, I want to have the list of transactions sorted by `bookingDate` from newest (top) to oldest (bottom).

✅ As a user of the App, I want to get feedback when the loading of the transactions is ongoing or an Error occurs. *(Just delay the mocked server response for 1-2 seconds and randomly fail it)*

✅ As a user of the App, I want to see an error if the device is offline.
- From the Apple docs:
`Always attempt to make a connection. Do not attempt to guess whether network service is available, and do not cache that determination.`
It’s common to see iOS codebases using SCNetworkReachability, NWPathMonitor, or third-party reachability frameworks to make decisions about whether they should make a network request or not. Unfortunately, such a process is not reliable and can lead to a bad customer experience.

hence i did not use SCNetworkReachability or NWPathMonitor and just have a `generic Connection Error` in case my request fails

✅ As a user of the App, I want to filter the list of transactions by `category`.

✅ As a user of the App, I want to see the sum of filtered transactions somewhere on the Transaction-list view. *(Sum of `value.amount`)*

✅ As a user of the App, I want to select a transaction and navigate to its details. The details view should just display `partnerDisplayName` and `transactionDetail.description`.

✅ As a user of the App, I like to see nice UI in general. However, for this coding challenge fancy UI is not required.

## We can extend our functionality using the same concepts and below is an example of Vertical Slicing
`features can be vertically sliced and composed in the main module by following dependency injection/inversion, clean architecture, and domain driven design which allows us to have decoupled modules and gives you the freedom to compose however you like. Makes the code more testable maintainable and soft making it easy to add new requirements. I added a general example of a design diagram below`

<img width="1010" alt="Screenshot 2024-01-16 at 14 41 50" src="https://github.com/abdahad1996/WorldOfPAYBACK/assets/28492677/e9b1e6c3-1dc8-41ba-be44-6041d32aee2e">



## Simulation Environment 
 # transition phase of moving from UIKit to SwiftUI.
- I didn't start with swiftui but rather with scene delegate so I could try to mimic Simulation  cause i know a lot of legacy code is in uikit and the transition to swiftUI would involve a lot of hosting view controllers.
- navigation is a known issue in swiftui and decoupling it from the views is not ideal maybe with navigation stack it is but with the constrain of ios 16 so i prefer to use at the moment flows or coordinator with hosting view controllers to decouple the view from navigation .
- I tried to compose swiftui views using multiple child views so we can easily reuse a view anywhere in the codebase if needed
- i stuck to @state and @stateobjects and not the new @observable macro again due to ios version constraints

# We use Reactive programming and are currently moving from a Rx-Swift to Combine. For asynchronous code we are moving to Swift Concurrency.
- again keeping in mind the Simulation. I started out with closure for asynchronous code like networking backed by tests and then i provided the clients the option to use async await using the checkedthrowing api provided by apple . the goal is to let the clients use the new async await while slowly moving away from closure based syntax or delegate if you use that but i guess completion handlers are more common. its important to test your async concurrent code and this involves a difference here as with completion handlers it's very easy to use a spy and capture it and complete whenever and however you want but we don't have that luxury with async await so i moved from spying to stubbing . 
- i limited the use of combine to the presentation layer only for my view models.
- ideally combine or any 3rd party frameworks shouldn't be coupled with your layers especially your domain layer . your domain layer shouldn't depend on anything to allow for decoupled code
- if you want to decouple one layer more you can add in an adapter layer which would adapt bw your domain and presentation layer and this way your presentation and domain don't know about each other. The adapter lives in the composition root so it knows about both the layers . you can also use universal abstractions to move away from dependency injection and just compose .

# We try to keep to as few external dependencies as possible. However, we use Swift Package Manager when we need to add a dependency.
keeping this point in mind i used spm only snapshot my views for regression using SnapshotTesting library and nothing else

#  We are using Jenkins to build, test and deploy our Apps.
i tried to use github actions to achive some sort CI


