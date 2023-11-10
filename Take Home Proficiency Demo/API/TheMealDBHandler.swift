//
//  TheMealDBHandler.swift
//  Take Home Proficiency Demo
//
//  Created by Nick Giarraputo on 11/9/23.
//

import Foundation
import UIKit

class TheMealDBHandler {
    
    static let shared = TheMealDBHandler()
    
    ///*******************************************************
    /// Represents a single meal object
    ///*******************************************************
    struct Meal: Identifiable {
        var strMeal: String
        var strMealThumb: String
        var idMeal: String
        var thumbnail: UIImage?
        
        /// Make this class conform to Indentifiable so we can iterate later within SwiftUI
        public var id: Int {
            return Int(idMeal)!
        }
        
        /// Return a Meal object if data is valid, otherwise return nil
        static func createFromDictionary(_ dict: [String:Any]) -> Meal? {
            
            /// Get necessary values
            guard let meal = dict["strMeal"] as? String,
                  let mealThumb = dict["strMealThumb"] as? String,
                  let id = dict["idMeal"] as? String
            else {
                return nil
            }
            
            /// Return object
            return Meal(strMeal: meal, strMealThumb: mealThumb, idMeal: id)
        }
    }
    
    ///*******************************************************
    /// Represents a meal lookup object
    ///*******************************************************
    struct MealDetail: Identifiable {
        var strMealThumb: String
        var strMeal: String
        var idMeal: String
        var strIsDrinkAlternate: String?
        var strCategory: String
        var strArea: String
        var strInstructions: String
        var strTags: String?
        var strYoutube: String
        var ingredients: [String:String]
        var strSource: String?
        var strImageSource: String?
        var strCreativeCommonsConfirmed: String?
        var dateModified: String?
        
        /// Make this class conform to Indentifiable so we can iterate later within SwiftUI
        public var id: Int {
            return Int(idMeal)!
        }
        
        /// Return a Meal object if data is valid, otherwise return nil
        static func createFromDictionary(_ dict: [String:Any]) -> MealDetail? {
            
            /// Iterate the ingredients and measurements in the raw json data to
            /// form a dictionary of meal ingredients to their respective measurement
            var mealIngredients = [String:String]()
            for i in 1 ... 20 {
                /// Get ingredient name and measurement, ensuring they are not nil or empty
                if let ingredientName = (dict["strIngredient\(i)"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines),
                   let ingredientMeasurement = (dict["strMeasure\(i)"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines),
                   !ingredientName.isEmpty &&
                   !ingredientMeasurement.isEmpty
                {
                    mealIngredients[ingredientName] = ingredientMeasurement
                }
            }
            
            /// Get necessary values
            guard let meal = dict["strMeal"] as? String,
                  let mealThumb = dict["strMealThumb"] as? String,
                  let id = dict["idMeal"] as? String,
                  let category = dict["strCategory"] as? String,
                  let area = dict["strArea"] as? String,
                  let instructions = dict["strInstructions"] as? String,
                  let youtube = dict["strYoutube"] as? String
            else {
                return nil
            }
            
            /// Return object
            return MealDetail(
                strMealThumb: mealThumb,
                strMeal: meal,
                idMeal: id,
                strIsDrinkAlternate: dict["strIsDrinkAlternate"] as? String,
                strCategory: category,
                strArea: area,
                strInstructions: instructions,
                strTags: dict["strTags"] as? String,
                strYoutube: youtube,
                ingredients: mealIngredients,
                strSource: dict["strSource"] as? String,
                strImageSource: dict["strImageSource"] as? String,
                strCreativeCommonsConfirmed: dict["strCreativeCommonsConfirmed"] as? String,
                dateModified: dict["dateModified"] as? String
            )
        }
    }
    
    ///*******************************************************
    /// Get all desserts as list of type Meal
    ///*******************************************************
    func getAllDesserts(_ completion: @escaping (([Meal]?) -> Void)) {
        
        /// Define the task
        let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            /// Serialze JSON
            guard let data = data, let dataObj = try? JSONSerialization.jsonObject(with: data, options: []) else {
                completion(nil)
                return
            }
            
            /// Ensure we have a top-level dictionary
            guard let dataJSON = dataObj as? [String:Any] else {
                print("TheMealDBHandler.getAllDessserts - Data is of invalid type.")
                completion(nil)
                return
            }
            
            /// Get value for key 'meals' as a list of dictionaries representing meals
            guard let mealDictList = dataJSON["meals"] as? [[String:Any]] else {
                print("TheMealDBHandler.getAllDessserts - Data does not contain key 'meals'.")
                completion(nil)
                return
            }
            
            /// Initialize list of Meal objects
            var mealList = [Meal]()
            
            /// Iterate the list of dictionaries and form a Meal object for each dictionary
            for element in mealDictList {
                if var meal = Meal.createFromDictionary(element) {
                    /// Download the image synchronously
                    if let url = URL(string: meal.strMealThumb),
                       let data = try? Data(contentsOf: url) {
                        meal.thumbnail = UIImage(data: data)
                    }
                    /// Add this meal to mealList
                    mealList.append(meal)
                } else {
                    print("TheMealDBHandler.getMealDetails - Object is an unexpected model.")
                    continue
                }
            }
            
            /// Everything worked as expected, pass back the object
            completion(mealList)
        }

        /// Begin dataTask
        task.resume()
    }
    
    ///*******************************************************
    /// Get details for a given meal ID
    ///*******************************************************
    func getMealDetails(for mealID: String, _ completion: @escaping ((MealDetail?) -> Void)) {
        
        /// Define the task
        let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            /// Serialze JSON
            guard let data = data, let dataObj = try? JSONSerialization.jsonObject(with: data, options: []) else {
                completion(nil)
                return
            }
            
            /// Ensure we have a top-level dictionary
            guard let dataJSON = dataObj as? [String:Any] else {
                print("TheMealDBHandler.getMealDetails - Data is of invalid type.")
                completion(nil)
                return
            }
            
            /// Get value for key 'meals'
            guard let mealDetailList = dataJSON["meals"] as? [[String:Any]] else {
                print("TheMealDBHandler.getMealDetails - Data does not contain key 'meals'.")
                completion(nil)
                return
            }
            
            /// Get first element in array
            guard let mealDetailDict = mealDetailList.first else {
                print("TheMealDBHandler.getMealDetails - Data does not contain any elements under key 'meals'.")
                completion(nil)
                return
            }
            
            /// Cast to MealDetail object
            guard let mealDetail = MealDetail.createFromDictionary(mealDetailDict) else {
                print("TheMealDBHandler.getMealDetails - Data object is an unexpected model.")
                print(mealDetailDict)
                completion(nil)
                return
            }
            
            /// Everything worked as expected, pass back the object
            completion(mealDetail)
        }

        /// Begin dataTask
        task.resume()
    }
    
}
