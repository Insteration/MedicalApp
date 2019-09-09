
import UIKit
import WebKit

class LibraryViewController: UIViewController, ParserProtocol {
    
    @IBOutlet weak var libraryWebView: WKWebView!
    @IBOutlet weak var libraryTextView: UITextView!
    var db = DB()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var slideWord = String()
        
        for i in 1...4 {
            slideWord += db.updateTXT(i)
        }
        
        libraryTextView.text = slideWord
        print(slideWord)
        
//        let html = db.getHTML(4)
//        
//        libraryWebView.loadHTMLString(html, baseURL: nil)
        
        print(db.openDB())
    }
}
