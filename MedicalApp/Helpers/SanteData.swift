import Foundation
import SQLite3

struct DB: ParserProtocol {
    
    static var db: OpaquePointer? = nil
        
    mutating func openDB() -> String {
        guard let path = Bundle.main.path(forResource: "Sante", ofType: "db") else {
            return "FIG_VAM"
        }
        
        guard sqlite3_open(path, &DB.db) == SQLITE_OK else {
            print("error open DB \(Error.self)")
            return "error open DB on path =  \(path)"}
        
        return "open DataBase done \(path)"
    }
    
    func getHTML(_ id: Int) -> String {
        
        var values = String()
        var str: OpaquePointer? = nil
        let query = "SELECT html FROM slides WHERE id = \(id)"
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
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
        
        return values
    }
    
    //TODO: - make with Model
    func clearTxt(txt: inout String, id: Int, name: String, nameTopic: String)
        -> [(idSlide: Int , name: String, word: String, cnt: Int, listWord: String, nameTopic: String)]{
        
        let errorChar: Set<Character> = ["'"]
        txt.removeAll(where: { errorChar.contains($0) })
        
        // for french "’" don't remove
        let arrayTxt = txt.components(separatedBy:
            [",", " ", "!",".","?","\n","\r","(",")","*","_",
             "0","1","2","3","4","5","6","7","8","9", "+", "!",
             "=", ";", ":", "<", "&", "\"", "\\", "@", "[", "]",
             "{", "}", "«", "»", "-", "/", "·", "|", "#", " ",
             "“"])
            .filter({$0.count > 1})
        print("arrayTxt.count = ", arrayTxt.count)
        //        print(arrayTxt.sorted())
        
        var setTxt = Set<String>()
        arrayTxt.forEach{ setTxt.insert($0.lowercased()) }
        print("setTxt.count = ", setTxt.count)
        //        print(setTxt.sorted())
        
        // формируем массив кортежей для наполнения таблицы
        // сделать через модель
            var arrDict = [(idSlide: Int,
                            name: String,
                            word: String,
                            cnt: Int,
                            listWord: String,
                            nameTopic: String)]()
        
        setTxt.sorted().forEach{
            let word = $0
            
            var cnt = 1
            var listWord = word
            arrayTxt.forEach{
                if $0.contains(word) {
                    cnt += 1
                    listWord += " " + word
                }
            }
            
            let rec: (idSlide: Int , name: String, word: String, cnt: Int, listWord: String, nameTopic: String) = (id, name, $0, cnt, listWord, nameTopic)
            
            arrDict.append(rec)
        }
        
        print("arrDict.count = ", arrDict.count)
        
        // sort Dict on cnt, more to less
        arrDict = arrDict.sorted(by: { $0.3 > $1.3 } )
//        arrDict.forEach({print($0)})
        
        return arrDict
    }
}

// MARK: - delete records from table
extension DB {
    
    func deleteRecords(inTable:String, id: Int){
        
        var del: OpaquePointer? = nil
        let query = "DELETE FROM \(inTable) WHERE id_slide = '\(id)'"
        
        guard sqlite3_prepare_v2(DB.db, query, -1, &del, nil)==SQLITE_OK else {
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error prepare delete: \(errmsg)")
            return
        }
        
        guard sqlite3_step(del) == SQLITE_DONE  else {
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error delete: \(errmsg)")
            return
        }
        
        sqlite3_finalize(del)
        print(query)
    }
}

//MARK: - close DB
extension DB {
    func closeDB() {
        sqlite3_close(DB.db)
    }
}

// MARK: - CREATE VIRTUAL TABLE "slides_search"
extension DB {
    
