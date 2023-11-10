//
//  MealListView.swift
//  Take Home Proficiency Demo
//
//  Created by Nick Giarraputo on 11/9/23.
//

import SwiftUI

struct MealListView: View {
    var meals: [TheMealDBHandler.Meal]!
    var darkMode: Bool
    var mealSelected: (TheMealDBHandler.Meal) -> Void
    
    var body: some View {
        List {
            ForEach(meals) { meal in
                HStack {
                    
                    /// Thumbnail image
                    Image(uiImage: meal.thumbnail ?? UIImage(systemName: "xmark")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                    
                    /// Background image
                    Image(uiImage: meal.thumbnail ?? UIImage(systemName: "xmark")!)
                        .frame(maxWidth: 0, maxHeight: 0)
                        .opacity(0.1)
                    
                    /// Title of meal
                    Text(meal.strMeal)
                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                        .font(.system(size: 19, weight: .medium))
                        .foregroundColor(darkMode ? .white : .black)
                    Spacer()
                }
                .listRowBackground(Color(white: darkMode ? 0.05 : 0.95))
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                .contentShape(Rectangle())
                .onTapGesture {
                    mealSelected(meal)
                }
            }
        }
    }
}

#Preview {
    MealListView(
        meals: [
            TheMealDBHandler.Meal(strMeal: "Apam balik", strMealThumb: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg", idMeal: "00000"),
            TheMealDBHandler.Meal(strMeal: "Apple & Blackberry Crumble", strMealThumb: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg", idMeal: "00001"),
            TheMealDBHandler.Meal(strMeal: "Apple Frangipan Tart", strMealThumb: "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg", idMeal: "00002"),
            TheMealDBHandler.Meal(strMeal: "Bakewell tart", strMealThumb: "https://www.themealdb.com/images/media/meals/wyrqqq1468233628.jpg", idMeal: "00003"),
        ],
        darkMode: false,
        mealSelected: { id in
            print("Meal selected with ID \(id)")
        }
    )
}
