import Foundation
import SwiftSoup

struct ParserSoup {
    var document: Document = Document.init("")
    
    
    private mutating func downloadHTML(pathFile: String) {
        // url string to URL
        guard let url = URL(string: pathFile) else {
            // an error occurred
            print("ERROR GET URL")
            return
        }
        
        do {
            // content of url
            let html = try String.init(contentsOf: url)
            // parse it into a Document
            self.document = try SwiftSoup.parse(html)
        } catch let error {
            // an error occurred
            print("ERROR GET DOCUMENT \(error)")        }
        
    }
    
    
    mutating func parse(pathFile: String, cssSelector: String = "*") -> String {
        var items = String()
        downloadHTML(pathFile: pathFile)
        
        do {
            //empty old items
            // firn css selector
            let elements: Elements = try document.select(cssSelector)
            //transform it into a local object (Item)
            for element in elements {
                let text = try element.text()                
                items += "/n" + text
                
                print(text)
            }
            
        } catch let error {
            print("Error: \(error)")
        }
        return items
        
    }
    
    
}
