import Foundation

struct UserProfile {
    var users = ["admin": "admin"]
    
    func validate(_ email: String, _ password: String) -> Bool{
        for login in users {
            if login.key == email && login.value == password {
                print("ohh la la")
                return true
            }else {
                print("login or password incorrect")
            }
        }
        return false
    }
}
