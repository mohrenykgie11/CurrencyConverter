//
//  ConverterVC.swift
//  CurrencyConverter
//
//  Created by Morenikeji on 2/26/21.
//  Copyright © 2020 Morenikeji. All rights reserved.
//

import UIKit
import Charts
import SVProgressHUD
import RealmSwift
import SwiftyJSON

class ConverterVC: UIViewController, ChartViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: - IBOutlets
    @IBOutlet weak var screenHeader: UILabel!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var baseCurrency: UILabel!
    @IBOutlet weak var convertedCurrency: UILabel!
    @IBOutlet weak var convertedRate: UILabel!
    @IBOutlet weak var baseCurrencydropDown: UILabel!
    @IBOutlet weak var convertedCurrencydropDown: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var getAlertLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var dropDown: UIView!
    @IBOutlet weak var dropDown2: UIView!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var picker1: UIPickerView!
    @IBOutlet weak var picker2: UIPickerView!
    @IBOutlet var mainView: UIView!
    
    //chart variables
    let days = ["Past 30 days", "Past 90 days"]
    var dateList = ["01 Jun", "07 Jun", "15 Jun", "23 Jun", "30 Jun"]
    var rateList = [3.113, 4.333, 3.103, 3.222, 4.231]
    
    let baseSymbol = Constant.BASE_SYMBOL
    var currencyList = [Currency]()
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupInfo()
        setHeaderColor()
        
        //set base currency and symbol to Euro
        baseCurrency.text = baseSymbol
        baseCurrencydropDown.text = getFlag(from: "EU") + "  \(baseSymbol)"

        //gesture on converted currency dropdown
        dropDown.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        dropDown2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap2)))
        
        //check if database is empty, if yes call api endpoint else load saved data
        let realmResults = realm.objects(CurrencyObject.self)
        //loop through your realm result
        if realmResults.count > 0 {
            for eachResult in realmResults {
                currencyList.append(Currency(symbol: eachResult.symbol))
            }
            
            //set first currency as default
            let firstCurrency = self.currencyList[0].symbol
            getSymbolNFlag(label: convertedCurrency, dropDownLabel: convertedCurrencydropDown, symbol: firstCurrency)
            
        } else {
            //call api
            getLatestCurrency()
        }
        
    }

    @IBAction func convertButtonClicked(_ sender: UIButton) {
        let baseSymbol = baseCurrency.text ?? ""
        let convertedSymbol = convertedCurrency.text ?? ""
        
        if baseSymbol == convertedSymbol {
            //do nothing
        } else {
            //call endpoint to convert
            convertCurrency(baseStr: baseSymbol, symbolStr: convertedSymbol)
        }
    }
    
    //show picker view for selecting currency
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        picker1.isHidden = false
    }
    
    @objc func handleTap2(_ sender: UITapGestureRecognizer) {
        picker2.isHidden = false
    }
   
    //sign up
    @objc func signupTapped(sender: UIButton) {
        
    }
    
    //harmburger menu
    @objc func menuPressed(sender: UIButton) {
        
    }
    
    //setup collection view
    func setupInfo() {
        collectionView.register(UINib(nibName: "PastDaysCell", bundle: nil), forCellWithReuseIdentifier: "PastDaysCell")

        collectionView.reloadData()
    }
    
    //get currency api call
    func getLatestCurrency() {
        SVProgressHUD.show()
        ServiceGenerator.shared.latest() {
            result in switch(result){
            case let .success(JSON):
                //save currency to app on first time of calling api
                if let rates = JSON["rates"].dictionaryObject {
                    var newList = [Currency]()
                    for (key, _) in rates {
                        let newCurrency =  Currency(symbol: key)
                        let currencyObject = CurrencyObject(currency: newCurrency)
                        try! self.realm.write {
                            self.realm.add(currencyObject)
                        }
                        newList.append(newCurrency)
                    }
                    self.currencyList = newList
                    
                    if self.currencyList.count > 0 {
                        let firstCurrency = self.currencyList[0].symbol
                        self.getSymbolNFlag(label: self.convertedCurrency, dropDownLabel: self.convertedCurrencydropDown, symbol: firstCurrency)
                    }
                }
                
                //reload pickerview components
                DispatchQueue.main.async {
                    self.picker1.reloadAllComponents()
                    self.picker2.reloadAllComponents()
                }

                SVProgressHUD.dismiss()
                break

            case let .failure(error):
                SVProgressHUD.dismiss()
                print(error.localizedDescription)
                AlertView.showAlert(view: self, title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    //convert currency api call
    func convertCurrency(baseStr: String, symbolStr: String) {
        if (!isFormValid()) {
            return
        }
        
        SVProgressHUD.show()
        
        ServiceGenerator.shared.convert(base: baseStr, symbol: symbolStr) {
            result in switch(result) {
            case let .success(JSON):
                //if base currency is restricted, show response
                if JSON["success"].boolValue == false {
                    let errorMessage = JSON["error"]["type"].stringValue
                    AlertView.showAlert(view: self, title: "Access restriction", message: errorMessage)
                } else {
                    let value = JSON["rates"][symbolStr].doubleValue
                    
                    //compute currency conversion
                    let actualRate = Double(value.formattedNumber) ?? 0.0
                    let baseRate = Double(self.textfield.text ?? "") ?? 0.0
                    
                    let computedRate = Double(actualRate * baseRate)
                
                    //show computed rate in label
                    self.convertedRate.text = "\(computedRate.formattedNumber)"
                    
                }
                
                SVProgressHUD.dismiss()
                break

            case let .failure(error):
                SVProgressHUD.dismiss()
                AlertView.showAlert(view: self, title: "Error", message: error.localizedDescription)
            }
        }
    }

    //set and change navigation bar, UILabel text color and view
    func setHeaderColor() {
        //change and set navigation bar color and button
        navBackgroundColor()
        removeNavBorderLine()
        navRightButton()
        navBackButton()
        
        //chart marker and delegate
        customizeChart(lineChart: lineChartView, dataPoints: dateList, values: rateList)
        let marker = ChartMarker()
        marker.chartView = lineChartView
        lineChartView.marker = marker
        lineChartView.delegate = self
        
        let text = "Currency \nCalculator."
        
        //change dot color to menu color
        let range = (text as NSString).range(of: ".")
        let attributedString = NSMutableAttributedString(string:text)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.menuColor , range: range)
        //Apply to the label
        screenHeader.attributedText = attributedString
       
        //Underline labels and set color
        underlineLabel (label: infoLabel, string: "Mid-market exchange rate at 13:38 UTC")
        infoLabel.textColor = UIColor.headerColor
        underlineLabel (label: getAlertLabel, string: "Get rate alerts straight to your email inbox")
        
        //gradient color for chartView
        gradientColor(layerView : chartView, color1: UIColor.chartViewColor1, color2: UIColor.chartViewColor2)
        addPaddingToView(paddingView: chartView)//corner radius to just top
            
        //radius and border width for dropdown boxes
        dropDown.layer.borderWidth = 1
        dropDown.layer.borderColor = UIColor.borderColor
        dropDown2.layer.borderWidth = 1
        dropDown2.layer.borderColor = UIColor.borderColor
        
    }
    
    //left navigation bar menu button
    func navBackButton() {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "icons8-align-left-96"), for: .normal)
        button.addTarget(self, action:#selector(menuPressed(sender:)), for: .touchDragInside)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
    }
    
    //Right navigation label
    func navRightButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign up", style: .done, target: self, action: #selector(signupTapped(sender:)))
    }
    
    //MARK: - PickerView delegate and datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let flag = currencyList[row].symbol.dropLast()
        return getFlag(from: "\(flag)") + "  " + currencyList[row].symbol
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let symbol = currencyList[row].symbol
        if pickerView.tag == 2 {
            //if base symbol == destination symbol, show same value
            let baseSymbol = baseCurrency.text
            let baseValue = textfield.text
            if symbol == baseSymbol {
                convertedRate.text = baseValue
                getSymbolNFlag(label: convertedCurrency, dropDownLabel: convertedCurrencydropDown, symbol: symbol)
            } else {
                getSymbolNFlag(label: convertedCurrency, dropDownLabel: convertedCurrencydropDown, symbol: symbol)
            }
            picker2.isHidden = true
        } else {
            getSymbolNFlag(label: baseCurrency, dropDownLabel: baseCurrencydropDown, symbol: symbol)
            picker1.isHidden = true
        }
       
    }
    
    //display currency symbol and flag on labels
    func getSymbolNFlag(label: UILabel, dropDownLabel: UILabel, symbol: String) {
        label.text = symbol
        let flag = symbol.dropLast()
        dropDownLabel.text = getFlag(from: "\(flag)") + "  " + symbol
    }
    
    //check if textfield is empty or zero
    func isFormValid() -> Bool {
        let baseValue = textfield.text ?? ""
        
        if(baseValue == "" || Double(baseValue) ?? 0 < 1) {
            textfield.becomeFirstResponder()
            AlertView.showAlert(view: self, title: "Empty field message", message: " Base currency value is required")
            
            return false
        }
        
        return true
    }
    
}

