
import UIKit
import WebKit

class LibraryViewController: UIViewController {
    
    @IBOutlet weak var libraryWebView: WKWebView!
    @IBOutlet weak var libraryTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var db = DB()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        DispatchQueue.global(qos: .background).async {
//            let dbThread = self.db
////            var slideWord = String()
//            
//            DispatchQueue.main.async {
//                for i in 1...7 {
//                    dbThread.createDict(i)
//                    print("slide \(i) is done to table slides_search")
//                }
////                self.libraryTextView.text = slideWord
////                print(slideWord)
//            }
//        }
        
        // TODO: - make with thread only read DB
        let html = db.getHTML(1)
        libraryWebView.loadHTMLString(html, baseURL: nil)

    }
}

/*
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
{
    let data = NSData(contentsOfURL: NSURL(string: <yourUrlString>)
    var image: UIImage?
    if data != nil {
        artist.vImageData = data
        image = UIImage(data: data!)
    } else {
        image = UIImage(named: <defaultImageLikeNoAvailable>)
    }
    
    dispatch_async(dispatch_get_main_queue()) {
        imageView.image = image
    }
}
*/
