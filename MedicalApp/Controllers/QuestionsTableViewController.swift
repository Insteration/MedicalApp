//
import UIKit

class QuestionsTableViewController: UITableViewController {
    
    var engine = Engine()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return engine.selectQuestionFromTable(nameTable: "questions").count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = engine.selectQuestionFromTable(nameTable: "questions")[indexPath.row]
        

        cell.detailTextLabel?.text = engine.selectDateFromTable(nameTable: "questions")[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "QuestVC" {
            
            guard let path = tableView.indexPathForSelectedRow else {
                print("error get path from table")
                return
            }
            
            let vc = segue.destination as! ListQuestViewController
            vc.txtQuestion.question = engine.selectQuestionFromTable(nameTable: "questions")[path.row]
        }
        
    }
}
