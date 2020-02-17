  class Egresso < ApplicationRecord

  attr_accessor :skip_fields_validation
  before_validation :skip_validation

    def skip_validation
    if self.skip_fields_validation == true
      @validation_flag = true
    else
      @validation_flag = false
    end
  end

has_one :user ,  :dependent => :destroy , :foreign_key => "egresso_id"
has_many :form_acads ,  :dependent => :destroy , :foreign_key => "egresso_id"
has_many :form_compls ,  :dependent => :destroy , :foreign_key => "egresso_id"
has_many :ativ_auts ,  :dependent => :destroy , :foreign_key => "egresso_id"
has_many :exp_profs ,  :dependent => :destroy , :foreign_key => "egresso_id"
belongs_to :relatorio, :class_name => 'Relatorio' , optional: true
has_many :compets ,  :dependent => :destroy , :foreign_key => "egresso_id"
has_many :idiomas ,  :dependent => :destroy , :foreign_key => "egresso_id"
has_many :questionario_egressos ,  :dependent => :destroy , :foreign_key => "egresso_id"

  validates :relatorio, presence: true, allow_nil: true


filterrific(
  default_filter_params: { sorted_by: 'created_at_desc' },
  available_filters: [
    :sorted_by,
    :search_query,
    :with_country_id,
    :with_created_at_gte
  ]
)


mount_uploader :foto, ImagemUploader

