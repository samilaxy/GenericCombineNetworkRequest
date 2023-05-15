# GenericCombineNetworkRequest

Generic Combine Networking Layer in iOS apps.
![image](https://github.com/samilaxy/GenericCombineNetworkRequest/assets/59480282/fa9b8814-743f-469b-94d1-22a5cb34b853)

In the world of iOS development, networking is an essential aspect of any app. Whether you're connecting to a RESTful API or sending data to a server, networking is what allows your app to communicate with external services. As such, having a reliable and efficient networking layer is critical to the success of any iOS app.
What is a Generic Combine Networking Layer?
A generic Combine networking layer is a networking layer that uses the Combine framework to handle network requests. The layer is designed to be generic, meaning that it can be used with any API or backend service, as long as it follows a few basic conventions.
The core of the networking layer is a set of Combine publishers that represent network requests. These publishers are responsible for making the actual network requests and emitting events as the request progresses. For example, a publisher might emit a value when the request starts, another value when the request completes successfully, and an error value if the request fails.

---

Benefits of a Generic Combine Networking Layer
There are several benefits to using a generic Combine networking layer in your iOS app:
Consistency: By using a generic networking layer, you can ensure that all network requests in your app follow the same conventions and use the same error handling and retry logic.
Reusability: Because the networking layer is generic, it can be reused across multiple projects and APIs. This can save development time and make it easier to maintain and update your networking code.
Testability: Because Combine publishers are composable, it's easy to write unit tests for your networking layer. You can create mock publishers that emit specific events and use them to test your app's behavior in different network scenarios.
Debuggability: Combine provides powerful debugging tools that make it easy to inspect the flow of events in your networking layer. You can use Xcode's debugger to step through the chain of operators and see exactly what's happening at each stage of the request.
Performance: Because Combine publishers are lazy and only emit events when there's a subscriber, they can help reduce the overhead of network requests. Publishers can also be used to batch multiple requests into a single network call, which can further improve performance.

Enough of the talking let's show code 👨‍💻 .

---

1. First, we need a protocol, that will be inherited and implemented by our enum for the endpoints we will create later and an enum for HTTPMethod.
protocol Request {
    var url: URL { get }
    var httpMethod: HTTPMethod { get }
    var isJSONEncoded: Bool { get }
}

// The Request Method
enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}
The Request protocol declares the following properties:
url: It is a variable of type URL. It represents the URL of the request. The get keyword indicates that conforming types must provide a getter for this property, but they can choose to provide a setter as well if needed.
httpMethod: It is a variable of type HTTPMethod. It represents the HTTP method to be used for the request, such as GET, POST, PUT, DELETE, etc. Like url, it requires a getter but doesn't require a setter.
isJSONEncoded: It is a variable of type Bool. It indicates whether the request data is JSON encoded or not. If true, it suggests that the request data should be sent in JSON format. Again, it requires a getter but not a setter.

By defining this protocol, you're creating a contract that any type conforming to the Request protocol must provide implementations for these properties. This allows you to write generic code that can work with any type that adheres to the Request protocol, regardless of its specific implementation.

2. Create an enum and specify all the endpoints and implement the Request protocol.
enum EndPointEnum {
    case users
    case posts
    case create
}
Implement the Request protocol by providing the HTTP method, URL, and boolean to specify requests sending JSON data based on the endpoint. 
The purpose of this computed property is to provide a convenient way to retrieve the appropriate URL based on the enum case. By accessing url on an instance of the enum, you can obtain the corresponding URL for that case.
   // defining end point types
extension EndPointEnum: Request {
    
        // is Json encoded
    var isJSONEncoded: Bool {
        switch self {
            case .users, .posts:
                return false
            case .create:
                return true
        }
    }
        // is http request methods
    var httpMethod: HTTPMethod {
        switch self {
                    // Post Method
            case .create:
                return .post
                    // Get Method
            case .users, .posts:
                return .get
        }
    }
        // full URL to return
    var url: URL {
        switch self {
            case .users:
                return APIFullURLs.users
            case .posts:
                return APIFullURLs.posts
            case .create:
                return APIFullURLs.posts
        }
    }
}
The code provided below defines a structure APIFullURLs and a class EndPoints that is used to construct URLs for an API.
The EndPoints class has the following components:
baseURL: A string variable that represents the base URL of the API.
requestedURL: A URL variable that represents the final constructed URL.

   // specify endpoints to be added to base url
struct APIFullURLs {
    static let users = EndPoints(with: "/users").requestedURL
    static let posts = EndPoints(with: "/posts").requestedURL
    init() {}
}

    // Construct url
class EndPoints {
        // MARK: - Public variables
    let baseURL = "https://jsonplaceholder.typicode.com"
    var requestedURL: URL
    
        // MARK: - Required init
    required init(with URI: String) {
        
        let urlString = baseURL + URI
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        requestedURL =  url
    }
}

3. Contruct the models. Overall, these structs provide a way to represent data in an iOS application and enable easy serialization and deserialization of these data models to and from external representations.
struct User: Codable, Identifiable {
    let id: Int
    let name: String
}

