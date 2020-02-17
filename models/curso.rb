class Curso < ApplicationRecord
 has_many :questionario_egressos, foreign_key: 'saip_curso_atual'
	self.primary_key = :id
    validates :titulacao_id, presence: true, allow_nil: true
    belongs_to :titulacao, :class_name => 'Titulacao' , optional: true


end
