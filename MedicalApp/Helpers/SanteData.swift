import Foundation
import SQLite3

struct DB :  ParserProtocol {
    
    var db: OpaquePointer? = nil
    
    mutating func openDB() -> String {
        guard let path = Bundle.main.path(forResource: "Sante", ofType: "db") else {
            return "FIG_VAM"
        }
        
        guard sqlite3_open(path, &db) == SQLITE_OK else {
            print("error creating DB \(Error.self)")
            return "error open DB on path =  \(path)"}
        print("create DataBase done \(path)")
        
        return "create DataBase done \(path)"
    }
    
    func getHTML(_ id: Int = 3) -> String {
        
        var values = String()
        var str: OpaquePointer? = nil
        let query = "SELECT html FROM slides WHERE id = \(id)"
        
        if sqlite3_prepare_v2(openDataBase(), query, -1, &str, nil) == SQLITE_OK {
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
        
        //        sqlite3_close(db)
        return values
    }
    
    func insertInTable(inTable: String, question: String) {
        
        var insert: OpaquePointer? = nil
        let insertString = """
        INSERT INTO \(inTable) (question) VALUES ('\(question)');
        """
        guard sqlite3_prepare_v2(openDataBase(), insertString, -1, &insert, nil) == SQLITE_OK,
            sqlite3_step(insert) == SQLITE_DONE
            else {
                print("error insert in table")
                return
        }
        
//        sqlite3_close(openDataBase())
        print("insert in table done")
        print(insertString)
        sqlite3_finalize(insert)
    }
    
    
    func updateTXT(){
        
        var html = String()
        var str: OpaquePointer? = nil
        var id = 3
        
        let query = "SELECT html FROM slides WHERE id = \(id)"
        
        if sqlite3_prepare_v2(db, query, -1, &str, nil) == SQLITE_OK {
            print("query \(query) is DONE")
        } else {
            print("query \(query) is uncorrect")
        }
        
        if sqlite3_step(str) == SQLITE_ROW {
            html = String(cString: sqlite3_column_text(str, 0))
        } else {
            print("error get HTML from DataBase")
        }
        
        // parser html and update field txt
        let txt = parse(htmlString: html)
        
        //        updateTXT(db: db!, inTable: "slides", txt: txt, id: id)
        updateTXT(inTable: "slides", txt: txt, id: id)
        
        
        
        // get TXT from BD
        let queryTXT = "SELECT txt FROM slides WHERE id = 3"
        var txtSlides = ""
        
        if sqlite3_prepare_v2(db, queryTXT, -1, &str, nil) == SQLITE_OK {
            print("queryTXT \(query) is DONE")
        } else {
            print("queryTXT \(query) is uncorrect")
        }
        
        if sqlite3_step(str) == SQLITE_ROW {
            txtSlides = String(cString: sqlite3_column_text(str, 0))
        } else {
            print("error get TXT from DataBase")
        }
        
        print("txtSlides = ", txtSlides)
    }
    
    private func updateTXT(inTable: String, txt: String, id: Int) {
        
        var update: OpaquePointer? = nil
        
        print("txt = ", txt, "\nid = ", id)
        
        let updateString = """
        UPDATE \(inTable) SET txt = '\(txt)' WHERE iD = \(id)
        """
        
        //        let updateString = "UPDATE slides SET txt = strftime('%Y-%m-%d %H:%M:%S', datetime('now','localtime')) WHERE iD = 3"
        
        print("updateString = ",updateString)
        
        guard sqlite3_prepare_v2(db, updateString, -1, &update, nil) == SQLITE_OK,
            sqlite3_step(update) == SQLITE_DONE else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing update: \(errmsg)")
                print("error run update")
                return
        }
        print("update whith guard done")
        
        sqlite3_finalize(update)
    }
    
    func closeDB() {
        sqlite3_close(db)
    }
    
    
}

