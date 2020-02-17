module ApplicationHelper


def is_number? string
  true if Float(string) rescue false
end

def sair_todos
      redirect_to :back, alert: "Esta sessão não é permitida para este usuário." 
end 

def checar_egresso_super
    id = params[:egresso_id]
    if current_admin.try(:super?) || current_user.try(:egresso).try(:id) ==  Egresso.where(id: id).first.try(:id) 
      return
    else
      sair_todos
    end
end



def checar_empresa_super
    id = params[:empresa_id]
    if current_admin.try(:super?) || current_empressa.try(:empresa).try(:id) == Empresa.where(id: id).first.try(:id) 
      return
    else
      sair_todos
    end
end

def checar_egresso_empresa_super_show_empresa
    id = params[:empresa_id]
    if current_admin.try(:super?) || user_signed_in?|| current_empressa.try(:empresa).try(:id) == Empresa.where(id: id).first.try(:id) 
      return
    else
      sair_todos
    end
end


def checar_egresso_empresa_super
     id = params[:egresso_id] 
    if current_admin.try(:super?) || current_user.try(:egresso).try(:id) ==  Egresso.where(id: id).first.try(:id) || empressa_signed_in?
      return
    else
      sair_todos
    end
end

def checar_empresa_super_esp
  id = params[:empresa_id]
  if current_admin.try(:super?) || empressa_signed_in?
    return
  else
    sair_todos
  end
end

def checar_super
    if current_admin.try(:super?) || (controller_name == 'questionario_egressos' && current_admin.try(:email)  == 'pesquisador@iff.edu.br' ) || (controller_name == 'resultados_parcial'  && current_admin.try(:email)  == 'pesquisador@iff.edu.br' ) || (controller_name == 'resultados_subjetivo'  && current_admin.try(:email)  == 'pesquisador@iff.edu.br' ) || (controller_name == 'resultados_total'  && current_admin.try(:email)  == 'pesquisador@iff.edu.br' ) || (controller_name == 'resultados_subjetivo'  && current_admin.try(:email)  == 'pesquisador@iff.edu.br' )  || (controller_name == 'totais_egressos_import'  && current_admin.try(:email)  == 'pesquisador@iff.edu.br' || (current_admin.try(:email)  == 'pesquisador@iff.edu.br') )  || (controller_name == 'cursos'  && current_admin.try(:email)  == 'pesquisador@iff.edu.br' ) 
      return
    else
      sair_todos
    end
end

def checar_super_agencia
    if current_admin.try(:super?) || (controller_name == 'divulgacaos' && current_admin.try(:email)  == 'agencia@iff.edu.br' ) || (controller_name == 'feeds' && current_admin.try(:email)  == 'agencia@iff.edu.br' )|| (controller_name == 'infos' && current_admin.try(:email)  == 'agencia@iff.edu.br' )|| (controller_name == 'ferramentas' && current_admin.try(:email)  == 'registro@iff.edu.br' ) || (controller_name == 'relatorio_total' && current_admin.try(:email)  == 'agencia@iff.edu.br' ) ||
      return
    else
      sair_todos
    end
end


def checar_super_registro
    if current_admin.try(:super?) || (controller_name == 'cursos' && current_admin.try(:email)  == 'registro@iff.edu.br' ) || (controller_name == 'titulacaos' && current_admin.try(:email)  == 'registro@iff.edu.br' ) || (controller_name == 'cursos' && current_admin.try(:email)  == 'pesquisador@iff.edu.br' && action_name == 'show')
      return
    else
      sair_todos
    end
end


def checar_adm_super
    if admin_signed_in?
      return
    else
      sair_todos
    end
end


def age(dob)
  now = Time.zone.now.utc.to_date
  now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
end


def age_questionario(dob,update)
  now = update.to_date
  now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
end


def valor_formatado(number)
      number_to_currency number,
      unit: "R$ ",
      separator: ",",
      delimiter: "."
end


def tem_avaliacao
  formacads = FormAcad.where(egresso_id: current_user.egresso_id).where(habilitado: false)
  formacads.each do |formacad|
   if formacad.data_fim.present? 
      if QuestionarioEgresso.where(form_acad_id: formacad.id).first == nil
        questionario_egresso = QuestionarioEgresso.new(nome_curso: formacad.nome_curso, realizado: false, form_acad_id:  formacad.id, egresso_id: current_user.egresso_id)
        questionario_egresso.save(:validate => false)
        if formacad.data_fim <= 1.year.ago
          return true
        end
      elsif QuestionarioEgresso.where(form_acad_id: formacad.id).first.realizado == false
        if formacad.data_fim <= 1.year.ago
          return true
        end
      end
   end
  end
      return false
end


def alguma_avaliacao
  formacads = FormAcad.where(egresso_id: current_user.egresso_id)
    formacads.each do |formacad|
      osQuestionarios = QuestionarioEgresso.where(form_acad_id: formacad.id).where(realizado: false)
      if not(osQuestionarios.nil?)&& not(formacad.nome_curso == 'Técnico em Mecânica' && formacad.semestre_letivo.include?('2014'))
      osQuestionarios.each do |oQuestionario| 
        if  oQuestionario.realizado == false
          return oQuestionario.form_acad_id
        end
      end
      end
    end
