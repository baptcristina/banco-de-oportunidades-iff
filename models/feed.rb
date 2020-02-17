class Feed < ApplicationRecord
  belongs_to :divulgacao, class_name: 'Divulgacao', optional: true
	self.primary_key = :id
end
