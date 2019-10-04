import UIKit

class ListQuestViewController: UIViewController {
    
    @IBOutlet weak var questTextView: UITextView!
    var txtQuestion = QuestionsAtribute()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        questTextView.text = txtQuestion.question
    }

}
