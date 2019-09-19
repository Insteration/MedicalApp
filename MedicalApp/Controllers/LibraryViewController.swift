
import UIKit
import WebKit

class LibraryViewController: UIViewController {
    
    @IBOutlet weak var libraryWebView: WKWebView!
    @IBOutlet weak var libraryTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var db = DB()
//    var fm = FM()
    
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
        
        getImage(1)
        getImage(2)
        getImage(3)
        getImage(4)
        
        // TODO: - make with thread only read DB
        let html = db.getHTML(8)
        let documentsDirectoryURL = FM.documentsDirectoryURL
//        print("documentsDirectoryURL = ", documentsDirectoryURL)
        
//        libraryWebView.allow
        libraryWebView.loadHTMLString(html, baseURL: documentsDirectoryURL)

    }
}

// MARK: - data to image to imageView
extension LibraryViewController {
    
    func getImage(_ id: Int = 1) {
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        //        {
        let (name, data) = db.getDataFromBlob(id)
        print("data: \n", data)
//        var image: UIImage?
//        if data != nil {
//            artist.vImageData = data
        
//        let image = UIImage(data: data)
//        print("image: \n", image)
            //            } else {
            //                image = UIImage(named: <defaultImageLikeNoAvailable>)
            //            }
            
            //            dispatch_async(dispatch_get_main_queue()) {
//        imageView.image = image
            //            }
//        }
        
        print(FM.storeImageToDocumentDirectory(data: data, fileName: name)!)
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
