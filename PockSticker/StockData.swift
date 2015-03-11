//
//  StockData.swift
//  PockSticker
//
//  Created by Justin Loew on 3/10/15.
//  Copyright (c) 2015 Lustin' Joew. All rights reserved.
//

import Foundation
import UIKit

class StockData {
	
	/// The URL to use to download the stock chart.
	let stockChartRequestURL = "https://www.google.com/finance/getchart?q="
	
	/// The URL to use to download the stock prices.
	let stockPriceRequestURL = "https://www.google.com/finance/option_chain?output=json&q="
	
	/// The key that Google Finance uses to return the current stock price.
	let stockPriceKey = "underlying_price"
	
	/**
	Download the data for a specific stock.
	
	:param: stock A stock symbol. Ex.: "AAPL", "GOOG"
	:param: completion A closure that will be run once the data is downloaded.
	*/
	func downloadDataForStock(stock: String, completion: (price: Float, chart: UIImage?) -> Void) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			let chart = self.downloadChartForStock(stock)
			let price: Float = self.downloadPriceForStock(stock)
			dispatch_async(dispatch_get_main_queue()) {
				completion(price: price, chart: chart)
			}
		}
	}
	
	/// Download a chart of a stock's history.
	private func downloadChartForStock(stockSymbol: String) -> UIImage? {
		let url = NSURL(string: stockChartRequestURL + stockSymbol)!
		
		// download the chart
		let chartDataOrNil = NSData(contentsOfURL: url)
		if let chartData = chartDataOrNil {
			let image = UIImage(data: chartData)!
			return image
		} else {
			println("Error downloading chart for stock symbol \(stockSymbol)")
			return nil
		}
	}
	
	/// Download price data for a stock.
	private func downloadPriceForStock(stockSymbol: String) -> Float {
		let url = NSURL(string: stockPriceRequestURL + stockSymbol)!
		
		// download the price
		let priceDataStringOrNil = NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: nil)
		if let priceDataString = priceDataStringOrNil {
			// Make the JSON readable by iOS using regular expressions. Don't worry if you don't understand this, you're not alone.
			let jsonCompatibleString = priceDataString.stringByReplacingOccurrencesOfString("(\\w+)\\s*:", withString: "\"$1\":", options: .RegularExpressionSearch, range: NSMakeRange(0, priceDataString.length))
			let priceData = jsonCompatibleString.dataUsingEncoding(NSUTF8StringEncoding)!
			let price = getStockPriceFromData(priceData)
			println("\(stockSymbol) is trading at \(price)")
			return price
		} else {
			println("Error downloading price for stock symbol \(stockSymbol)")
			return -1.0
		}
	}
	
	/// Take JSON data and extract the stock price.
	private func getStockPriceFromData(data: NSData) -> Float {
		let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: nil)
		let jsonDictionary = json as NSDictionary!
		if jsonDictionary == nil {
			println("Error parsing JSON.")
			return -1.0
		}
		
		let price = jsonDictionary[stockPriceKey] as Float
		return price
	}
	
}
