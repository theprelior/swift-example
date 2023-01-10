import SwiftUI
import CoreData

struct MyView: View {
    @ObservedObject var model = Model()
    @EnvironmentObject var userSettings: UserSettings
    @State private var showAddIngredientView = false
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(model.ingredients) { ingredient in
                        IngredientRow(ingredient: ingredient)
                    }.onDelete(perform: model.deleteIngredient)
                }
                .navigationBarTitle("Ingredients")
                .navigationBarItems(leading: EditButton(), trailing:
                    Button(action: {
                        self.showAddIngredientView = true
                    }, label: {
                        Image(systemName: "plus")
                    }))
                .sheet(isPresented: $showAddIngredientView) {
                    AddIngredientView(showAddIngredientView: self.$showAddIngredientView, model: self.model, userSettings: self.userSettings)
                }
            }
        }
    }
}

struct IngredientRow: View {
    @ObservedObject var ingredient: Ingredient
    var body: some View {
        Text(ingredient.name)
    }
}


			
			
struct AddIngredientView: View {
    @Binding var showAddIngredientView: Bool
    @ObservedObject var model: Model
    @EnvironmentObject var userSettings: UserSettings
    @State private var ingredientName: String = ""
    var body: some View {
        VStack {
            TextField("Enter Ingredient Name", text: $ingredientName)
            Button(action: {
                // Add ingredient to core data using the Ingredient struct
                self.model.addIngredient(name: self.ingredientName)
                self.ingredientName = ""
                self.showAddIngredientView = false
            }, label: {
                Text("Add Ingredient")
            })
        }
    }
}



struct Ingredient: NSManagedObject, Identifiable {
    @NSManaged var id: UUID?
    @NSManaged var name: String
}

class UserSettings: ObservableObject {
    @Published var newIngredientName: String = ""
    @Published var showingAddIngredient = false
}

struct MyViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.green)
            .font(.largeTitle)
    }
}

extension View {
    func myViewModifier() -> some View {
        self.modifier(MyViewModifier())
    }
}