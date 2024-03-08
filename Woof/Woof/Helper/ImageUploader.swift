//
//  ImageUploader.swift
//  Woof
//
//  Created by Giovanny Joseph on 3/8/24.
//

import Foundation

import UIKit

enum UploadError: Error {
    case invalidData
    case serverError
    case unexpectedResponse
}

class ImageUploader {
    func uploadImage(image: UIImage, type: String, completion: @escaping (Result<Int, UploadError>) -> Void) {
        // Define the URL for uploading the image
        guard let uploadURL = URL(string: "http://localhost:8080/uploads") else {
            completion(.failure(.serverError))
            return
        }
        
        // Create a boundary for the multipart/form-data request
        let boundary = UUID().uuidString
        
        var formData = Data()
        
        // Generate a unique file name
        let fileName = "\(type)Image_\(UUID().uuidString).png"
        
        // Add file data
        formData.append("--\(boundary)\r\n".data(using: .utf8)!) // Start boundary
        formData.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!) // File header
        formData.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!) // Content type header
        formData.append(image.pngData()!) // File data
        formData.append("\r\n".data(using: .utf8)!) // End of file data
        
        // Add type parameter
        formData.append("--\(boundary)\r\n".data(using: .utf8)!) // Boundary before type parameter
        formData.append("Content-Disposition: form-data; name=\"type\"\r\n\r\n".data(using: .utf8)!) // Type parameter header
        formData.append("\(type)\r\n".data(using: .utf8)!) // Type value
        
        // Add boundary end
        formData.append("--\(boundary)--\r\n".data(using: .utf8)!) // End boundary
        
        // Create the request
        var request = URLRequest(url: uploadURL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = formData
        
        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                completion(.failure(.serverError))
                return
            }
            if (200...299).contains(httpResponse.statusCode) {
                do {
                    // Parse the response data as an array of ImageInfo dictionaries
                    let imageInfos = try JSONDecoder().decode([ImageInfo].self, from: data)
                    
                    // Assuming you want to handle each ImageInfo separately
                    for imageInfo in imageInfos {
                        print("Upload success:", imageInfo)
                        // Call updateProfileWithImageID method for each imageInfo
                        completion(.success(imageInfo.imgID))
                    }
                    
                } catch {
                    print("Error decoding response:", error)
                    completion(.failure(.invalidData))
                }
            } else {
                print("Failed to upload profile image: HTTP status code \(httpResponse.statusCode)")
                completion(.failure(.serverError))
            }
        }.resume()
    }
}

