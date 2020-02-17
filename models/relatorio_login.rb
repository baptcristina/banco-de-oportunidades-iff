class RelatorioLogin < ApplicationRecord
  belongs_to :email
  	self.primary_key = :id
end
