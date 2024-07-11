//
//  NetworkService.swift
//  VideoPlayer
//
//  Created by Sai Balaji on 11/07/24.
//

import Foundation

enum NetworkingError: Error{
    case invalidURL(url: String)
    case invalidResponse
    case invalidStatusCode(code: Int)
    case decodingError(error: DecodingError)
}

extension NetworkingError: LocalizedError{
    var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "The given url \(url) is invalid"
        case .invalidResponse:
            return "Invalid response from the server"
        case .invalidStatusCode(let code):
            return "Invalid Status Code \(code)"
        case .decodingError(error: let error):
            return "Decoding Error: \(error)"
        }
    }
}



class NetworkService{
    static var shared = NetworkService()
    private init(){}
    private var session = URLSession(configuration: .default)
    
    func sendGETRequest<T: Codable>(url: String,responseType: T.Type) async -> Result<T,Error>{
        guard let url = URL(string: url) else{ return .failure(NetworkingError.invalidURL(url: url))}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        do{
            let (data,response) = try await session.data(for: request)
            guard let response = response as? HTTPURLResponse else{return .failure(NetworkingError.invalidResponse)}
            if (200...299).contains(response.statusCode) == false{return .failure(NetworkingError.invalidStatusCode(code: response.statusCode))}
            do{
                let decodedData = try JSONDecoder().decode(responseType, from: data)
                print(decodedData)
                return .success(decodedData)
            }
            catch let error as DecodingError{
                return .failure(NetworkingError.decodingError(error: error))
            }
        }
        catch{
            return .failure(error)
        }
        
    }
}
