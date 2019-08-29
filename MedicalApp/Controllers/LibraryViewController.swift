
import UIKit

class LibraryViewController: UIViewController, ParserProtocol {
    
    @IBOutlet weak var libraryTextView: UITextView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let answer = parse(pathFile: "file:///Users/artem/Desktop/courses/Swift/step/team%20git/MedicalApp/MedicalApp/Resources/slide_example/Back.html")
        
        let answer1 = parse(pathFile: "file:///Users/artem/Desktop/courses/Swift/step/team%20git/MedicalApp/MedicalApp/Resources/slide_example/Back.html", cssSelector: "div")
        
        libraryTextView.text = answer1
    }
}