struct Post: Decodable,  Identifiable {
    let id: Int
    let userId: Int
    let body: String
    let title: String
}

4. Now let's create the request with the endpoint enum.
 Pass the endpoint enum as a parameter to the request function and the request params. The generic constraint <T: Decodable> specifies that the type T must conform to the Decodable protocol. This means that the function expects the response from the API to be able to decode into a value of type T.
Define a typealiasfor your Params.
typealias Params = [String: Any]
The line typealias Params = [String: Any] defines a typealias in Swift. It creates an alias Params for a specific type, in this case [String: Any].
Also an enum for the HTTPMethod. 
enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}s
Using an enumeration for HTTP methods helps improve code readability, reduces the risk of typos, and provides a clear and standardized way to work with different HTTP methods in your network code.
    //
    //  NetworkManager.swift
    //  NetworkRequestCombine
    //
    //  Created by Noye Samuel on 10/05/2023.
    //

import Foundation
import Combine

class NetworkManager {
    
    func request<T: Decodable>(from endPoint: EndPointEnum, paramsData: Params?) ->AnyPublisher<T, Error> {
        
            // Create URL components from the base URL
        var urlComponents = URLComponents(url: endPoint.url, resolvingAgainstBaseURL: false)
        
            // Add query parameters to the URL components for .get requests
        if !endPoint.isJSONEncoded {
            if let params = paramsData {
                urlComponents?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value as? String) }
            }
        }
            // Create a URLRequest from the final URL
        var request = URLRequest(url: urlComponents?.url ?? endPoint.url)
            // Set the HTTP method of the request
        request.httpMethod = endPoint.httpMethod.rawValue
        
            // Set the request body for .post requests
        if endPoint.isJSONEncoded {
            if let parameters = paramsData, let bodyData = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
                request.httpBody = bodyData
            }
        }
        
            // Set common headers, such as API keys and content type
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap({ data, response in
                
                    // If the response is invalid, throw an error
                    // Return Response data if valid
                return data
            })
            .decode(type: T.self, decoder : JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

5. Now, our generic request is done. We will use the request for three instances all implemented in the view model class below.
.get Non-param request.
.get A get request but this time with a query param.
.post A post request passing JSON data to the body.

    //
    //  PostViewModel.swift
    //  NetworkRequestCombine
    //
    //  Created by Noye Samuel on 11/05/2023.
    //

import Foundation
import Combine

class PostViewModel: ObservableObject {
    
    let manager = NetworkManager()
    @Published var posts : [Post] = []
    @Published var users : [User] = []
    @Published var presentAlert = false
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        self.getPosts()
    }
    
        // MARK: - Non-param request
    func getPosts(){
        manager.request(from: .posts, paramsData: nil)
            .sink { _ in
                
            }  receiveValue: { [weak self] (returnedPost: [Post])  in
                self?.posts = returnedPost
            }.store(in: &cancellables)
    }
    
        // MARK: - A get request with a query param.
    func searchUsers(limit: Int) {
        
        let params: Params = [ ApiKeys.LIMIT: limit ]
        
        manager.request(from: .users, paramsData: params)
            .sink(receiveCompletion: { completion in
                    // Handle completion or error if needed
            }, receiveValue: { [weak self] (users: [User]) in
                    // Handle the received users
                self?.users = users
            })
            .store(in: &cancellables)
    }
    
    
        // MARK: - A post request passing JSON data to the body.
    func createPost(title: String, body: String){
            // set the data to params format
        let params: Params = [ ApiKeys.TITLE: title , ApiKeys.BODY: body, ApiKeys.USERID: 1, ApiKeys.ID: 101 ]
        
        manager.request(from: .create, paramsData: params)
            .sink ( receiveCompletion: { completion in
                switch(completion){
                    case .finished:
                        print("Post created successfully!")
                        self.presentAlert = true
                    case .failure:
                        print("Post creation failed!")
                        self.presentAlert = false
                }
            },  receiveValue: { (response: Post) in
                print("Post created successfully:", response)
            }).store(in: &cancellables)
    }
    
}

    // specify all api params keys
struct ApiKeys {
    static let TITLE = "title"
    static let BODY = "body"
    static let ID = "id"
    static let USERID = "userId"
}
Specify keys for API parameters. It uses static properties to represent the keys as string constants.
// specify all api params keys
struct ApiKeys {
    static let TITLE = "title"
    static let BODY = "body"
    static let ID = "id"
    static let USERID = "userId"
    static let LIMIT = "limit"
}
Using a struct like ApiKeys to define constants for API parameter keys helps improve code readability, reduces the risk of typos, and provides a centralized place to manage and update these keys.
You can download the complete project here.

---

In conclusion, the Generic Combine Networking Layer is a powerful tool for iOS app developers looking to build apps with robust networking capabilities. By abstracting away the details of networking and providing a standardized way of handling requests and responses, the layer makes it easier to write clean, modular code that is easier to maintain and test. If you're building an iOS app that requires networking, consider using the Generic Combine Networking Layer to simplify your networking code and improve your app's reliability and user experience. Cheers 🥂
