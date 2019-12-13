//
//  LabQuestionsAPIClient.swift
//  LabQuestions
//
//  Created by Maitree Bain on 12/12/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct LabQuestionsAPIClient {
    
    static func fetchQuestions(completion: @escaping (Result<[Question], AppError>) -> ()) {
        let labEndpointURL = "https://5df04c1302b2d90014e1bd66.mockapi.io/questions"
        
        //create a url
        
        guard let url = URL(string: labEndpointURL) else {
            completion(.failure(.badURL(labEndpointURL)))
            return
        }
        
        //Make a URLRequest object to pass to the network helper
        
        let request = URLRequest(url: url)
        
        //set the HTTP method, e.g GET, POST, DELETE, PUT.....
//        request.httpMethod = "POST"
//        request.httpBody = data
        
        //this is required when posting so we inform the POST request
        //of the data type
        // if we do not provide the header value as "application/json"
        // we will get a decoding error when attempting to decode the JSON
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            
            switch result{
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                //construct our [Question] array
                
                do {
                    // JSONDecoder() used to convert web data to Swift models
                    // JSONEncoder() used to convert Swift model to data
                    let questions = try JSONDecoder().decode([Question].self, from: data)
                                    
                    completion(.success(questions))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
    static func postQuestion(question: PostedQuestion, completion: @escaping (Result<Bool, AppError>) -> ()) {
        
        let endPointURL = "https://5df04c1302b2d90014e1bd66.mockapi.io/questions"
        
        //create a url
        guard let url = URL(string: endPointURL) else {
            completion(.failure(.badURL(endPointURL)))
            return
        }
        
        //convert PostedQuestion to Data
        do {
            let data = try JSONEncoder().encode(question)
            
            //configure our URLRequest
            //url
            var request = URLRequest(url: url)
            //type of http method
            request.httpMethod = "POST"
            
            //types of data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            //provide data being sent to web API
            request.httpBody = data
            
            //execute POST request
            //either our compeltion captures Data or an AppError
            NetworkHelper.shared.performDataTask(with: request) { (result) in
                
                switch result{
                case .failure(let appError):
                    completion(.failure(.networkClientError(appError)))
                case .success:
                    completion(.success(true))
                }
            }
            
        } catch {
            completion(.failure(.encodingError(error)))
        }
        
    }
    
}
