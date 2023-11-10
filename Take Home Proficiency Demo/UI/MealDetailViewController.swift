//
//  MealDetailViewController.swift
//  Take Home Proficiency Demo
//
//  Created by Nick Giarraputo on 11/9/23.
//

import UIKit
import SwiftUI

class MealDetailViewController: UIViewController {
    
    var mealID: String!
    var mealTitle: String!
    
    private var mealDetailView: MealDetailView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Set navigation bar title
        title = mealTitle
        
        /// Starting point: refresh the data
        loadDetail()
    }
    
    ///*******************************************************
    /// Refreshes the data from the endpoint, then shows an error alert
    /// with retry option if data is nil, or loads the SwiftUI view if data is valid
    ///*******************************************************
    func loadDetail() {
        TheMealDBHandler.shared.getMealDetails(for: mealID) { detail in
            
            /// Stop the activity indicator on ui-thread
            DispatchQueue.main.async { [self] in
                activityIndicator.stopAnimating()
            }
            
            /// Nil-check the data
            guard let detail = detail else {
                let alert = UIAlertController(title: "Error", message: "An error was encountered when trying to refresh data.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                    self.loadDetail()
                })
                DispatchQueue.main.async { [self] in
                    present(alert, animated: true)
                }
                return
            }
            
            /// Load the SwiftUI view now that we've refreshed the data
            DispatchQueue.main.async { [self] in
                loadMealListView(mealDetail: detail)
            }
        }
    }
    
    ///*******************************************************
    /// Instantiates the MealDetailView within a UIHostingController, then
    /// adds view as a subview of self.view and constrains the subview
    ///*******************************************************
    func loadMealListView(mealDetail: TheMealDBHandler.MealDetail) {
        
        /// Instantiate the SwiftUI view
        mealDetailView = MealDetailView(
            mealTitle: mealDetail.strMeal,
            mealImageURL: mealDetail.strMealThumb,
            mealInstructions: mealDetail.strInstructions,
            mealIngredients: mealDetail.ingredients,
            darkMode: traitCollection.userInterfaceStyle == .dark
        )
            
        /// Instantiate the UIHostingController that will contain the SwiftUI view
        let hostingController = UIHostingController(rootView: mealDetailView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }

}
