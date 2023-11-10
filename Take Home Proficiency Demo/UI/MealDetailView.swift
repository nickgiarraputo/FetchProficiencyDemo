//
//  MealDetailView.swift
//  Take Home Proficiency Demo
//
//  Created by Nick Giarraputo on 11/9/23.
//

import SwiftUI

struct MealDetailView: View {
    var mealTitle: String
    var mealImageURL: String
    var mealInstructions: String
    var mealIngredients: [String:String]
    var darkMode: Bool
    
    var body: some View {
        List {
            VStack {
                /// Thumbnail image
                AsyncImage(
                    url: URL(string: mealImageURL),
                    content: { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fit)
                             .frame(maxWidth: 240, maxHeight: 240)
                             .cornerRadius(24)
                    },
                    placeholder: {
                        ProgressView()
                    }
                )
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                
                /// Background image
//                AsyncImage(url: URL(string: mealImageURL))
//                    .frame(maxWidth: 0, maxHeight: 0)
//                    .opacity(0.1)
                
                /// Title of meal
                Text(mealTitle)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .font(.custom(
                        "Charter",
                        fixedSize: 30))
                    .foregroundColor(darkMode ? .white : .black)
                Spacer(minLength: 30)
                
                /// Ingredients
                Text("Ingredients")
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0))
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(darkMode ? .white : .black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                /// Ingredients list
                ForEach(mealIngredients.sorted(by: >), id: \.key) { name, measurement in
                    HStack {
                        Text(name)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(darkMode ? .white : .black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(measurement)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(darkMode ? .white : .black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer()
                }
                Spacer(minLength: 20)
                
                /// Ingredients
                Text("Instructions")
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0))
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(darkMode ? .white : .black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                /// Instructions text
                Text(mealInstructions)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(darkMode ? .white : .black)
                Spacer()
            }
        }
    }
}

#Preview {
    MealDetailView(
        mealTitle: "Apam Balik",
        mealImageURL: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
        mealInstructions: "Mix milk, oil and egg together. Sift flour, baking powder and salt into the mixture. Stir well until all ingredients are combined evenly. Spread some batter onto the pan. Spread a thin layer of batter to the side of the pan. Cover the pan for 30-60 seconds until small air bubbles appear. Add butter, cream corn, crushed peanuts and sugar onto the pancake. Fold the pancake into half once the bottom surface is browned. Cut into wedges and best eaten when it is warm.",
        mealIngredients: [
            "Milk" : "200ml",
            "Oil" : "600ml",
            "Eggs" : "2",
            "Flour" : "1600g",
            "Baking Powder" : "3 tsp",
            "Salt" : "1/2 tsp",
            "Unsalted Butter" : "25g",
            "Sugar" : "45g",
            "Peanut Butter" : "3 tbs",
        ],
        darkMode: false
    )
}
