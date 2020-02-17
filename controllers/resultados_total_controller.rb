class ResultadosTotalController < ApplicationController
  before_action :authenticate_admin!, only: [:show]
  include ApplicationHelper

  def show
    render 'pages/resultados_total'
  end

  def pesquisar
   @data_ini = params[:data_ini]
   @data_fim = params[:data_fim]
   @data_ate = params[:data_ate]
   @pdata_ate = (params[:data_ate].to_date+1.days).to_s
   @curso = params[:curso]
   @cursos = params[:cursos]
   @coluna = params[:coluna]

if @coluna == "ia_satisf_palestras" || @coluna == 'ia_satisf_oficina'|| @coluna == 'ia_satisf_minicurso'|| @coluna == 'ia_satisf_seminario'|| @coluna == 'ia_satisf_vis_tec'|| @coluna == 'ia_satisf_estagio'|| @coluna == 'ia_satisf_prat_prof'|| @coluna == 'ia_satisf_bolsas'

    if @curso == "true"
      asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)

        @osQuestionariosSuf =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(@coluna+' IN (?)', 'Suficiente').where(realizado: true).where("updated_at <= (?)", @data_ate).group(:nome_curso).count 
        @osQuestionariosReg =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(@coluna+' IN (?)', 'Regular').where(realizado: true).where("updated_at <= (?)", @data_ate).group(:nome_curso).count 
        @osQuestionariosIns =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(@coluna+' IN (?)', 'Insuficiente').where(realizado: true).where("updated_at <= (?)", @data_ate).group(:nome_curso).count 
        @osQuestionariosNun =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(@coluna+' IN (?)', 'Nunca soube da oferta').where(realizado: true).where("updated_at <= (?)", @data_ate).group(:nome_curso).count 

    else
      asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
        @osQuestionariosSuf =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(@coluna+' IN (?)', 'Suficiente').where(realizado: true).where("updated_at <= (?)", @data_ate).group(:nome_curso).count 
        @osQuestionariosReg =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(@coluna+' IN (?)', 'Regular').where(realizado: true).where("updated_at <= (?)", @data_ate).group(:nome_curso).count 
        @osQuestionariosIns =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(@coluna+' IN (?)', 'Insuficiente').where(realizado: true).where("updated_at <= (?)", @data_ate).group(:nome_curso).count 
        @osQuestionariosNun =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(@coluna+' IN (?)', 'Nunca soube da oferta').where(realizado: true).where("updated_at <= (?)", @data_ate).group(:nome_curso).count 

    end


#osQuestionariosSuf =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(ia_satisf_palestras: 'Suficiente').where.not(saip_esta_inst: nil).group(:nome_curso).count 

     respond_to do |format|
      format.json { render json: [{name: 'Suficiente', data: @osQuestionariosSuf},{name: 'Regular', data: @osQuestionariosReg},{name: 'Insuficiente', data: @osQuestionariosIns},{name: 'Nunca soube da oferta', data: @osQuestionariosNun}]}
    end

end


