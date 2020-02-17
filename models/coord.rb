class Coord < ApplicationRecord
  belongs_to :admin
  belongs_to :curso

  validates :curso_id, uniqueness: { scope: :admin_id }

end
