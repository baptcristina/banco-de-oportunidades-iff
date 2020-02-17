class ExpProf < ApplicationRecord

  belongs_to :egresso, :class_name => 'Egresso'
  belongs_to :ramo_ativ, :class_name => 'RamoAtiv'
	self.primary_key = :id
end