require 'csv'


    validates_presence_of :data_nasc, unless: :skip_fields_validation
    validates_presence_of :genero, unless: :skip_fields_validation       
    validates_presence_of :est_conjugal, unless: :skip_fields_validation 
    validates_presence_of :link       , unless: :skip_fields_validation


  def self.import(file)

    erro = 0
    numero = 0
    duplicidade = 0


    relatorio = Relatorio.new
    nome_arquivo = file.original_filename
    relatorio.tipo = "Importação de egressos do banco de dados do Registro Acadêmico Cancelada  - " + nome_arquivo
    relatorio.save!
    id_relatorio = relatorio.id

    Egresso.all.each do |egresso|
      if  egresso.cpf.length > 14
        egresso.cpf[0] = "" 
        egresso.save(validate: false)
        puts egresso.cpf
      end
    end

    CSV.foreach(file.path) do |row| # Começo do for

      cpf = row[0]
      if  cpf.length > 14
         cpf[0] = ""
      end
      nome_completo = row[1]
      data_nasc = row[2]
      genero = row[3]
      raca = row [4]
      est_conjugal = row [5]
      email_princ = row[6]
      curso = row[7]
      data_inic = row[8]
      data_final = row[9]
      semestre_letivo = row[10] 
      

      if Curso.where(nome: curso).count > 0 && row.length == 11  # Curso existe no banco e número de dados está certo?
    
        if not email_princ.nil? # Se email não for nulo 
          email_princ = email_princ.downcase.gsub(/\s+/, "") # E-mail downcase e retira espaços
        end

        if not (cpf ==nil || nome_completo ==nil || curso ==nil || data_inic ==nil)   # Se Nenhum destes campos forem nulos

          if (data_final == nil || data_final == "")
              erro+= 1
          else
            if not(email_princ =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
              erro+= 1
            end
            if Egresso.where(cpf: cpf).present? #Se egresso está presente?
              # Atualizar Email Cadastral
              egresso = Egresso.where(cpf: cpf).first
              if (email_princ =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
                egresso.email_princ = email_princ 
              end
              egresso.skip_fields_validation = true
              egresso.save! 
              egresso_id = egresso.id
              @asform_acads = FormAcad.where(egresso_id: egresso_id)


              #Verifica Se existe a Formacao no sistema e Acusa Duplicidade
              if (@asform_acads.where(inst_ofert: "Instituto Federal Fluminense - Campus Campos Centro").where(habilitado: false).where(nome_curso: curso).where(data_fim: data_inic.to_date).where(data_fim: data_final.to_date).nil?) || @asform_acads.count == 0 || @asform_acads == nil # Não tem aquela formação acadêmica?
              puts 'Coleção de Formação Acadêmica Nula' 
                if (semestre_letivo == nil || semestre_letivo == "" || semestre_letivo == " ") # Se semestre letivo for nulo?
                puts 'Semestre Letivo nulo' 
                  FormAcad.create!(relatorio_id: relatorio.id, egresso_id: egresso_id, inst_ofert: "Instituto Federal Fluminense - Campus Campos Centro", nome_curso: curso, data_ini: data_inic, data_fim: data_final, semestre_letivo: 'Sem turma', habilitado: "0")
                else
                  FormAcad.create!(relatorio_id: relatorio.id, egresso_id: egresso_id, inst_ofert: "Instituto Federal Fluminense - Campus Campos Centro", nome_curso: curso, data_ini: data_inic, data_fim: data_final, semestre_letivo: semestre_letivo, habilitado: "0")
                end
                puts 'Formação Adicionada'
                numero +=1
              else
                puts 'Coleção Não-Nula'
                puts @asform_acads.where(inst_ofert: "Instituto Federal Fluminense - Campus Campos Centro").where(habilitado: false).where(nome_curso: curso).where(data_ini: data_inic.to_date).where(data_fim: data_final.to_date).where(semestre_letivo: semestre_letivo).count
                if @asform_acads.where(inst_ofert: "Instituto Federal Fluminense - Campus Campos Centro").where(habilitado: false).where(nome_curso: curso).where(data_ini: data_inic.to_date).where(data_fim: data_final.to_date).count >= 1
                  puts 'DUplicidade Encontrada'
                  duplicidade+=1
                else
                  puts 'Informação não-duplicada'
                  if (semestre_letivo == nil || semestre_letivo == "" || semestre_letivo == " ")
                    FormAcad.create!(relatorio_id: relatorio.id, egresso_id: egresso_id, inst_ofert: "Instituto Federal Fluminense - Campus Campos Centro", nome_curso: curso, data_ini: data_inic, data_fim: data_final, semestre_letivo: 'Sem turma', habilitado: "0")
                  else
                    FormAcad.create!(relatorio_id: relatorio.id, egresso_id: egresso_id, inst_ofert: "Instituto Federal Fluminense - Campus Campos Centro", nome_curso: curso, data_ini: data_inic, data_fim: data_final, semestre_letivo: semestre_letivo, habilitado: "0")
                  end
                  numero +=1          
                end
              end

            #Se egresso não está presente?  
            else

              #Gerar INformações através dos dados do CSV
              if genero == "F" 
                genero = "Feminino" 
              else 
                if genero == "M"
                  genero = "Masculino"
                else
                  if not(genero == "Outro")
                    genero = ""
                  end
                end
              end

              if raca == "Morena" || raca == "Outros"
                raca= nil
              elsif raca == "Negra"
                raca ="Preta"
              end

              if est_conjugal == "Casado" || est_conjugal == "União Estável"
                est_conjugal = "Casado(a) / União Estável"
              elsif est_conjugal == "Separado" || est_conjugal == "Divorciado"
                est_conjugal = "Separado(a) / Desquitado(a) / Divorciado(a)"
              elsif est_conjugal == "Solteiro"
                est_conjugal = "Solteiro(a)"
              elsif est_conjugal == "Viúvo"
                est_conjugal = "Viúvo(a)"
              elsif est_conjugal == "Outro"
                est_conjugal = ""
              end

              #Criar o Egresso
              if  (email_princ =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i) &&  User.find_by(email: email_princ).nil?
                Egresso.create!(cpf: cpf,data_nasc: data_nasc, nome_completo: nome_completo, genero: genero, link: raca, est_conjugal: est_conjugal, email_princ: email_princ, relatorio: relatorio, primacesso: false, skip_fields_validation: true)
              else
                Egresso.create!(cpf: cpf,data_nasc: data_nasc, nome_completo: nome_completo, genero: genero, link: raca, est_conjugal: est_conjugal, relatorio: relatorio, primacesso: false, skip_fields_validation: true)
              end
              egresso = Egresso.where(cpf: cpf).first
              egresso_id = egresso.id

              #Criar a Formação
              if (semestre_letivo == nil || semestre_letivo == "" || semestre_letivo == " ")
                FormAcad.create!(relatorio_id: relatorio.id, egresso_id: egresso_id, inst_ofert: "Instituto Federal Fluminense - Campus Campos Centro", nome_curso: curso, data_ini: data_inic, data_fim: data_final, semestre_letivo: 'Sem turma', habilitado: "0")
              else
                FormAcad.create!(relatorio_id: relatorio.id, egresso_id: egresso_id, inst_ofert: "Instituto Federal Fluminense - Campus Campos Centro", nome_curso: curso, data_ini: data_inic, data_fim: data_final, semestre_letivo: semestre_letivo, habilitado: "0")
              end
              numero += 1

              # Criar Usuário
              if  (email_princ =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i) &&  User.find_by(email: email_princ).nil? #Se email válido e sem usuário no sistema
                oEgresso = Egresso.where(cpf: cpf).first
                User.create!(email: email_princ, password: "123456", password_confirmation: "123456",egresso_id: oEgresso.id, tipo_usuario: "1")
              end
            end
            relatorio.quantidade_total = numero 
            relatorio.quantidade_erros = erro
            relatorio.arquivo = nome_arquivo
            relatorio.save!
          end
        end
      else # Se dados são inválidos
        relatorio.tipo = "Dados do Registro Acadêmico inválidos - "+ nome_arquivo
        relatorio.save!
        return relatorio.id
      end # fim if dados certos count 
    end #fim do for
      relatorio.tipo = "Importação de egressos do banco de dados do Registro Acadêmico - " + nome_arquivo
      relatorio.nome_arquivo = duplicidade
      relatorio.quantidade_total = numero
      relatorio.quantidade_erros = erro
      relatorio.arquivo = nome_arquivo
      relatorio.save!
      return relatorio.id
  end  # fim def 


end