    func insertSlideSearch(inTable: String,
                         arrDict: [(
        idSlide: Int,
        name: String,
        word: String,
        cnt: Int,
        listWord: String,
        nameTopic: String
        )]) {
        
        var insert: OpaquePointer? = nil
        
        arrDict.forEach{
            
            let insertString = """
            INSERT INTO \(inTable) (id_slide, name, word, cnt, list_word, name_topic) VALUES ('\($0.idSlide)', '\($0.name)', '\($0.word)', '\($0.cnt)', '\($0.listWord)', '\($0.nameTopic)');
            """
            guard sqlite3_prepare_v2(DB.db, insertString, -1, &insert, nil) == SQLITE_OK,
                sqlite3_step(insert) == SQLITE_DONE
                else {
                    let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
                    print("error preparing insert: \(errmsg): for insert: ", insertString)
                    return
            }
            
        }
        
        sqlite3_finalize(insert)
    }
}

// MARK: - get dict for insert in table slides_search
/* var arrDict = [(
    idSlide: Int,
    name: String,
    word: String,
    cnt: Int,
    listWord: String
    nameTopic: String )]() */
extension DB {
    
    func createDict(_ id : Int) {
        
        var html = String()
        var nameTopic = String()
        var name = String()
        var str: OpaquePointer? = nil
        
        let query = """
        SELECT slides.name, html, slides_topic.name as name_topic
        FROM slides JOIN slides_topic
        on slides.id_topic = slides_topic.id
        WHERE slides.id = \(id)
        """
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            //            print("query \(query) is DONE")
        } else {
            print("query \(query) is uncorrect")
        }
        
        if sqlite3_step(str) == SQLITE_ROW {
            name = String(cString: sqlite3_column_text(str, 0))
            html = String(cString: sqlite3_column_text(str, 1))
            nameTopic = String(cString: sqlite3_column_text(str, 2))
        } else {
            print("error get HTML from DataBase")
        }
        
        sqlite3_finalize(str)
        
        // parser html
        var txt = parse(htmlString: html)
        
        let arrDict = clearTxt(txt: &txt, id: id, name: name, nameTopic: nameTopic)
        print("let arrDict = clearTxt(txt: &txt, id: id, name: name, nameTopic: nameTopic, arrDict.count = ", arrDict.count)
        
        deleteRecords(inTable: "slides_search", id: id)
        printWordCount(id)
        
        insertSlideSearch(inTable: "slides_search",
                        arrDict: arrDict)
    
        return
    }
}

// MARK: - insert In Table question
extension DB {
    func insertInTable(inTable: String, question: String) {
        
        var insert: OpaquePointer? = nil
        let insertString = """
        INSERT INTO \(inTable) (question) VALUES ('\(question)');
        """
        guard sqlite3_prepare_v2(DB.db, insertString, -1, &insert, nil) == SQLITE_OK,
            sqlite3_step(insert) == SQLITE_DONE
            else {
                let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
                print("error preparing insert: \(errmsg)")
                return
        }
        
        print("insert in table done")
        print(insertString)
        sqlite3_finalize(insert)
    }
}

// MARK: - get records from table slides_search on request
extension DB {
        
    func searchSlides (_ req: String) -> [Slide] {
        
        var slides: [Slide] = []
        
        var str: OpaquePointer? = nil
        let query = req
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("query \(query) is DONE")
        } else {
            print("query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
        }
        
        while (sqlite3_step(str)) == SQLITE_ROW {
            
            let idSlide = Int(String(cString: sqlite3_column_text(str, 0))) ?? 0
            let nameTopic = String(cString: sqlite3_column_text(str, 1))
            let name = String(cString: sqlite3_column_text(str, 2))
            let count = String(cString: sqlite3_column_text(str, 3))
            let sum_count_word = String(cString: sqlite3_column_text(str, 4))
            let list = String(cString: sqlite3_column_text(str, 5))
            print(nameTopic + ": id=\(idSlide), " + name + "(" + count + ", " + sum_count_word + "): " + list)
    
            let slide = Slide(id: idSlide, name: name, nameTopic: nameTopic,
                              search: "(" + count + ", " + sum_count_word + "): " + list)
            slides.append(slide)
        }
        
        return slides
    }
    
