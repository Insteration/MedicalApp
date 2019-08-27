import UIKit

class QuestionsViewController: UIViewController {
    
    @IBOutlet weak var questionsView: UIView!
    @IBOutlet weak var questionsTextField: UITextView!
    
    var parseSoap = ParserSoup()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        questionsView.layer.cornerRadius = 25
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        moveIn()
        
        
//        do {
            let answer = parseSoap.parse(pathFile: "file:///Users/artem/Desktop/courses/Swift/step/team%20git/MedicalApp/MedicalApp/Resources/slide_example/Back.html")
            questionsTextField.text = answer
            print("ANSWER: \(answer)")
//        } catch let error {
//            print("Parse wrong: ", error)
//        }
    }
    
    
    @IBAction func sendQuestionsActionButton(_ sender: UIButton) {
        
        //        self.view.removeFromSuperview()
        moveOut()
    }
    
    
    
    func moveIn() {
        
        self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
        self.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.24) {
            self.view.alpha = 1.0
        }
    }
    
    func moveOut() {
        
        UIView.animate(withDuration: 0.24, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
            self.view.alpha = 0.0
        }) { _ in
            self.view.removeFromSuperview()
        }
        
    }
}
