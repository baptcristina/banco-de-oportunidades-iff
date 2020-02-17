class Configuraco < ApplicationRecord
	  belongs_to :admin, :class_name => 'Admin' 
	self.primary_key = :id
end