    // MARK: - split search query on space
    func splittingSearch(_ query: String) -> [String] {
        
        var txt = query
//        let errorChar: Set<Character> = ["'"]
        let errorChar: Set<Character> = [
            "'", ",", "!", ".","?","\n","\r","(",")", "_",
            "0","1","2","3","4","5","6","7","8","9", "+", "!",
            "=", ";", ":", "<", "&", "\"", "\\", "@", "[", "]",
            "{", "}", "«", "»", "-", "/", "·", "|", "#", "“",
            "$", "^", "%"]

        txt.removeAll(where: { errorChar.contains($0) })
        
        // for french "’" don't remove
        let arrayTxt = txt.components(separatedBy: " ")
        
        print("arrayTxt.count = ", arrayTxt.count)
        print(arrayTxt)
        
        var setTxt = Set<String>()
        arrayTxt.forEach{ setTxt.insert($0.lowercased()) }
        print("setTxt.count = ", setTxt.count)
        print(setTxt)
        
        return arrayTxt
    }
    
    // MARK: - prepare sql query for search with multi words
    func prepareSearch(_ arrWord: [String]) -> String {
        
        var searchgSql = """
        SELECT id_slide, name_topic, name, count(), sum(count_word) as sum_count_word,
        GROUP_CONCAT(listWord || "(" || count_word || ")", "; ") as list from
        (
             select id_slide, name_topic, name, GROUP_CONCAT(word || "(" || cnt || ")", "; ") listWord, count(word) as count_word
             FROM
             (
                select * FROM slides_search WHERE list_word MATCH '\(arrWord[0])' ORDER BY rank
             )
             GROUP BY name
        """
        
        for index in 1..<arrWord.count{
            searchgSql += """
            \nUNION
            select id_slide, name_topic, name, GROUP_CONCAT(word || "(" || cnt || ")", "; ") listWord, count(word) as count_word
            FROM
            (
                select * FROM slides_search WHERE list_word MATCH '\(arrWord[index])' ORDER BY rank
            )
            GROUP BY name
            """
        }
        
        searchgSql += """
        )
        GROUP BY name HAVING count() = \(arrWord.count);
        """
        
        return searchgSql
    }
    
}

// MARK: get data image and video from blob
extension DB {
    
    // TODO: - use Model : (String, Data)
    func getDataFromBlob(_ id: Int = 1) -> (String, Data) {
        
        var str: OpaquePointer? = nil
        var blob = Data()
        var name = String()
        let query = "SELECT name, image from slides_image WHERE id = \(id);"
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("prepare query \(query) is DONE")
        } else {
            print("prepare query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
        }
        
        if sqlite3_step(str) == SQLITE_ROW {
            
            // get name file image
            name = String(cString: sqlite3_column_text(str, 0))
            
            if let dataBlob = sqlite3_column_blob(str, 1){
                let dataBlobLength = sqlite3_column_bytes(str, 1)
                blob = Data(bytes: dataBlob, count: Int(dataBlobLength))
                print("dataBlob: \n", dataBlob)
                print("dataBlobLength = ", dataBlobLength)
            }            
        } else {
            print("query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error run query: \(errmsg)")
        }
        
        return (name, blob)
    }
}

// MARK: get info about image or video for slide id
// SELECT id, name FROM slides_image where id_slide = 1;
extension DB {
    
    // TODO: - use Model
    func getInfoAboutDocForSlide(_ id: Int) -> [DocSlide] {
        
        var str: OpaquePointer? = nil
        var info = [DocSlide]()
        let query = "SELECT id, name from slides_image WHERE id_slide = \(id);"
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("prepare query \(query) is DONE")
        } else {
            print("prepare query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
        }
                
        while (sqlite3_step(str)) == SQLITE_ROW {
            let idDoc = Int(sqlite3_column_int(str, 0))
            let name = String(cString: sqlite3_column_text(str, 1))
            let docSlide = DocSlide(idSlide: id, idDoc: idDoc, nameDoc: name)
            info.append(docSlide)
        }
        
        return info
    }
}

