
import UIKit
import WebKit

class LibraryViewController: UIViewController {
    
    let indCell = "IndCell"
    let topics = Topics().listTopic
    
    @IBOutlet weak var libCollectV: UICollectionView!
    
    @IBAction func btBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(topics)
        libCollectV.dataSource = self
//        libCollectV.delegate = self

    }
}

extension LibraryViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: indCell, for: indexPath)
        
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: indCell, for: indexPath) as? LibCollectionVCell
        
        itemCell!.topic = topics[indexPath.row]
        
        return itemCell!
    }
    
}

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
        
//        let id = 5
//
//        getImage(1)
//        getImage(2)
//        getImage(3)
//        getImage(4)
//        getImage(5)
//
//        getImage(id)
//
//        // TODO: - make with thread only read DB
//        let html = db.getHTML(id)
//        let urlForSlide = FM.getUrlForSlide(id)
//        print("urlForSlide = ", urlForSlide)
//
//        libraryWebView.loadHTMLString(html, baseURL: urlForSlide)


// MARK: - data to image to imageView
//extension LibraryViewController {
    
//    func getImage(_ id: Int = 1) {
//        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
//        //        {
//        let (name, data) = db.getDataFromBlob(id)
//        print("data: \n", data)
////        var image: UIImage?
////        if data != nil {
////            artist.vImageData = data
//
////        let image = UIImage(data: data)
////        print("image: \n", image)
//            //            } else {
//            //                image = UIImage(named: <defaultImageLikeNoAvailable>)
//            //            }
//
//            //            dispatch_async(dispatch_get_main_queue()) {
////        imageView.image = image
//            //            }
////        }
//
//        FM.createDir(id)
//        print(FM.storeImageToDocumentDirectory(data: data, fileName: "\(id)/" + name) ?? "fileName: \(id)/" + name)
//    }
//}
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
