
import UIKit

class testData {
    var id = 0
    var username = ""
    var email = ""
    var name = ""
    var addresArray = [String]()
    var companyArray = [String]()
    var addressPoints = ["city","street","suite","zipcode"]
    var companyPoints = ["bs","catch phrase","name"]
    var phone = ""
    
    func printData() {
        print("id: \(self.id)")
        print("username: \(self.username)")
        print("email: \(self.email)")
        print("name: \(self.name)")
        print("phone: \(self.phone)")
        print("\naddress:")
        for a in addresArray {
            print(a + ", ")
        }
        print("\ncompany:")
        for c in companyArray {
            print(c + ", ")
        }

    }
}
