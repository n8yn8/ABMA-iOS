//
//  YearViewController.swift
//  ABMA
//
//  Created by Nathan Condell on 1/28/17.
//  Copyright © 2017 Nathan Condell. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class YearViewController: NSViewController {
    
    @IBOutlet weak var activityIndicator: NSProgressIndicator!
    @IBOutlet var welcomeTextView: NSTextView!
    @IBOutlet var infoTextView: NSTextView!
    var containerController: ContainerController?
    var sponsorsViewController: SponsorsViewController?
    var surveyListViewController: SurveyListViewController?
    var mapsViewController: MapsViewController?
    
    var yearsModel = YearsModel.instance
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var yearsPopUpButton: NSPopUpButton!
    @IBOutlet weak var publishButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        activityIndicator.startAnimation(self)
        
        yearsModel.yearsRelay.asObservable()
        .subscribe(onNext: { [unowned self] years in
            self.activityIndicator.stopAnimation(self)
            self.updateYearOptions()
            
        })
        .disposed(by: disposeBag)
        
        yearsModel.selectedYearRelay.asObservable()
        .subscribe(onNext: { [unowned self] year in
            self.activityIndicator.stopAnimation(self)
            self.updateUi(selectedYear: year)

        })
        .disposed(by: disposeBag)
    }
    
    func setYears(years: [String]) {
        yearsPopUpButton.addItems(withTitles: years)
        yearSelected(yearsPopUpButton)
    }
    
    @IBAction func yearSelected(_ sender: NSPopUpButton) {
        if !yearsPopUpButton.itemArray.isEmpty {
            let selectedYear = yearsPopUpButton.itemTitle(at: yearsPopUpButton.indexOfSelectedItem)
            updateSeelctedYear(year: selectedYear)
        }
    }
    
    func updateSeelctedYear(year: String) {
        yearsModel.select(yearName: year)
    }
    
    func updateUi(selectedYear: BYear?) {
        
        if let year = selectedYear {
            yearsPopUpButton.selectItem(withTitle: "\(year.name)")
            
            if let welcome = year.welcome {
                welcomeTextView.string = welcome
            } else {
                welcomeTextView.string = ""
            }
            if let info = year.info {
                infoTextView.string = info
            } else {
                infoTextView.string = ""
            }
            publishButton.isEnabled = true
            if year.publishedAt == nil{
                publishButton.title = "Publish"
            } else {
                publishButton.title = "Update"
            }
            if let sponsors = year.sponsors {
                yearsModel.sponsorsRelay.accept(sponsors)
            } else {
                DbManager.sharedInstance.getSponsors(parentId: year.objectId!) { (response, error) in
                    year.sponsors = response
                    let sponsors = response ?? []
                    self.yearsModel.sponsorsRelay.accept(sponsors)
                }
            }
            
            sponsorsViewController?.yearParentId = year.objectId
        } else {
            welcomeTextView.string = ""
            infoTextView.string = ""
            publishButton.isEnabled = false
            publishButton.title = "Publish"
        }
        
    }
    
    func updateYearOptions() {
        var yearList = [String]()
        for year in yearsModel.yearsRelay.value {
            yearList.append("\(year.name)")
        }
        setYears(years: yearList)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let dvc = segue.destinationController as? NewYearsViewController {
            dvc.year = 2017
        } else if let dvc = segue.destinationController as? ContainerController {
            containerController = dvc
            containerController?.delegate = self
        } else if let dvc = segue.destinationController as? SponsorsViewController {
            sponsorsViewController = dvc
        } else if let dvc = segue.destinationController as? PushViewController {
            dvc.delegate = self
        } else if let dvc = segue.destinationController as? SurveyListViewController {
            surveyListViewController = dvc
        } else if let dvc = segue.destinationController as? MapsViewController {
            mapsViewController = dvc
        }
    }
    
    @IBAction func saveWelcome(_ sender: Any) {
        activityIndicator.startAnimation(self)
        let welcome = welcomeTextView.string
        let info = infoTextView.string
        yearsModel.update(welcome: welcome, info: info)
    }
    
    func updateYear(callback: (() -> Void)?) {
        activityIndicator.startAnimation(self)
        DbManager.sharedInstance.update(year: yearsModel.selectedYearRelay.value!) { (saved, error) in
            self.activityIndicator.stopAnimation(self)
            saved?.doSort()
            self.yearsModel.selectedYearRelay.accept(saved)
            if let call = callback {
                call()
            }
        }
    }
    
    @IBAction func publish(_ sender: Any) {
        updateYear(callback: nil)
    }
}

extension YearViewController: ContainerControllerDelegate {
    func updateEvents(list: [BEvent]) {
        yearsModel.selectedYearRelay.value?.events = list
    }
}

extension YearViewController: PushViewControllerDelegate {
    func sendUpdate(message: String) {
        if yearsModel.selectedYearRelay.value?.publishedAt == nil {
            yearsModel.selectedYearRelay.value?.publishedAt = Date()
            updateYear(callback: { 
                DbManager.sharedInstance.pushUpdate(message: message)
            })
        } else {
            updateYear(callback: {
                DbManager.sharedInstance.pushUpdate(message: message)
            })
        }
    }
}
