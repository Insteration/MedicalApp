
import UIKit
import WebKit

class LibraryViewController: UIViewController {
    
    @IBOutlet weak var libraryWebView: WKWebView!
    @IBOutlet weak var libraryTextView: UITextView!
    var db = DB()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .background).async {
            let dbThread = self.db
//            var slideWord = String()
            
            DispatchQueue.main.async {
                for i in 1...7 {
                    dbThread.createDict(i)
                    print("slide \(i) is done to table list_word")
                }
//                self.libraryTextView.text = slideWord
//                print(slideWord)
            }
        }
        
        // TODO: - make with thread only read DB
        let html = db.getHTML(7)
        libraryWebView.loadHTMLString(html, baseURL: nil)

    }
}
