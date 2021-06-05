//
//  CandidateModel.swift
//  Commetie App
//
//  Created by Ahsan Iqbal on Thursday03/06/2021.
//

import RxRealm
import RealmSwift

class MonthsModel: Object {
    @objc dynamic var mID : Int = 0
    @objc dynamic var mName : String = ""
    @objc dynamic var bankAmount : Int = 0
    @objc dynamic var cashAmount : Int = 0
    @objc dynamic var totalCollection : Int = 0
    var candidates = List<Candidate>()


    override class func primaryKey() -> String {
        return "mID"
    }
    
    //Increment ID
    static func incrementaIDs() -> Int{
        let realm = try! Realm()
        return (realm.objects(MonthsModel.self).max(ofProperty: "mID") as Int? ?? 0) + 1
    }
}


class Candidate: Object {
    @objc dynamic var cID : Int = 0
    @objc dynamic var cName : String = ""
    @objc dynamic var cPaymentMethod : String = ""
    @objc dynamic var paymentDate : String = ""
    @objc dynamic var paymentAmount : String = ""
    @objc dynamic var paymentMonth: String = ""


    override class func primaryKey() -> String {
        return "cID"
    }
    
    //Increment ID
    static func incrementaIDs() -> Int{
        let realm = try! Realm()
        return (realm.objects(Candidate.self).max(ofProperty: "cID") as Int? ?? 0) + 1
    }
}

