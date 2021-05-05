//
//  WebServiceViewModel.swift
//  CarouselSample
//
//  Created by AMRUTHAPRASAD KK on 05/05/21.
//  Copyright © 2021 MB. All rights reserved.
//

import Foundation

struct WebServiceViewModel {
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    private func parse(jsonData: Data) throws -> [Brand] {
        do {
            let decodedData = try JSONDecoder().decode(CarBrands.self,
                                                       from: jsonData)

            return decodedData.data
        } catch {
            print("decode error")
            return []
        }
    }

    func fetchData() -> [Brand] {
        if let localData = self.readLocalFile(forName: "cars-json") {
            do {
                let brandList = try self.parse(jsonData: localData)
                return brandList

            } catch {
                
            }
        }
        return []
    }

}

