class Relatorio < ApplicationRecord
	has_many :egressos , :foreign_key => "egresso_id"
	self.primary_key = :id




end