if @coluna == "saip_esta_inst" || @coluna == "ia_est_dur_curso" || @coluna == "ia_nessec_atlzr" || @coluna == "saip_trab_atual" || @coluna == "saip_trab_area" || @coluna == "saip_ja_trab" 

   if @curso == "true"
    asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: @cursos).first.nome)
    else
      asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
    end

    @osQuestionariosSIM =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(@coluna+' IN (?)','Sim').where(realizado: true).where("updated_at <= (?)", @data_ate).group(:nome_curso).count 
        @osQuestionariosNAO =     QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(@coluna+' IN (?)','Não').where(realizado: true).where("updated_at <= (?)", @data_ate).group(:nome_curso).count 

     respond_to do |format|
      format.json { render json: [{name: 'Sim', data: @osQuestionariosSIM },{name: 'Não', data: @osQuestionariosNAO}]}
    end

  end

 if @coluna == 'ig_genero'
 if @curso == "true"
      asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
      osQuestionarios = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(realizado: true).where("updated_at <= (?)", @data_ate)
    else
      asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
       osQuestionarios = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(realizado: true).where("updated_at <= (?)", @data_ate)
    end
      osEgressos = Egresso.none
      osQuestionarios.each do |oQuestionario|
       oEgresso = Egresso.where(id: oQuestionario.egresso_id)
       osEgressos += oEgresso
      end
      @osGenerosM = Egresso.where(id: osEgressos.map(&:id)).where(genero: 'Masculino').group(:genero).count
      @osGenerosF = Egresso.where(id: osEgressos.map(&:id)).where(genero: 'Feminino').group(:genero).count
      @osGenerosO = Egresso.where(id: osEgressos.map(&:id)).where(genero: 'Outro').group(:genero).count

      @osGenerosM[:Masculino] = (100*(@osGenerosM['Masculino'].to_f/(@osGenerosM['Masculino'].to_f+ @osGenerosF['Feminino'].to_f+ @osGenerosO['Outro'].to_f))*100).round/100.0
      @osGenerosF[:Feminino] = (100*(@osGenerosF['Feminino'].to_f/(@osGenerosM['Masculino'].to_f+ @osGenerosF['Feminino'].to_f+ @osGenerosO['Outro'].to_f))*100).round/100.0
      @osGenerosO[:Outro] = (100*(@osGenerosO['Outro'].to_f/(@osGenerosM['Masculino'].to_f+ @osGenerosF['Feminino'].to_f+ @osGenerosO['Outro'].to_f))*100).round/100.0

      respond_to do |format|
       format.json { render json: [{name: 'Masculino', data: @osGenerosM },{name: 'Feminino', data: @osGenerosF },{name: 'Outros', data: @osGenerosO }]}
      end
  end

 if @coluna == 'ig_cor'
 if @curso == "true"
      asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
      osQuestionarios = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(realizado: true).where("updated_at <= (?)", @data_ate)
 else
      asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
      osQuestionarios = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(realizado: true).where("updated_at <= (?)", @data_ate)
 end
      osEgressos = Egresso.none
      osQuestionarios.each do |oQuestionario|
       oEgresso = Egresso.where(id: oQuestionario.egresso_id)
       osEgressos += oEgresso
      end

      @asCoresBr = Egresso.where(id: osEgressos.map(&:id)).where(link: 'Branca').group(:link).count
      @asCoresAM = Egresso.where(id: osEgressos.map(&:id)).where(link: 'Amarela').group(:link).count
      @asCoresPa = Egresso.where(id: osEgressos.map(&:id)).where(link: 'Parda').group(:link).count
      @asCoresPr = Egresso.where(id: osEgressos.map(&:id)).where(link: 'Preta').group(:link).count
      @asCoresIn = Egresso.where(id: osEgressos.map(&:id)).where(link: 'Indígena').group(:link).count
      @asCoresNd = Egresso.where(id: osEgressos.map(&:id)).where(link: 'Não declarada').group(:link).count
      
      
      respond_to do |format|
       format.json { render json: [{name: 'Branca', data: @asCoresBr },{name: 'Amarela', data: @asCoresAm },{name: 'Parda', data: @asCoresPa },{name: 'Preta', data: @asCoresPr },{name: 'Indígena', data: @asCoresIn },{name: 'Não declarada', data: @asCoresNd }]}
      end
  end


  if @coluna == 'ig_idade'
  
   if @curso == "true"
      asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
      osQuestionarios = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(realizado: true).where("updated_at <= (?)", @data_ate)
      

    else
      asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
       osQuestionarios = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(realizado: true).where("updated_at <= (?)", @data_ate)
      
    end
      osEgressos = Egresso.none
      osQuestionarios.each do |oQuestionario|
       oEgresso = Egresso.where(id: oQuestionario.egresso_id)
       osEgressos += oEgresso
      end
       faixa1 = 0
       faixa2 = 0
       faixa3 = 0
       faixa4 = 0
       faixa5 = 0
       faixa6 = 0
       osEgressos.each do |oEgresso|
        if age(oEgresso.data_nasc) <= 18
          faixa1 += 1
        end
        if age(oEgresso.data_nasc) > 18 && age(oEgresso.data_nasc) <= 20
          faixa2 += 1
        end
        if age(oEgresso.data_nasc) > 21 && age(oEgresso.data_nasc) <= 25
          faixa3 += 1
        end
        if age(oEgresso.data_nasc) > 25 && age(oEgresso.data_nasc) <= 30
          faixa4 += 1
        end
        if age(oEgresso.data_nasc) > 30 && age(oEgresso.data_nasc) <= 40
          faixa5 +=1
        end
        if age(oEgresso.data_nasc) > 40
          faixa6 +=1
        end
       end
    
       @asFaixas = [["Menor de 18", faixa1],["Entre 18 e 20 anos", faixa2],["Entre 20 e 25 anos", faixa3],["Entre 25 e 30 anos", faixa4],["Entre 30 e 40 anos", faixa5],["Maior de 40 anos", faixa6]]

     respond_to do |format|
      format.json { render json: [{name: 'Faixa Etária', data: @asFaixas }]}
    end

  end

if @coluna == "saip_pq_nunca" || @coluna == "saip_pq_nao_esta" || @coluna ==  "saip_prim_oport"

    if @curso == "true"
      asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: @cursos).first.nome)
       osQuestionarios = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(realizado: true).where("updated_at <= (?)", @data_ate)
    else
      asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
      osQuestionarios = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(realizado: true).where("updated_at <= (?)", @data_ate)
    end

    @osSaip_pq_nunca =  osQuestionarios.where.not(@coluna+" IN (?)", "").group(@coluna).count

    respond_to do |format|
      format.json { render json: [{name: 'Motivo', data: @osSaip_pq_nunca }]}
    end

end

end

end

