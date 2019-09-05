
import UIKit
import WebKit

class LibraryViewController: UIViewController, ParserProtocol {
    
    @IBOutlet weak var libraryWebView: WKWebView!
    @IBOutlet weak var libraryTextView: UITextView!
    var db = DB()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let answer = parse(pathFile: "file:///Users/artem/Desktop/courses/Swift/step/team%20git/MedicalApp/MedicalApp/Resources/slide_example/Back.html")
        
        //        let answer1 = parse(pathFile: "file:///Users/artem/Desktop/courses/Swift/step/team%20git/MedicalApp/MedicalApp/Resources/slide_example/Back.html", cssSelector: "div")
        
        //        let html = getHTML()
        //        let parseRString = parse(htmlString: html, cssSelector: "div")
        //        let parseRString = parse(htmlString: html, cssSelector: "title")
        
        //        libraryTextView.text = html
        //        libraryTextView.text = parseRString
        
        //        libraryWebView.loadHTMLString(html, baseURL: nil)
        
        //        libraryWebView.load(URLRequest(url: URL(string: "file:///Users/alexkholodoff/Developer/MedicalApp/MedicalApp/MedicalApp/Resources/slide_example/Core.html")!))
        
        let path = db.openDB()
        db.updateTXT()
        db.closeDB()
        print(path)
    }
}
