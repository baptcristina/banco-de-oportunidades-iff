class RamoAtiv < ApplicationRecord
		self.primary_key = :id
		has_one :empresa,  :dependent => :destroy , :foreign_key => "ramo_ativ_id"
end
