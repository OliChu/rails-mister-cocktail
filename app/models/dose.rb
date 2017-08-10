class Dose < ApplicationRecord
  belongs_to :ingredient
  belongs_to :cocktail
  validates :description, :ingredient_id, presence: true, uniqueness: { scope: [:cocktail_id, :ingredient_id] }
end
