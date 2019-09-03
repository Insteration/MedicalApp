import UIKit

class QuestionsViewController: UIViewController, DB {
    
    @IBOutlet weak var questionsView: UIView!
    @IBOutlet weak var questionsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionsView.layer.cornerRadius = 25
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        moveIn()
    }
    
    @IBAction func sendQuestionsActionButton(_ sender: UIButton) {
                moveOut()
        
        insertInTable(inTable: "questions", question: questionsTextView.text)
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
