
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
        
        libraryTextView.text = db.getHTML()
        
        libraryWebView.load(URLRequest(url: URL(string: "file:///Users/artem/Desktop/courses/Swift/step/team%20git/MedicalApp/MedicalApp/Resources/slide_example/Back.html")!))
        
        //        myWebKit.load(URLRequest(url: URL(string: "file:///Users/alexkholodoff/Developer/MedicalApp/slide_exapmple/Core.html")!))
        
//        libraryTextView.text = answer1
    }
}