//MARK: - UICollectionView Delegate and Datasource for graph filter
extension ConverterVC : UICollectionViewDelegate {
   
}

extension ConverterVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
       
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PastDaysCell", for: indexPath) as! PastDaysCell

        let member = days[indexPath.row]
       
        cell.daysLabel.text = member
        
        if (indexPath.row == 0) {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
            cell.selectedDot.isHidden = false
            cell.selectedDot.backgroundColor = .menuColor
            cell.daysLabel.textColor = UIColor.white
        }
       
        return cell
        
    }
   
}

extension ConverterVC : UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension ConverterVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let numberofItem: CGFloat = 2
        let collectionViewWidth = (collectionView.bounds.width)
        let extraSpace = (numberofItem - 1) * flowLayout.minimumInteritemSpacing
        let inset = flowLayout.sectionInset.right + flowLayout.sectionInset.left
        let width = Int((collectionViewWidth - extraSpace - inset) / numberofItem)
        let height = Int(50)
        
        return CGSize(width: width, height: height)
        
    }
}

//MARK: chart marker for getting coord when touched
class ChartMarker: MarkerView {
    private var text = String()

    private let drawAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 15),
        .foregroundColor: UIColor.white,
        .backgroundColor: UIColor.menuColor
    ]

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        text = "\(entry.x) \n1 \(Constant.BASE_SYMBOL) = \(entry.y))"
    }

    override func draw(context: CGContext, point: CGPoint) {
        super.draw(context: context, point: point)

        let sizeForDrawing = text.size(withAttributes: drawAttributes)
        bounds.size = sizeForDrawing
        offset = CGPoint(x: -sizeForDrawing.width / 2, y: -sizeForDrawing.height - 4)

        let offset = offsetForDrawing(atPoint: point)
        let originPoint = CGPoint(x: point.x + offset.x, y: point.y + offset.y)
        let rectForText = CGRect(origin: originPoint, size: sizeForDrawing)
        drawText(text: text, rect: rectForText, withAttributes: drawAttributes)
    }

    private func drawText(text: String, rect: CGRect, withAttributes attributes: [NSAttributedString.Key: Any]? = nil) {
        let size = bounds.size
        let centeredRect = CGRect(
            x: rect.origin.x + (rect.size.width - size.width) / 2,
            y: rect.origin.y + (rect.size.height - size.height) / 2,
            width: size.width,
            height: size.height
        )
        text.draw(in: centeredRect, withAttributes: attributes)
    }
}
