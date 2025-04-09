//
//  BillDetailsViewModel.swift
//  BillSplitsDetail
//
//  Created by Sneha on 07/04/25.
//
import Foundation

@MainActor
class BillDetailsViewModel: ObservableObject {
    @Published var bill: Bill?
    
    func fetchBills() async {
        guard let url = Bundle.main.url(forResource: "bills", withExtension: "json") else {
            print("File not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(BillResponse.self, from: data)
            if let bill = decodedResponse.bills.first {
                self.bill = bill
            }
        } catch {
            print("Unable to load JSON")
        }
    }
}
