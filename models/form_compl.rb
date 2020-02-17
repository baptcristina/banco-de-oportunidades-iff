class FormCompl < ApplicationRecord
  belongs_to :egresso, :class_name => 'Egresso'
      validates_numericality_of :carga, :on => :create 
      validates_numericality_of :carga, :on => :update ,  message: "Digitar valores númericos apenas" 
      	self.primary_key = :id
end
