import UIKit

class QuestionsViewController: UIViewController {
    
    @IBOutlet weak var questionsView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionsView.layer.cornerRadius = 25
    }
    
    
    @IBAction func sendQuestionsActionButton(_ sender: UIButton) {
        
        self.view.removeFromSuperview()
    }
    
}
