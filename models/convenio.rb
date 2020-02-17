class Convenio < ApplicationRecord
  belongs_to :empresa, :class_name => 'Empresa'
	self.primary_key = :id
end
