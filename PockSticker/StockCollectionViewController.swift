//
//  StockCollectionViewController.swift
//  PockSticker
//
//  Created by Justin Loew on 3/10/15.
//  Copyright (c) 2015 Lustin' Joew. All rights reserved.
//

import UIKit

let reuseIdentifier = "StockViewCell"

class StockCollectionViewController: UICollectionViewController {
	
	/// The model of our model view controller. It handles downloading the images and stock prices for our stocks.
	let stockDataModel = StockData()
	
	/// The stocks that we want to be displayed in the app.
	let stockSymbols = [
		"AAPL",	// Apple Inc.
		"AMD",	// Advanced Micro Devices, Inc.
		"GOOG",	// Google Inc.
		"INTC",	// Intel Corporation
		"MCD",	// McDonald's Corporation
		"MSFT",	// Microsoft Corporation
		"T",	// AT&T Inc.
		"TSLA",	// Tesla Motors Inc.
		"VZ",	// Verizon Communications Inc.
		"YHOO"	// Yahoo! Inc.
	]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerNib(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return stockSymbols.count
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as StockViewCell
		
		let stockSymbol = stockSymbols[indexPath.row]
		
		// give the cell a default configuration
		cell.label.text = stockSymbol
		
		// download the data to put in the cell
		stockDataModel.downloadDataForStock(stockSymbol, completion: { (price, chart) -> Void in
			cell.label.text = "\(stockSymbol): \(price)"
			cell.imageView.image = chart
			cell.spinner.stopAnimating()
		})
		
		return cell
	}

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
