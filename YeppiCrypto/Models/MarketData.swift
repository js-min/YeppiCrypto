//
//  MarketData.swift
//  YeppiCrypto
//
//  Created by JISU MIN on 2022/06/18.
//

import Foundation

//JSON data:
/*
 
 URL: https://api.coingecko.com/api/v3/global
 
 JSON response:
 {
   "data": {
     "active_cryptocurrencies": 13470,
     "upcoming_icos": 0,
     "ongoing_icos": 49,
     "ended_icos": 3376,
     "markets": 522,
     "total_market_cap": {
       "btc": 45388386.20593734,
       "eth": 856476803.6524831,
       "ltc": 19492765978.367077,
       "bch": 7761075317.07081,
       "bnb": 4295511825.863013,
       "eos": 988846904615.8942,
       "xrp": 2876704881744.2095,
       "xlm": 8284036306178.9375,
       "link": 145583480783.36765,
       "dot": 126881214209.44894,
       "yfi": 193041834.235288,
       "usd": 940135379245.9756,
       "aed": 3453117247970.4663,
       "ars": 115516036978774.56,
       "aud": 1355927173154.3315,
       "bdt": 87365264354961.56,
       "bhd": 354419756351.1818,
       "bmd": 940135379245.9756,
       "brl": 4845081690482.064,
       "cad": 1224719059220.63,
       "chf": 912728552670.1975,
       "clp": 824310700522868.8,
       "cny": 6314607301781.446,
       "czk": 22151422799024.707,
       "dkk": 6662880453023.12,
       "eur": 895452624941.1729,
       "gbp": 768995015078.7979,
       "hkd": 7379973414219.856,
       "huf": 358142222385305.8,
       "idr": 13950527872324132,
       "ils": 3254762784980.252,
       "inr": 73294458382623.06,
       "jpy": 126901357756955.45,
       "krw": 1214241250418929.8,
       "kwd": 288690191311.1994,
       "lkr": 337442700479625.8,
       "mmk": 1740324544054081.8,
       "mxn": 19120050282183.957,
       "myr": 4138475939440.7803,
       "ngn": 390504032477400.56,
       "nok": 9402832625411.305,
       "nzd": 1489017438117.2903,
       "php": 50567532651328.33,
       "pkr": 196685039213629.47,
       "pln": 4191076513909.5933,
       "rub": 54057692173376.27,
       "sar": 3527620156369.572,
       "sek": 9564178659197.477,
       "sgd": 1307643700347.0168,
       "thb": 33059807963603.49,
       "try": 16291041905725.936,
       "twd": 27937532997363.035,
       "uah": 27768382899793.707,
       "vef": 94135755523.89944,
       "vnd": 21838224904810740,
       "zar": 15073510181479.645,
       "xdr": 682979208825.4447,
       "xag": 43365192176.20465,
       "xau": 510869565.0822641,
       "bits": 45388386205937.34,
       "sats": 4538838620593734
     },
     "total_volume": {
       "btc": 3792222.3261662573,
       "eth": 71559064.51306237,
       "ltc": 1628630328.6153836,
       "bch": 648441717.2030622,
       "bnb": 358892157.4439683,
       "eos": 82618652529.97812,
       "xrp": 240350128970.10236,
       "xlm": 692135368914.1338,
       "link": 12163572497.218765,
       "dot": 10600988788.475893,
       "yfi": 16128741.620150024,
       "usd": 78548780267.69322,
       "aed": 288509669923.237,
       "ars": 9651422557161.816,
       "aud": 113288392219.12509,
       "bdt": 7299411451094.141,
       "bhd": 29611947575.55713,
       "bmd": 78548780267.69322,
       "brl": 404808993987.58417,
       "cad": 102325888798.6254,
       "chf": 76258926225.32947,
       "clp": 68871570538713.195,
       "cny": 527588592424.01514,
       "czk": 1850762433228.3735,
       "dkk": 556686988074.1824,
       "eur": 74815513839.1303,
       "gbp": 64249917405.322975,
       "hkd": 616600462967.2644,
       "huf": 29922961471027.023,
       "idr": 1165573568075258.5,
       "ils": 271937055518.45755,
       "inr": 6123788587717.793,
       "jpy": 10602671791926.066,
       "krw": 101450462642541.64,
       "kwd": 24120209603.141354,
       "lkr": 28193506082251.406,
       "mmk": 145404984455554.03,
       "mxn": 1597489746133.2214,
       "myr": 345771730738.3852,
       "ngn": 32626806859791.707,
       "nok": 785611359908.2928,
       "nzd": 124408150297.72128,
       "php": 4224942597197.3325,
       "pkr": 16433133214840.812,
       "pln": 350166534994.3627,
       "rub": 4516547167611.881,
       "sar": 294734425113.1109,
       "sek": 799091901577.8324,
       "sgd": 109254283962.13692,
       "thb": 2762163459381.7363,
       "try": 1361124683990.6926,
       "twd": 2334194828824.906,
       "uah": 2320062253730.361,
       "vef": 7865089368.204115,
       "vnd": 1824594592813040.8,
       "zar": 1259399300617.2144,
       "xdr": 57063253852.290825,
       "xag": 3623183454.968961,
       "xau": 42683407.19746458,
       "bits": 3792222326166.2573,
       "sats": 379222232616625.75
     },
     "market_cap_percentage": {
       "btc": 42.0153577615649,
       "eth": 14.166369310213254,
       "usdt": 7.293709354923802,
       "usdc": 5.8958653054203225,
       "bnb": 3.800554401015793,
       "busd": 1.8872737759992901,
       "ada": 1.7824598396074598,
       "xrp": 1.678815481006422,
       "sol": 1.1374577340963763,
       "dot": 0.8860302588002448
     },
     "market_cap_change_percentage_24h_usd": 1.8807874265886186,
     "updated_at": 1655512524
   }
 }
 */

// MARK: - GlobalData
struct GlobalData: Codable {
    let data: MarketData?
}

// MARK: - MarketData
struct MarketData: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
  
  enum CodingKeys: String, CodingKey {
    case totalMarketCap = "total_market_cap"
    case totalVolume = "total_volume"
    case marketCapPercentage = "market_cap_percentage"
    case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
  }
  
  var marketCap: String {
    if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
      return "$" + item.value.formattedWithAbbreviations()
    }
    return ""
  }
  
  var volume: String {
    if let item = totalVolume.first(where: { $0.key == "usd" }) {
      return "$" + item.value.formattedWithAbbreviations()
    }
    return ""
  }
  
  var btcDominance: String {
    if let item = marketCapPercentage.first(where: { $0.key == "btc" }) {
      return item.value.asPercentString()
    }
    return ""
  }
}
