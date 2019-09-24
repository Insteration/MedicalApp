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
        
        return engine.selectFromTableEngine(nameTable: "questions").count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = engine.selectFromTableEngine(nameTable: "questions")[indexPath.row]
        
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

             print("Questions =  \(engine.selectFromTableEngine(nameTable: "questions")[path.row])")
                        
            vc.txt = "09876"
//            vc.questTextView.text = engine.selectFromTableEngine(nameTable: "questions")[path.row]
            
//            vc.questionTextView.text =              engine.selectFromTableEngine(nameTable: "questions")[path.row]

            
//            if let path = tableView.indexPathForSelectedRow {
//               let vc = segue.destination as ListQuestionsViewController
//
//                listQuestVC.questTextView.text = engine.selectFromTableEngine(nameTable: "questions")[path.row]
//
//            }
            
        }
        
    }
}
