

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = "";
    @objc dynamic var check: Bool = false;
    @objc dynamic var dateCreated: Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
