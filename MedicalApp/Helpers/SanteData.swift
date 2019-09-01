import Foundation
import SQLite3

protocol DB {
    func getHTML(_ id: Int) -> String
    func insertInTable(inTable: String, name: String)
}

extension DB {
    
    func getHTML(_ id: Int = 3) -> String {
        //Choise DataBase
        guard let path = Bundle.main.path(forResource: "Sante", ofType: "db") else { return "FIG_VAM" }
  
        var db: OpaquePointer? = nil
        guard sqlite3_open(path, &db) == SQLITE_OK else {
            print("error creating DB \(Error.self)")
            return "" }
        print("create DataBase done \(path)")
        
        //----
        var values = String()
        var str: OpaquePointer? = nil
        let query = "SELECT html FROM slides WHERE id = \(id)"
        
        if sqlite3_prepare_v2(db, query, -1, &str, nil) == SQLITE_OK {
            print("query \(query) is DONE")
        } else {
            print("query \(query) is uncorrect")
        }
        
        if sqlite3_step(str) == SQLITE_ROW {
            let html = String(cString: sqlite3_column_text(str, 0))
            values = html
        } else {
            print("error get HTML from DataBase")
        }
        
        sqlite3_close(db)
        return values
    }
    
    func updateTXT(){
    }
    
    func insertInTable(inTable: String, name: String) {
        
        guard let path = Bundle.main.path(forResource: "Sante", ofType: "db") else { return }
        
        var db: OpaquePointer? = nil
        guard sqlite3_open(path, &db) == SQLITE_OK else {
            print("error creating DB \(Error.self)")
            return
        }
        print("create DataBase done \(path)")
        
        
        
        var insert: OpaquePointer? = nil
        let insertString = """
        INSERT INTO \(inTable) (name) VALUES ('\(name)');
        """
        guard sqlite3_prepare_v2(db, insertString, -1, &insert, nil) == SQLITE_OK,
            sqlite3_step(insert) == SQLITE_DONE else {
                print("error insert in table")
                return
        }
        print("insert in table done")
        sqlite3_finalize(insert)
        
    }
    
    
}

