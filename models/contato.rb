class Contato < ApplicationRecord
  belongs_to :empresa, :class_name => 'Empresa'
  belongs_to :oportunidade, :class_name => 'Oportunidade' , optional: true

  validates :oportunidade, presence: true, allow_nil: true
	self.primary_key = :id
end


