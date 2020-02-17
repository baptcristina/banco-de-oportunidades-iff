class Oportunidade < ApplicationRecord
  belongs_to :empresa, :class_name => 'Empresa'
  has_one :contato, :foreign_key => "contato_id"
  after_initialize :init # acontece após um new e antes de salvar , poderia fazer na migration direto com o defalt vigente


    self.primary_key = :id
    validates_presence_of :empresa_id
    validates_presence_of :curso       
    validates_presence_of :fim_oferta 
    validates_presence_of :ini_oferta 
    validates_presence_of :cargo
    validates_presence_of :local_inscricao


    def init
      self.situacao ||= "Vigente" # não executa se houver valor armazenado
    end
              
end