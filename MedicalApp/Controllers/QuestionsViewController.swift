import UIKit

class QuestionsViewController: UIViewController {
    
    @IBOutlet weak var textViewQuestion: UITextView!
    var db = DB()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func sendQuestionButton(_ sender: UIButton) {
        db.insertInTable(inTable: "questions", question: textViewQuestion.text)
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
