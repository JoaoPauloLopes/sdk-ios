//
//  CustomerCardsViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 31/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

class CustomerCardsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak private var tableView : UITableView!
    var loadingView : UILoadingView!
    var items : [PaymentMethodRow]!
    var cards : [Card]?
    
    var callback : ((selectedCard: Card?) -> Void)?
    
    init(cards: [Card]?, callback: (selectedCard: Card?) -> Void) {
        super.init(nibName: "CustomerCardsViewController", bundle: nil)
        self.cards = cards
        self.callback = callback
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tarjetas guardadas"
        self.navigationItem.backBarButtonItem?.title = "Atrás"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "newCard")

        self.loadingView = UILoadingView(frame: self.view.bounds, text: "Cargando...")
        self.view.addSubview(self.loadingView)
        
        var paymentMethodNib = UINib(nibName: "PaymentMethodTableViewCell", bundle: nil)
        self.tableView.registerNib(paymentMethodNib, forCellReuseIdentifier: "paymentMethodCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        loadCards()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items == nil ? 0 : items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var pmcell : PaymentMethodTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("paymentMethodCell") as PaymentMethodTableViewCell
        
        let paymentRow : PaymentMethodRow = items[indexPath.row]
        pmcell.setLabel(paymentRow.label!)
        pmcell.setImageWithName(paymentRow.icon!)
        
        return pmcell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        callback!(selectedCard: self.cards![indexPath.row])
    }
    
    func loadCards() {
        self.items = [PaymentMethodRow]()
        for (card) in cards! {
            var paymentMethodRow = PaymentMethodRow()
            paymentMethodRow.card = card
            paymentMethodRow.label = card.paymentMethod!.name + " terminada en " + card.lastFourDigits!
            paymentMethodRow.icon = "icoTc_" + card.paymentMethod!.id
            self.items.append(paymentMethodRow)
        }
        self.tableView.reloadData()
        self.loadingView.removeFromSuperview()
    }
    
    func newCard() {
        callback!(selectedCard: nil)
    }
}