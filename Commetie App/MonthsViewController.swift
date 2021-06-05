//
//  MonthsViewController.swift
//  Commetie App
//
//  Created by Ahsan Iqbal on Thursday03/06/2021.
//

import UIKit
import RealmSwift

class MonthsViewController: UIViewController {

    @IBOutlet weak var monthsCV: UICollectionView!
    
    var monthsNameList = ["June 2021","July 2021","August 2021","September 2021","October 2021","November 2021", "December 2021", "Jaunary 2022","Febuaray 2022","March 2022","April 2022"]
    var candidateNameList : [String:Any] = ["Ahsan": "100",
                                            "Bilal": "100",
                                            "Imran": "100",
                                            "Mansoor": "100",
                                            "Mudassir": "100",
                                            "Touseef": "100",
                                            "Talal": "100",
                                            "Waqar": "100",
                                            "Asad": "100",
                                            "Mohsin": "100",
                                            "Mani": "100",
                                            "Shakoor": "100"]

    var candList = List<Candidate>()
    var monthsList : Results<MonthsModel>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        monthsCV.delegate = self
        monthsCV.dataSource = self
        monthsCV.register(UINib(nibName: "MonthsCVCell", bundle: nil), forCellWithReuseIdentifier: "MonthsCVCell")

        doTheRealmThing()
        
        if !AppFunctions.getIsFirstLogin(forKey: isFirstLogin) {
            Logs.value(message: "::FALSE VAL::")
            for months in monthsNameList {
                let month = MonthsModel()
                let candsArray = List<Candidate>()

                for candis in candidateNameList {
                    let cand = Candidate()
                    cand.cID = Candidate.incrementaIDs()
                    cand.cName = candis.key
                    cand.paymentAmount = candis.value as! String
                    cand.paymentMonth = months
                    create_Candidate(candidate: cand)
                    candsArray.append(cand)
                }
                
                month.mID = MonthsModel.incrementaIDs()
                month.mName = months
                month.candidates = candsArray
                create_MonthsList(months: month)
            }
        }
        
    }
    
    func doTheRealmThing(){
        let realm = try! Realm()
        monthsList = realm.objects(MonthsModel.self)
    }
    
    func create_Candidate(candidate: Candidate) {
        let realm = try! Realm()
        try! realm.write {
            realm.create(Candidate.self, value: candidate, update: .all)
        }
    }
    func create_MonthsList(months: MonthsModel) {
        let realm = try! Realm()
        try! realm.write {
            AppFunctions.setIsFirstLogin(val: true)
            realm.create(MonthsModel.self, value: months, update: .all)
        }
    }
    
    

}
extension MonthsViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        monthsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthsCVCell", for: indexPath as IndexPath) as! MonthsCVCell
        cell.monthsLbl.text = monthsList[indexPath.row].mName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
            transition.type = CATransitionType.fade
            vc?.paymentMonth = monthsList[indexPath.item].mName
            self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
