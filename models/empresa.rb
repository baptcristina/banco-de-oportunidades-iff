class Empresa < ApplicationRecord
  self.primary_key = :id
  attr_accessor :skip_fields_validation
  before_validation :skip_ramo

  def skip_ramo
    if self.skip_fields_validation == false
      @ramo_flag = true
    else
      @ramo_flag = false
    end
  end

  belongs_to :ramo_ativ, :class_name => 'RamoAtiv' , required: @ramo_flag

  has_many :oportunidades,  :dependent => :destroy , :foreign_key => "empresa_id"
  has_one :empressa,  :dependent => :destroy , :foreign_key => "empresa_id"
  #validates :ramo_ativ_id, presence: {message: "Ramo de Atividade não pode estar em branco."}
  mount_uploader :logo, ImagemUploader
  has_many :contatos,  :dependent => :destroy , :foreign_key => "empresa_id"

  validates :cnpj, :cnpj => true
  validates :email, :cnpj,  :uniqueness => true
  validates_presence_of :razao_social
  validates_presence_of :estado, unless: :skip_fields_validation
  validates_presence_of :cidade, unless: :skip_fields_validation
  validates_presence_of :ramo_ativ_id, unless: :skip_fields_validation
  validates_presence_of :nome_fantasia, unless: :skip_fields_validation
  



require 'csv'

def self.importempresa(file)
	
    erro = 0
    numero = 0

 	
      relatorio = Relatorio.new
      relatorio.tipo = "Importação de empresas do banco de dados da Agência de Oportunidades - (Cancelada)"
      relatorio.save!
      id_relatorio = relatorio.id


    CSV.foreach(file.path) do |row|

      cnpj= row[0]
      razao_social = row[1]
      nome_fantasia = row[2]
      ramo_ativ = row[3]
      site = row[4]
      email = row[5]
      endereco = row[6]
      cep = row[7]
      cidade = row[8]
      estado = row[9]


      if cnpj == nil || email == nil
        erro+= 1
      end
        numero+= 1

      if Empresa.where(cnpj: cnpj).present?
      else
          empresa  = Empresa.new(cnpj: cnpj, razao_social: razao_social, nome_fantasia: nome_fantasia, site: site, email: email, endereco: endereco, cep: cep, cidade: cidade, estado: estado)
          empresa.save
      end


      if  email.present?
          
         if Empressa.where(email: email.downcase).present?

         else
            aEmpresa = Empresa.where(cnpj: cnpj).first
            begin
            Empressa.create!(email: email.downcase, password: "123456", password_confirmation: "123456",empresa_id: aEmpresa.id)
            rescue  ActiveRecord::RecordInvalid => invalid
             puts invalid.record.errors
             erro += 1
            rescue

            end 
         end
      end
          relatorio.tipo = "Importação de empresas do banco de dados da Agência de Oportunidades"
          relatorio.quantidade_total = numero
          relatorio.quantidade_erros = erro
          relatorio.save!

  end

end
end



