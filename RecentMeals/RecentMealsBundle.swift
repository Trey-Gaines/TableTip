//
//  RecentMealsBundle.swift
//  RecentMeals
//
//  Created by Trey Gaines on 1/12/24.
//

import WidgetKit
import SwiftUI

@main
struct RecentMealsBundle: WidgetBundle {
    var body: some Widget {
        //Add both of the widgets into the bundle
        RecentMeals()
        MonthlyStats()
    }
}
