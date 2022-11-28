import Foundation
import UIKit
struct Movies:Decodable{
    var d: [Movie]
    var q: String
    var v: Int
}
struct image: Decodable{
    var height: Int
    var imageUrl: String
    var width: Int
}
struct Movie: Decodable{
    var i: image 
    var l: String
    var q: String
    var rank: Int
    var s: String
    var y: Int
}
