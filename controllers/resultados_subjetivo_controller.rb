class ResultadosSubjetivoController < ApplicationController
before_action :authenticate_admin!, only: [:show]
  include ApplicationHelper
  require 'json'

  def show
    render 'pages/resultados_subjetivo'
  end

  def pesquisar
   @data_ini = params[:data_ini]
   @data_fim = params[:data_fim]
   @data_fim = params[:data_fim]
   @pdata_ate = params[:pdata_ate] 
   @data_ate = (params[:pdata_ate].to_date+1.days).to_s
   @curso = params[:curso]
   @cursos = params[:cursos]
   @coluna = params[:coluna]

if @coluna == "saip_texto2" || @coluna == 'saip_texto1' || @coluna == 'ia_fazer_atlzr' || @coluna == 'saip_pq_back' || @coluna == 'ia_empresa_pq_sim'|| @coluna == 'saip_pqnao_back'|| @coluna == 'ia_empresa_pq_nao' || @coluna == 'nao_trab_area_pq_nunca' || @coluna == 'nao_trab_area_pq_nao'
    if @curso == "true"
      if  @coluna == 'nao_trab_area_pq_nunca' || @coluna == 'nao_trab_area_pq_nao' || @coluna == "saip_texto2" || @coluna == 'saip_texto1'
        asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: @cursos).first.nome)
        if @coluna == 'nao_trab_area_pq_nunca'
          @osQuestionariosTexto = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(saip_trab_area: 'Não').where( saip_ja_trab: 'Não').where('saip_texto2 IS NOT NULL')
        end
        if @coluna == 'nao_trab_area_pq_nao'
          @osQuestionariosTexto = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(saip_trab_area: 'Não').where( saip_ja_trab: 'Sim').where('saip_texto1 IS NOT NULL')
        end
        if @coluna == 'saip_texto1'
          @osQuestionariosTexto = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(saip_trab_atual: 'Não').where( saip_ja_trab: 'Sim').where('saip_texto1 IS NOT NULL')
        end
        if @coluna == 'saip_texto2'
          @osQuestionariosTexto = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(saip_trab_atual: 'Não').where( saip_ja_trab: 'Não').where('saip_texto2 IS NOT NULL')
        end
      else      
         asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: @cursos).first.nome)
         @osQuestionariosTexto = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(@coluna+' IS NOT NULL').where(realizado: true).where("updated_at <= (?)", @data_ate)
      end
   else
        if (current_admin.email.include? "coord") || (current_admin.email.include? "dir")
          asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: Coord.where(admin_id: current_admin.id).map(&:curso_id)).map(&:nome))
        else
          asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
        end
        @osQuestionariosTexto =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(@coluna+' IS NOT NULL').where(realizado: true).where("updated_at <= (?)", @data_ate)
    end
          frase = Hash.new
          frase.store(0,"")
          i=1
          @osQuestionariosTexto.each do |quest|
            if @coluna == 'nao_trab_area_pq_nao'
              frase.store(i,quest.saip_texto1)
              i+=1
            end
            if @coluna == 'nao_trab_area_pq_nunca'
              frase.store(i,quest.saip_texto2)
              i+=1
            end
            
            if @coluna == 'saip_texto2'
              frase.store(i,quest.saip_texto2)
              i+=1
            end
            if @coluna == 'saip_texto1' 
              frase.store(i,quest.saip_texto1)
              i+=1
            end
            if @coluna == 'ia_fazer_atlzr'
              frase.store(i,quest.ia_fazer_atlzr)
              i+=1
            end
            if @coluna == 'saip_pq_back' 
              frase.store(i,quest.saip_pq_back)
              i+=1
            end
            
            if @coluna == 'ia_empresa_pq_sim'
              frase.store(i,quest.ia_empresa_pq_sim)
              i+=1
            end
            
            if @coluna == 'saip_pqnao_back' 
              frase.store(i,quest.saip_pqnao_back)
              i+=1
            end
            
            if @coluna == 'ia_empresa_pq_nao' 
              frase.store(i,quest.ia_empresa_pq_nao)
              i+=1
            end
            
          end


      frase.each do |key, array|
         puts "#{key}-----"
       puts array
      end

     respond_to do |format|
      format.json { render json: frase}
    end


end


end


end
