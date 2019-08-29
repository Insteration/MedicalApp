
import UIKit

class LibraryViewController: UIViewController {
    
    @IBOutlet weak var libraryTextView: UITextView!
    
    var parseSoap = ParserSoup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let answer = parseSoap.parse(pathFile: "file:///Users/artem/Desktop/courses/Swift/step/team%20git/MedicalApp/MedicalApp/Resources/slide_example/Back.html")
        
        libraryTextView.text = answer
        print("ANSWER: \(answer)")
    }
}