end

 def tem_oportunidades(number)
    @contador = 0
    egresso_id = number
    @valores = Idioma.where(egresso_id: current_user.egresso_id).map(&:valor)
    @descricoes = Idioma.where(egresso_id: current_user.egresso_id).map(&:descricao)
    @oportunidades_final = Oportunidade.none       
    @forms = FormAcad.where(egresso_id: egresso_id).where(habilitado: false)
    @forms.each do |forma|
      catch :counter do
        filtro = "nome_curso like '%"+forma.nome_curso+"%'"
        @oportunidades_validas = Oportunidade.where("fim_oferta >= (?)", Time.zone.now).where(curso: Titulacao.where(id: Curso.where(nome: forma.nome_curso).first.try(:titulacao_id)).first.try(:titulo)).where.not(situacao: 'Cancelada').where.not(situacao: 'Expirada').or(Oportunidade.where("fim_oferta >= (?)", Time.zone.now).where(curso: Curso.where(nome: forma.nome_curso).where(titulacao_id: nil).first.try(:nome)).where.not(situacao: 'Cancelada').where.not(situacao: 'Expirada'))
        @oport = []
        @oportunidades_validas.each do |oportunidade|
          if not(oportunidade.panoconclusao_fim == nil || oportunidade.panoconclusao_inicio == nil)
            @oport << Oportunidade.where(id: oportunidade.id).where("panoconclusao_inicio <= (?) AND panoconclusao_fim >= (?)", FormAcad.where(egresso_id: current_user.egresso_id).where(filtro).where(habilitado: false).first.data_fim,FormAcad.where(egresso_id: current_user.egresso_id).where(filtro).where(habilitado: false).first.data_fim).map(&:id)
            puts @oport.count
          end
          if (oportunidade.panoconclusao_fim == nil)&& not(oportunidade.panoconclusao_inicio == nil)
            @oport << Oportunidade.where(id: oportunidade.id).where("panoconclusao_inicio <= (?)", FormAcad.where(egresso_id: current_user.egresso_id).where(filtro).where(habilitado: false).first.data_fim).map(&:id)
          end
          if not(oportunidade.panoconclusao_fim == nil)&& (oportunidade.panoconclusao_inicio == nil)
            @oport << Oportunidade.where(id: oportunidade.id).where("panoconclusao_fim >= (?)", FormAcad.where(egresso_id: current_user.egresso_id).where(filtro).where(habilitado: false).first.data_fim).map(&:id)
          end
          if (oportunidade.panoconclusao_fim == nil && oportunidade.panoconclusao_inicio == nil)
            @oport << Oportunidade.where(id: oportunidade.id).where(panoconclusao_inicio: nil).where(panoconclusao_fim: nil).map(&:id)
          end
        end
      @array_ids = []
      (1..@oport.length).each do |i|
        @array_ids = @array_ids + @oport[i-1]
      end
      @oportunidades_validas_filtradas_1 = Oportunidade.where(id: @array_ids)
      @oportunidades_final = Oportunidade.none

        if @descricoes.length == 0
          @oportunidades_final = @oportunidades_final+@oportunidades_validas_filtradas_1.where(pidioma: "").where(ptipo: nil)
          begin
           if @oportunidades_final.count > 0
             @contador = 1
             throw :counter if @contador == 1
           end
           rescue => e
          end

        else

        (0..@descricoes.length-1).each do |i|
          @oportunidades_final = @oportunidades_final + @oportunidades_validas_filtradas_1.where(pidioma: @descricoes[i]).where('ptipo <= (?)', @valores[i]).or(@oportunidades_validas_filtradas_1.where(pidioma: @descricoes[i]).where(ptipo: nil)).or(@oportunidades_validas_filtradas_1.where(pidioma: "").where(ptipo: nil))
          begin
           if @oportunidades_final.count > 0
             @contador = 1
             throw :counter if @contador == 1
           end
           rescue => e
           end
         end
      end
    end
    end
 
    if @contador == 1
      return true
    else
      return false
    end
  end

  def numero_oportunidades(number)
    contador = 0
    egresso_id = number
    @forms = FormAcad.where(egresso_id: egresso_id).first
    filtro = "curso like '%"+@forms.nome_curso+"%'"
    @oportunidades = Oportunidade.where(filtro)
    @oportunidades.each do |oportunidade|
      if oportunidade.fim_oferta <= Time.zone.now
        contador+=1
      end
  end
  return contador
  end



  def mudar_idioma(string)
    if string == '1'
      return 'Básico'
    end
      if string == '2'
      return 'Intermediário'
    end
       if string == '3'
      return 'Avançado'
    end
       if string == '4'
      return 'Fluente'
    end
  end


  def mudar_cidade(estado,cidade_numero)
    i=0
    if not (estado == '')
     @estados_lista.each do |x|

        if not(x.include? estado.to_s)
           i= i+1
        else
           break
        end
     end
     if not(cidade_numero == '')
      j = 0
      @cidades_lista[i].each do |h|
       if not(h[0].to_s == cidade_numero.to_s)
        j = j+1
       else
        break
       end
      end
      return @cidades_lista[i][j][1]
     else
      return ''
     end
    else
     return ''
    end
  end
  
  def checar_local_inscricao(local)
      require 'uri'

      if (local =~ URI::regexp)
        return '2'
      else  
        if (local  =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
          return '3'
        else
          return '1'
        end
      end
  end

end
