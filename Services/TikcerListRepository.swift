//
//  TikcerListRepository.swift
//  GPSEquity
//
//  Created by Anuj Purandare on 4/13/24.
//

import Foundation
import XCAStocksAPI

protocol TickerListRepository {
    func save(_ current: [Ticker]) async throws
    func saveDash(_ current: [Ticker]) throws
    func load() async throws -> [Ticker]
    func loadDash() async throws -> [Ticker]
}

class TickerPlistRepository: TickerListRepository {
    
    private var saved: [Ticker]?
    private let filename: String
    
    private var url: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appending(component: "\(filename).plist")
    }
    
    init(filename: String = "my_tickers") {
        self.filename = filename
    }
    
    func save(_ current: [Ticker]) throws {
        if let saved, saved == current {
            return
        }
        
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        let data = try encoder.encode(current)
        try data.write(to: url, options: [.atomic])
        self.saved = current
    }
    
    func saveDash(_ current: [Ticker]) throws {
        self.saved = dashStoxList
    }
    
    
    func load() throws -> [Ticker] {
        if FileManager.default.fileExists(atPath: url.path) {
            let data = try Data(contentsOf: url)
            let current = try PropertyListDecoder().decode([Ticker].self, from: data)
            self.saved = current
            return current
        } else {
            throw NSError(domain: "TickerPlistRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "File not found: \(url.path)"])
        }
    }
    
    func loadDash() throws -> [Ticker] {
        return dashStoxList
    }
}


let nvda = Ticker(symbol: "NVDA", quoteType: Optional("EQUITY"), shortname: Optional("NVIDIA Corporation"), longname: Optional("NVIDIA Corporation"), sector: Optional("Technology"), industry: Optional("Semiconductors"), exchDisp: Optional("NASDAQ"))
let goog = Ticker(symbol: "GOOG", quoteType: Optional("EQUITY"), shortname: Optional("Alphabet Inc."), longname: Optional("Alphabet Inc."), sector: Optional("Communication Services"), industry: Optional("Internet Content & Information"), exchDisp: Optional("NASDAQ"))
let amzn = Ticker(symbol: "AMZN", quoteType: Optional("EQUITY"), shortname: Optional("Amazon.com, Inc."), longname: Optional("Amazon.com, Inc."), sector: Optional("Consumer Cyclical"), industry: Optional("Internet Retail"), exchDisp: Optional("NASDAQ"))
let msft = Ticker(symbol: "MSFT", quoteType: Optional("EQUITY"), shortname: Optional("Microsoft Corporation"), longname: Optional("Microsoft Corporation"), sector: Optional("Technology"), industry: Optional("Software—Infrastructure"), exchDisp: Optional("NASDAQ"))
let amd = Ticker(symbol: "AMD", quoteType: Optional("EQUITY"), shortname: Optional("Advanced Micro Devices, Inc."), longname: Optional("Advanced Micro Devices, Inc."), sector: Optional("Technology"), industry: Optional("Semiconductors"), exchDisp: Optional("NASDAQ"))
let amc = Ticker(symbol: "AMC", quoteType: Optional("EQUITY"), shortname: Optional("AMC Entertainment Holdings, Inc"), longname: Optional("AMC Entertainment Holdings, Inc."), sector: Optional("Communication Services"), industry: Optional("Entertainment"), exchDisp: Optional("NYSE"))
let gme = Ticker(symbol: "GME", quoteType: Optional("EQUITY"), shortname: Optional("GameStop Corporation"), longname: Optional("GameStop Corp."), sector: Optional("Consumer Cyclical"), industry: Optional("Specialty Retail"), exchDisp: Optional("NYSE"))
let riv = Ticker(symbol: "RIVN", quoteType: Optional("EQUITY"), shortname: Optional("Rivian Automotive, Inc."), longname: Optional("Rivian Automotive, Inc."), sector: Optional("Consumer Cyclical"), industry: Optional("Auto Manufacturers"), exchDisp: Optional("NASDAQ"))
let rbnhood = Ticker(symbol: "HOOD", quoteType: Optional("EQUITY"), shortname: Optional("Robinhood Markets, Inc."), longname: Optional("Robinhood Markets, Inc."), sector: Optional("Financial Services"), industry: Optional("Capital Markets"), exchDisp: Optional("NASDAQ"))
let bb = Ticker(symbol: "BB", quoteType: Optional("EQUITY"), shortname: Optional("BlackBerry Limited"), longname: Optional("BlackBerry Limited"), sector: Optional("Technology"), industry: Optional("Software—Infrastructure"), exchDisp: Optional("NYSE"))

let dashStoxList = [amc, nvda, gme, goog, riv, amzn, bb, msft, amd, rbnhood]
