import UIKit

class QuestionsViewController: UIViewController {
    
    @IBOutlet weak var questionsView: UIView!
    @IBOutlet weak var questionsTextView: UITextView!
    
    var db = DB()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionsView.layer.cornerRadius = 25
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        moveIn()
    }
    
    @IBAction func sendQuestionsActionButton(_ sender: UIButton) {
        moveOut()
        print(db.openDB())
        db.insertInTable(inTable: "questions", question: questionsTextView.text)
        db.closeDB()
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
