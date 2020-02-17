class TotaisEgressosImportController < ApplicationController
  before_action :authenticate_admin!, only: [:show]
  include ApplicationHelper
 require 'pp'
  
  def show
    if params[:id] == 'pesquisar4'
      pesquisar4
    else
      render 'pages/totais_egressos_import'
    end
  end



  def pesquisar4
      @data_ini = params[:data_ini]
      @data_fim = params[:data_fim]
      @pdata_ate = params[:pdata_ate] 
      @data_ate = (params[:pdata_ate].to_date+1.days).to_s

      @filtro_nome4 = " nome_curso like '%Tecnologia em%'"
      @osCursos4 = FormAcad.where(@filtro_nome4).where(habilitado: false).where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).order('nome_curso')
      osQuestionarios4 = QuestionarioEgresso.where(form_acad_id: @osCursos4.ids).where(@filtro_nome4).where(realizado: true).where("updated_at <= (?)", @data_ate)
      @osCursos4 = @osCursos4.where.not(id: osQuestionarios4.map(&:form_acad_id))
      respond_to do |format|
        format.json { render json: [{name: 'Não Respondidos', data: @osCursos4.group(:nome_curso).count},{name: 'Respondidos', data: osQuestionarios4.group(:nome_curso).count}]}
      end
  end



  def pesquisar
      @data_ini = params[:data_ini]
      @data_fim = params[:data_fim]
      @pdata_ate = params[:pdata_ate] 
      @data_ate = (params[:pdata_ate].to_date+1.days).to_s

      @filtro_nome = " nome_curso like '%Técnico%'"
      @osCursos = FormAcad.where(@filtro_nome).where(habilitado: false).where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).order('nome_curso')
      osQuestionarios = QuestionarioEgresso.where(form_acad_id: @osCursos.ids).where(@filtro_nome).where("updated_at <= (?)", @data_ate).where(realizado: true)
      @osCursos = @osCursos.where.not(id: osQuestionarios.map(&:form_acad_id))

     respond_to do |format|
        format.json { render json: [{name: 'Não Respondidos', data: @osCursos.group(:nome_curso).count},{name: 'Respondidos', data: osQuestionarios.group(:nome_curso).count}]}
      end
    
  end

  def pesquisar2
      @data_ini = params[:data_ini]
      @data_fim = params[:data_fim]
      @pdata_ate = params[:pdata_ate] 
      @data_ate = (params[:pdata_ate].to_date+1.days).to_s

      @filtro_nome2 = " nome_curso like '%Licenciatura%'"
      @osCursos2 = FormAcad.where(@filtro_nome2).where(habilitado: false).where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).order('nome_curso')
      osQuestionarios2 = QuestionarioEgresso.where(form_acad_id: @osCursos2.ids).where(realizado: true).where(@filtro_nome2).where("updated_at <= (?)", @data_ate)
      @osCursos2 = @osCursos2.where.not(id: osQuestionarios2.map(&:form_acad_id))
      respond_to do |format|
        format.json { render json: [{name: 'Não Respondidos', data: @osCursos2.group(:nome_curso).count},{name: 'Respondidos', data: osQuestionarios2.group(:nome_curso).count}]}
      end
  end
  
  def pesquisar3
      @data_ini = params[:data_ini]
      @data_fim = params[:data_fim]
      @pdata_ate = params[:pdata_ate] 
      @data_ate = (params[:pdata_ate].to_date+1.days).to_s

      @filtro_nome3 = " nome_curso like '%Bacharelado%'"
      @osCursos3 = FormAcad.where(@filtro_nome3).where(habilitado: false).where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).order('nome_curso')
      osQuestionarios3 = QuestionarioEgresso.where(form_acad_id: @osCursos3.ids).where(realizado: true).where(@filtro_nome3).where("updated_at <= (?)", @data_ate)
      @osCursos3 = @osCursos3.where.not(id: osQuestionarios3.map(&:form_acad_id))
      respond_to do |format|
        format.json { render json: [{name: 'Não Respondidos', data: @osCursos3.group(:nome_curso).count},{name: 'Respondidos', data: osQuestionarios3.group(:nome_curso).count}]}
      end
  end


end
