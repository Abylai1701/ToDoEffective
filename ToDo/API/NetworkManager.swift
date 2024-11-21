
import Alamofire
import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let baseURL = "https://dummyjson.com/todos"
    
    private init() {}
    

    private func handleSuccessResponse<T: Decodable>(response: AFDataResponse<Data?>, completion: @escaping (Result<T, Error>) -> Void) {
        guard let statusCode = response.response?.statusCode else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No status code received"])
            completion(.failure(error))
            return
        }
        
        if let data = response.data {
            switch statusCode {
            case 200...299:
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            
            default:
                let error = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected status code: \(statusCode)"])
                completion(.failure(error))
            }
        } else {
            let error = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "No data received"])
            completion(.failure(error))
        }
    }
    
    // MARK: - GET Request
    func getRequest<T: Decodable>(parameters: [String: Any]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        
        var urlComponents = URLComponents(string: baseURL)!
        
        if let parameters = parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        guard let url = urlComponents.url else {
            print("Invalid URL")
            return
        }

        // Отладочный вывод полного URL запроса
        print("Full request URL: \(url.absoluteString)")
        
        AF.request(url.absoluteString, method: .get).response { response in
            // Отладочный вывод полного ответа сервера
            if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                print("Response data: \(responseString)")
            }
            
            switch response.result {
            case .success:
                self.handleSuccessResponse(response: response, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
