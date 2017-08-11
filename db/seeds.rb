# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'json'
require 'open-uri'

puts "Ingredients Seed"
Ingredient.destroy_all
url_ingredients = 'http://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
list_ingredients_serialized = open(url_ingredients).read
list_ingredients = JSON.parse(list_ingredients_serialized)

list_ingredients["drinks"].each do |ingredient_json|
  Ingredient.create!( name: ingredient_json["strIngredient1"] )
end

puts "Cocktails Seed"
Cocktail.destroy_all
url_cocktails = "http://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail"
list_cocktails_serialized = open(url_cocktails).read
list_cocktails = JSON.parse(list_cocktails_serialized)
i = 0
list_cocktails["drinks"].delete_at(0)

list_cocktails["drinks"].each do |cocktail_json|
  cocktail = Cocktail.new( name: cocktail_json["strDrink"] )
  unless cocktail_json["strDrinkThumb"].nil?
  url_cocktail = "http://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=#{cocktail_json["idDrink"]}"
  cocktail_serialized = open(url_cocktail).read
  cock = JSON.parse(cocktail_serialized)
    cocktail.remote_photo_url = cocktail_json["strDrinkThumb"]
    cocktail.instructions = cock["drinks"][0]["strInstructions"]
    range = (1..15)
    range.each do |i|
      dose = Dose.new
      dose.cocktail = cocktail
      ing_name = cock["drinks"][0]["strIngredient#{i}"] unless cock["drinks"][0]["strIngredient#{i}"] == ""
      ing = Ingredient.where(name: ing_name)
      dose.ingredient = ing[0]
      dose.description = cock["drinks"][0]["strMeasure#{i}"] unless ing[0].nil?
      dose.destroy if dose.ingredient.nil?
      dose.save
    end


    cocktail.save
  end
  p i += 1
end
