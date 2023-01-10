class Model: ObservableObject {
    @Published var ingredients = [Ingredient]()
    @Environment(\.managedObjectContext) var context
    
    func addIngredient(name: String) {
        //Add the ingredient to Core Data
        let ingredient = Ingredient(context: context)
        ingredient.name = name
        ingredients.append(ingredient)
        saveData()
    }
    
    func deleteIngredient(offsets: IndexSet) {
        // Delete the ingredient from Core Data
        offsets.map { ingredients[$0] }.forEach(context.delete)
        ingredients.remove(atOffsets: offsets)
        saveData()
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}