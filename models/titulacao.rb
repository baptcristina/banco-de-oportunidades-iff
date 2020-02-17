class Titulacao < ApplicationRecord
 has_many :cursos, foreign_key: 'titulacao_id', :dependent => :restrict_with_error
end
