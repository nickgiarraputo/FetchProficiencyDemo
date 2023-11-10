# FetchProficiencyDemo
A demonstration of iOS proficiency and related frameworks for Fetch Rewards.

[![Languages](https://img.shields.io/badge/language-swift%20-FF4700.svg?style=plastic)](#) <br/>

Description
--------------

```Take Home Proficiency Demo```

This project was built using Xcode 15.0.1 on Apple Silicon and tested with iPhone 13 Pro running iOS 17.0 and several simulators running iOS 15.0+.

This project was designed for iPhone, but is also compatible with Mac Catalyst and iPad.


Requirements
-----------------------------

- iOS 15.0+


App Architecture
-----------------------------

This is a UIKit application that wraps a significant amount of SwiftUI. I prefer this architecture to retain the imperative control of UIKit while also reaping the declarative benefits of SwiftUI as much as possible.

Files are organized into two folders, `UI` and `API`. 

```API```
The `API` folder contains `TheMealDBHandler.swift`, which manages two crucial tasks:
- Retrieve data from TheMealDB API
- Decode data into structs

By decoding the JSON data into structs and not using plain dictionaries, we have a better understanding of the data and can avoid unpredicted null values. It also makes the code much cleaner to read.

```UI```
The `UI` folder contains all classes that extend UIViewController, as well as their respective SwiftUI Views. 

`MealListViewController` and `MealListView`:
Starts by using `TheMealDBHandler` to fetch a list of all desserts. Once the list is obtained, using UIHostingController, the controller adds an instance of `MealListView` to the view, which displays a list of all given meals and their corresponding images. Once a row in the `MealListView` is tapped, an instance of `MealDetailViewController` is created and given the corresponding meal's ID number. The UINavigationController will then push the new controller.

`MealDetailViewController` and `MealDetailView`:
Starts by using `TheMealDBHandler` to fetch meal details using the given ID number. Once the details are obtained, using UIHostingController, the controller adds an instance of `MealDetailView` to the view, which displays the meal's image, name, ingredients & measurements, and instructions in an exquisitely readable format. 

`FullScreenAlertViewController`:
Presents a full screen alert with a given title and message.
This is the only UIViewController that does not wrap SwiftUI. Instead, I used it as an opportunity to display my UIKit proficiency, using techniques such as anonymous declaration and programmatic NSLayoutConstraint activation.


License
--------------

MIT License, Copyright (c) 2023 Nicholas Giarraputo
