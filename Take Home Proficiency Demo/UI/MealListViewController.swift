//
//  ViewController.swift
//  Take Home Proficiency Demo
//
//  Created by Nick Giarraputo on 11/9/23.
//

import UIKit
import SwiftUI

class MealListViewController: UIViewController {
    
    private var mealsListView: MealListView!
    
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Set navigation title
        title = "Desserts"
        
        /// Starting point: refresh the data
        loadDesserts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Present welcome alert
        let welcomeAlert = FullScreenAlertViewController(title: "Welcome", message: "This \"take home test\" app serves as a demonstration of proficiency with iOS and relevant frameworks.\n\nThank you for taking the time to review my submission, and please reach out if any further information is needed.")
        welcomeAlert.addAction(FullScreenAlertAction(title: "Continue", action: { _ in
            welcomeAlert.dismiss(animated: true)
        }))
        present(welcomeAlert, animated: true)
    }
    
    ///*******************************************************
    /// Refreshes the data from the endpoint, then shows an error alert
    /// with retry option if data is nil, or loads the SwiftUI view if data is valid
    ///*******************************************************
    func loadDesserts() {
        
        activityIndicator.startAnimating()
        loadingLabel.isHidden = false
        
        TheMealDBHandler.shared.getAllDesserts() { desserts in
            
            /// Stop the activity indicator on ui-thread
            DispatchQueue.main.async { [self] in
                activityIndicator.stopAnimating()
                loadingLabel.isHidden = true
            }
            
            /// Nil-check the data
            guard let desserts = desserts else {
                let alert = UIAlertController(title: "Error", message: "An error was encountered when trying to refresh data.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                    self.loadDesserts()
                })
                DispatchQueue.main.async { [self] in
                    present(alert, animated: true)
                }
                return
            }
            
            /// Load the SwiftUI view now that we've refreshed the data
            DispatchQueue.main.async { [self] in
                loadMealListView(mealList: desserts)
            }
        }
    }
    
    ///*******************************************************
    /// Instantiates the MealListView within a UIHostingController, then
    /// adds view as a subview of self.view and constrains the subview
    ///*******************************************************
    func loadMealListView(mealList: [TheMealDBHandler.Meal]) {
        
        /// Sort the meals alphabetically
        let mealList = mealList.sorted(by: { $0.strMeal < $1.strMeal })
        
        /// Instantiate the SwiftUI view
        mealsListView = MealListView(
            meals: mealList,
            darkMode: traitCollection.userInterfaceStyle == .dark,
            mealSelected: { meal in
                
                /// Navigate to Meal Details
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MealDetailsViewController") as! MealDetailViewController
                vc.mealID = meal.idMeal
                vc.mealTitle = meal.strMeal
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        )
            
        /// Instantiate the UIHostingController that will contain the SwiftUI view
        let hostingController = UIHostingController(rootView: mealsListView)
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