// MARK: - get count word in table slides_search on id_slide
// SELECT count(word) as word_count FROM slides_search  WHERE id_slide = "7";
extension DB {
    
    func printWordCount(_ id: Int) {
        
        var str: OpaquePointer? = nil
        
        let query = "SELECT count(word) as word_count FROM slides_search  WHERE id_slide = '\(id)';"
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
        } else {
            print("query \(query) is uncorrect")
        }
        
        if sqlite3_step(str) == SQLITE_ROW {
            print("word_count with id = \(id): ", String(cString: sqlite3_column_text(str, 0)))
        } else {
            print("error get word_count with id = \(id)")
        }
        
        sqlite3_finalize(str)
    }
    
}

// TODO: - delete extension!
extension DB {
    
    func searchSlides (_ req: String) -> [String] {
        
        var values = [String]()
        var str: OpaquePointer? = nil
        let query = req
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("query \(query) is DONE")
        } else {
            print("query \(query) is uncorrect")
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing query: \(errmsg)")
        }
        
        while (sqlite3_step(str)) == SQLITE_ROW {
            
            let idSlide = String(cString: sqlite3_column_text(str, 0))
            let nameTopic = String(cString: sqlite3_column_text(str, 1))
            let name = String(cString: sqlite3_column_text(str, 2))
            let count = String(cString: sqlite3_column_text(str, 3))
            let sum_count_word = String(cString: sqlite3_column_text(str, 4))
            let list = String(cString: sqlite3_column_text(str, 5))
            print(nameTopic + ": id=" + idSlide + ", " + name + "(" + count + ", " + sum_count_word + "): " + list)
            values.append(nameTopic + ": id=" + idSlide + ", " + name + "(" + count + ", " + sum_count_word + "): " + list)
        }
        
        return values
    }
    
    private func updateSlideWord(inTable: String, txt: String, id: Int) {
        
        var update: OpaquePointer? = nil
                
        let updateString = """
        UPDATE \(inTable) SET txt = '\(txt)' WHERE iD = \(id)
        """
        
        guard sqlite3_prepare_v2(DB.db, updateString, -1, &update, nil) == SQLITE_OK,
            sqlite3_step(update) == SQLITE_DONE else {
                let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
                print("error preparing update: \(errmsg)")
                return
        }
        print("update whith guard done")
        
        sqlite3_finalize(update)
    }
    
    func insertSlideWord(inTable: String,
                         arrDict: [(
        idSlide: Int,
        word: String,
        cnt: Int,
        listWord: String)]) {
        
        var insert: OpaquePointer? = nil
        
        arrDict.forEach{
            
            let insertString = """
            INSERT INTO \(inTable) (id_slide, word, cnt, list_word) VALUES ('\($0.idSlide)', '\($0.word)', '\($0.cnt)', '\($0.listWord)');
            """
            guard sqlite3_prepare_v2(DB.db, insertString, -1, &insert, nil) == SQLITE_OK,
                sqlite3_step(insert) == SQLITE_DONE
                else {
                    let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
                    print("error preparing insert: \(errmsg): for insert: ", insertString)
                    return
            }
        }
        
        sqlite3_finalize(insert)
    }
    
    private func updateTXT(inTable: String, txt: String, id: Int) {
        
        var update: OpaquePointer? = nil
        
        let updateString = """
        UPDATE \(inTable) SET txt = '\(txt)' WHERE iD = \(id)
        """
        
        guard sqlite3_prepare_v2(DB.db, updateString, -1, &update, nil) == SQLITE_OK,
            sqlite3_step(update) == SQLITE_DONE else {
                let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
                print("error preparing update: \(errmsg)")
                return
        }
        sqlite3_finalize(update)
    }
}
