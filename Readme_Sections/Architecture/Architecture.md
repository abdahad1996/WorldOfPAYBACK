## Architecture

### Overview

For this project, I organized the codebase into `Vertical Slices or Vertical features` , inside each Vertical Slice I am using `horizontal slicing` to break down the slice into layers, while respecting the dependency rule:

> ❗️ High-level modules should not depend on lower-level modules and lower-level modules should only communicate and know about the next higher-level layer.

In my opinion, it's the best approach for this kind of project since `vertical slicing` is  suitable for larger projects with feature teams and keeping in view of future i thought this was the best way to go forward.

The following diagram shows a high level structure of the whole app

<img width="658" alt="Screenshot 2024-01-16 at 10 08 53" src="https://github.com/abdahad1996/WorldOfPAYBACK/assets/28492677/9982e2a4-6b30-4f06-ab61-2fb798de523e">


The Transaction Detail feature only has a UI layer and a presentation layer since it's dependent on the Transaction Module due to Transaction domain model but it is made in a way that if tomorrow a need arises for Transaction Detail feature to have it's own domain and own abstractions along with its interactors and controllers it's scalable. but for now simply passing in the Transaction domain model to it is okay.

I'll talk a bit deeply about the Transaction feature as it is the one doing the heavy lifting.
The following diagram is a provides a top-level view of Transaction Feature with all horizontal modules.
1. [Domain](#domain)
2. [Remote Transaction Loader](#networking)
4. [API Infra](#api-infra)
7. [Presentation](#presentation)
8. [UI](#ui)
9. [Main](#main) (Composition Root)


     <img width="651" alt="Screenshot 2024-01-16 at 10 11 26" src="https://github.com/abdahad1996/WorldOfPAYBACK/assets/28492677/0a924ea0-78a3-4f38-8a12-b138a0374775">
     
### Domain

The domain represents the innermost layer in the architecture (no dependencies with other layers). It contains only models and abstractions for:
- fetching data by the [Remote Transaction Loader](#networking)
- the [Presentation](#presentation) module to obtain relevant data and convert it to the format required by the [UI](#ui) module

#### 1. User Session Feature

```swift
public struct TransactionItem:Hashable{
    public let partnerDisplayName: String
    public let bookingDate: Date
    public let description: String?
    public let amount: Int
    public let currency: String
    public let category:Int
    
   public init(partnerDisplayName: String, bookingDate: Date, description: String?, amount: Int, currency: String,category:Int) {
        self.partnerDisplayName = partnerDisplayName
        self.bookingDate = bookingDate
        self.description = description
        self.amount = amount
        self.currency = currency
        self.category = category
    }
}
```

```swift
public protocol TransactionLoader {
    typealias Result = Swift.Result<[TransactionItem], Error>
    
    func load() async throws -> [TransactionItem]
    func load(completion: @escaping (Result) -> Void)
}
```

### Networking
The following diagram showcases the networking layer, which communicates with my backend app. For a better understanding, 

   
#### 3. Endpoint Creation


#### 4. Testing `Data` to `Decodable` Mapping

For testing the mapping from `Data` to `Decodable` I preferred to test it directly in the `RemoteStore`, hiding the knowledge of a collaborator (in this case `CodableDataParser`). While I could have accomplished this using a stubbed collaborator (e.g. a protocol `DataParser`), I prefered to test it in integration, resulting in lower complexity and coupling of tests with the production code.

#### 5. Parsing JSON Response

To parse the JSON received from the server I had two alternatives:
1. To make domain models conform to `Codable` and use them directly to decode the data
2. Create distinct representation for each domain model that needs to be parsed

I ended up choosing the second approach as I didn't want to leak the details of the concrete implementation outside of the module because it would 


 

#### From delegation to async/await

Since all modules use the `async/await` concurrency module, I needed to switch from the usual delegation pattern that `CoreLocation` uses to advertise the current location.


> ❗️ Resuming a continuation must be made exactly once. Otherwise, it results in undefined behaviour, that's why I set it to nil after each resume call, to prevent calling it on the same instance again. Not calling it leaves the task in a suspended state indefinitely. (Apple docs: [CheckedContinuation](https://developer.apple.com/documentation/swift/checkedcontinuation))

### Presentation

This layer makes the requests for getting data using a service and it formats the data exactly how the `UI` module requires it.

By decoupling view models from the concrete implementations of the services allowed me to simply add the caching and the fallback features later on without changing the view models and shows how the view models conform to the `Open/Closed Principle`. Additionally, since I created separate abstractions for each request, I was able to gradually add functionalities. For this reason, each view model has access to methods it only cares about, thus respecting the `Interface Segregation Principle` and making the concrete implementations depend on the clients' needs as they must conform to the protocol.

This layer is also responsible for localization and any sort of formatting of data before it is presented it is usally plaform agnostic and you can reuse this logic anywhere.

<img width="274" alt="Screenshot 2024-01-16 at 10 53 51" src="https://github.com/abdahad1996/WorldOfPAYBACK/assets/28492677/860c3631-7ff6-4bb6-914e-019a6a5e6ae9">


Thus, by introducing abstractions, I increased the testability of the view models since mocking their collaborators during testing is a lot easier.

### UI

The following diagram is the tree-like representation of all the screens in the app. To increase the reusability of views, I made the decision to move the responsibility of creating subviews to the layer above, meaning the composition root. Additionally, I decoupled all views from the navigation logic by using closures to trigger transitions between them (More details in the [Main](#main) section).

The best example is the `HomeView` which is defined as a generic view requiring:
- one closure to signal that the app should navigate to the restaurant details screen (the view being completely agnostic on how the navigation is done)
- one closure that receives a `NearbyRestaurant` and returns a `Cell` view to be rendered (the view is not responsible for creating the cell and doesn't care what cell it receives)
- one closure that receives a binding to a `String` and returns a view for searching nearby restaurants

Furthermore, I avoid making views to depend on their subviews' dependencies by moving the responsibility of creating its subviews to the composition root. Thus, I keep the views constructors containing only dependencies they use.

```swift

public struct TransactionsView<TransactionCell: View, TransactionFilterView: View, TotalCountView:View>: View {
    @StateObject var viewModel: TransactionViewModel
    let showTransactionDetails: (TransactionItem) -> Void
    let transactionCell: (TransactionItem) -> TransactionCell
    let transactionFilterView: (Binding<Int>,[Int]) -> TransactionFilterView
    let totalCountView:(Binding<Int>) -> TotalCountView

    ...
```

### Main

This module is responsible for instantiation and composing all independent modules in a centralized location which simplifies the management of modules, components and their dependencies, thus removing the need for them to communicate directly, increasing the composability and extensibility of the system (`Open/Closed Principle`).

Moreover, it represents the composition root of the app and handles the following responsiblities:
1. Responsible for the Instantiation and life cycle of all  classes and structs,
2. [Adding Sorting Behaviour by intercepting Transaction Loader](#adding-caching-by-intercepting-network-requests) (`Decorator Pattern`)
3. [Handling navigation](#handling-navigation) (flat and hierarchical navigation)




#### Handling navigation

##### Flat Navigation

I created a custom tab bar to handle the flat navigation by using a `TabRouter` observable object to navigate at the corresponding page when the user taps on a tab icon. The `Page` enum holds cases for all the available tabs.

```swift
class TabRouter: ObservableObject {
    enum Page {
        case home
        case newReview
        case account
    }
    
    @Published var currentPage: Page = .home
}
```

Each view presented in the tab bar is wrapped in a `TabBarPageView` container. Creating a new view is a matter of adding a new case in the `Page` enum and wrapping the view in the tab bar while switching through the current page.

##### Hierarchical Navigation

To implement this kind of navigation, I used the new `NavigationStack` type introduced in iOS 16. Firstly, I created a generic `Flow` class that can append or remove a new route.

```swift
final class Flow<Route: Hashable>: ObservableObject {
    @Published var path = [Route]()
    
    func append(_ value: Route) {
        path.append(value)
    }
    
    func navigateBack() {
        path.removeLast()
    }
}
```

I handled all the hierarchical navigation throughout the app, which allowed me to change the screens order from the composition root without affecting other modules. In addition, it improves the overall flexibility and modularity of the system, as the views don't have knowledge about the navigation implementation.
