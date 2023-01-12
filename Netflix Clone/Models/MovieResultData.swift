// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let tvResult = try? JSONDecoder().decode(TvResult.self, from: jsonData)

import Foundation


// MARK: - TVResult

struct MovieResultData: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let backdrop_path : String?
    let id : Int
    let name : String?
    let title: String?
    let original_language : String?
    let originalLanguage: String?
    let original_name : String?
    let originalTitle : String?
    let overview : String?
    let poster_path : String?
    let media_type : String?
    let popularity : Double
    let vote_average : Double?
    let releaseDate: String?
    let vote_count : Int
}
