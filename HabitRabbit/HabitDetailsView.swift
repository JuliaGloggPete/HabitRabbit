//
//  HabitDetailsView.swift
//  HabitRabbit
//
//  Created by Julia Petersson  on 2023-04-19.
//

import SwiftUI

struct HabitDetailsView: View {
    @State var content : String = ""
    var body: some View {
        TextEditor(text: $content)
    }
}

struct HabitDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailsView()
    }
}
