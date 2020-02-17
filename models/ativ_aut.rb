class AtivAut < ApplicationRecord
  belongs_to :egresso, :class_name => 'Egresso'
  belongs_to :ramo_ativ, :class_name => 'RamoAtiv'

   validates :ramo_ativ, presence: true, allow_nil: true
	self.primary_key = :id
end
