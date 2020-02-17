class Idioma < ApplicationRecord
  belongs_to :egresso, :class_name => 'Egresso'
  	self.primary_key = :id
end
