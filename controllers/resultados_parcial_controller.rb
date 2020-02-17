class ResultadosParcialController < ApplicationController
  before_action :authenticate_admin!, only: [:show]
  include ApplicationHelper

  def show
    render 'pages/resultados_parcial'
  end

  def pesquisar
   @data_ini = params[:data_ini]
   @data_fim = params[:data_fim]
   @pdata_ate = params[:pdata_ate] 
   @data_ate = (params[:pdata_ate].to_date+1.days).to_s
   @curso = params[:curso]
   @cursos = params[:cursos]
   @coluna = params[:coluna]

if @coluna == "ia_satisf_palestras" || @coluna == 'ia_satisf_oficina'|| @coluna == 'ia_satisf_minicurso'|| @coluna == 'ia_satisf_seminario'|| @coluna == 'ia_satisf_vis_tec'|| @coluna == 'ia_satisf_estagio'|| @coluna == 'ia_satisf_prat_prof'|| @coluna == 'ia_satisf_bolsas'

    if @curso == "true"
      asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: @cursos).first.nome)
        @osQuestionariosSuf =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(@coluna+' IN (?)', 'Suficiente').where(realizado: true).where("updated_at <= (?)", @data_ate).group(@coluna).count 
        @osQuestionariosReg =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(@coluna+' IN (?)', 'Regular').where(realizado: true).where("updated_at <= (?)", @data_ate).group(@coluna).count 
        @osQuestionariosIns =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(@coluna+' IN (?)', 'Insuficiente').where(realizado: true).where("updated_at <= (?)", @data_ate).group(@coluna).count 
        @osQuestionariosNun =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(@coluna+' IN (?)', 'Nunca soube da oferta').where(realizado: true).where("updated_at <= (?)", @data_ate).group(@coluna).count 
    else
      if (current_admin.email.include? "coord") || (current_admin.email.include? "dir")
        asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: Coord.where(admin_id: current_admin.id).map(&:curso_id)).map(&:nome))
      else
        asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
      end
        @osQuestionariosSuf =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(@coluna+' IN (?)', 'Suficiente').where(realizado: true).where("updated_at <= (?)", @data_ate).group(@coluna).count 
        @osQuestionariosReg =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(@coluna+' IN (?)', 'Regular').where(realizado: true).where("updated_at <= (?)", @data_ate).group(@coluna).count 
        @osQuestionariosIns =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(@coluna+' IN (?)', 'Insuficiente').where(realizado: true).where("updated_at <= (?)", @data_ate).group(@coluna).count 
        @osQuestionariosNun =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(@coluna+' IN (?)', 'Nunca soube da oferta').where(realizado: true).where("updated_at <= (?)", @data_ate).group(@coluna).count 

    end
        total = @osQuestionariosSuf['Suficiente'].to_f + @osQuestionariosReg['Regular'].to_f + @osQuestionariosIns['Insuficiente'].to_f + @osQuestionariosNun['Nunca soube da oferta'].to_f
        if total != 0 
        @osQuestionariosSuf['Suficiente'] = 100*(@osQuestionariosSuf['Suficiente'].to_f/total).to_d.round(4)
        @osQuestionariosReg['Regular'] = 100*(@osQuestionariosReg['Regular'].to_f/total).to_d.round(4)
        @osQuestionariosIns['Insuficiente'] = 100*(@osQuestionariosIns['Insuficiente'].to_f/total).to_d.round(4)
        @osQuestionariosNun['Nunca soube da oferta'] = 100*(@osQuestionariosNun['Nunca soube da oferta'].to_f/total).to_d.round(4)
      else
        @osQuestionariosSuf['Suficiente'] = 0
        @osQuestionariosReg['Regular'] = 0
        @osQuestionariosIns['Insuficiente'] = 0
        @osQuestionariosNun['Nunca soube da oferta'] = 0
      end


#osQuestionariosSuf =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(ia_satisf_palestras: 'Suficiente').where.not(saip_esta_inst: nil).group(:nome_curso).count 

     respond_to do |format|
      format.json { render json: [{name: 'Suficiente', data: @osQuestionariosSuf},{name: 'Regular', data: @osQuestionariosReg},{name: 'Insuficiente', data: @osQuestionariosIns},{name: 'Nunca soube da oferta', data: @osQuestionariosNun}]}
    end

end

if @coluna == "ia_avalia_curso" 

    if @curso == "true"
      asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: @cursos).first.nome)
        @osQuestionariosExc =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(@coluna+' IN (?)', 'Excelente').where(realizado: true).where("updated_at <= (?)", @data_ate).group(@coluna).count 
        @osQuestionariosBom =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(@coluna+' IN (?)', 'Bom').where(realizado: true).where("updated_at <= (?)", @data_ate).group(@coluna).count 
        @osQuestionariosReg =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(@coluna+' IN (?)', 'Regular').where(realizado: true).where("updated_at <= (?)", @data_ate).group(@coluna).count 
        @osQuestionariosRuim =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(@coluna+' IN (?)', 'Ruim').where(realizado: true).where("updated_at <= (?)", @data_ate).group(@coluna).count 
        @osQuestionariosPess =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(@coluna+' IN (?)', 'Pessimo').where(realizado: true).where("updated_at <= (?)", @data_ate).group(@coluna).count 

    else
      if (current_admin.email.include? "coord") || (current_admin.email.include? "dir")
        asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: Coord.where(admin_id: current_admin.id).map(&:curso_id)).map(&:nome))
      else
        asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
      end
        @osQuestionariosExc =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(@coluna+' IN (?)', 'Excelente').where(realizado: true).where("updated_at <= (?)", @data_ate).group(@coluna).count 
        @osQuestionariosBom =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(@coluna+' IN (?)', 'Bom').where(realizado: true).where("updated_at <= (?)", @data_ate).group(@coluna).count 
        @osQuestionariosReg =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(@coluna+' IN (?)', 'Regular').where(realizado: true).where("updated_at <= (?)", @data_ate).group(@coluna).count 
        @osQuestionariosRuim =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(@coluna+' IN (?)', 'Ruim').where(realizado: true).where("updated_at <= (?)", @data_ate).group(@coluna).count
        @osQuestionariosPess =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(@coluna+' IN (?)', 'Pessimo').where(realizado: true).where("updated_at <= (?)", @data_ate).group(@coluna).count

    end
        total = @osQuestionariosExc['Excelente'].to_f + @osQuestionariosBom['Bom'].to_f + @osQuestionariosReg['Regular'].to_f + @osQuestionariosRuim['Ruim'].to_f + @osQuestionariosPess['Pessimo'].to_f
        if total != 0 
        @osQuestionariosExc['Excelente'] = 100*(@osQuestionariosExc['Excelente'].to_f/total).to_d.round(4)
        @osQuestionariosBom['Bom'] = 100*(@osQuestionariosBom['Bom'].to_f/total).to_d.round(4)
        @osQuestionariosReg['Regular'] = 100*(@osQuestionariosReg['Regular'].to_f/total).to_d.round(4)
        @osQuestionariosRuim['Ruim'] = 100*(@osQuestionariosRuim['Ruim'].to_f/total).to_d.round(4)
        @osQuestionariosPess['Pessimo'] = 100*(@osQuestionariosPess['Pessimo'].to_f/total).to_d.round(4)
      else
        @osQuestionariosExc['Excelente'] = 0
        @osQuestionariosBom['Bom'] = 0
        @osQuestionariosReg['Regular'] = 0
        @osQuestionariosRuim['Ruim'] = 0
        @osQuestionariosPess['Pessimo'] = 0
      end

     respond_to do |format|
      format.json { render json: [{name: 'Excelente', data: @osQuestionariosExc},{name: 'Bom', data: @osQuestionariosBom},{name: 'Regular', data: @osQuestionariosReg},{name: 'Ruim', data: @osQuestionariosRuim},{name: 'Pessimo', data: @osQuestionariosPess}]}
    end

end


if @coluna == 'ig_genero'
 if @curso == "true"
      asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: @cursos).first.nome)
      osQuestionarios = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(realizado: true).where("updated_at <= (?)", @data_ate)
    else
       if (current_admin.email.include? "coord") || (current_admin.email.include? "dir")
        asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: Coord.where(admin_id: current_admin.id).map(&:curso_id)).map(&:nome))
      else
        asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
      end
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
        total = @osGenerosM['Masculino'].to_f+ @osGenerosF['Feminino'].to_f+ @osGenerosO['Outro'].to_f  
      if total != 0

        @osGenerosM[:Masculino] = (10000*(@osGenerosM['Masculino'].to_f/total)).round/100.0
        @osGenerosF[:Feminino] = (10000*(@osGenerosF['Feminino'].to_f/total)).round/100.0
        @osGenerosO[:Outro] = (10000*(@osGenerosO['Outro'].to_f/total)).round/100.0
      else
        @osGenerosM[:Masculino] = 0
        @osGenerosF[:Feminino]  = 0 
        @osGenerosO[:Outro]  = 0
      end

      respond_to do |format|
       format.json { render json: [{name: 'Masculino', data: @osGenerosM },{name: 'Feminino', data: @osGenerosF },{name: 'Outros', data: @osGenerosO }]}
      end
end

if @coluna == 'ig_cor'
 if @curso == "true"
      asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: @cursos).first.nome)
      osQuestionarios = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(realizado: true).where("updated_at <= (?)", @data_ate)
 else
      if (current_admin.email.include? "coord") || (current_admin.email.include? "dir")
        asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: Coord.where(admin_id: current_admin.id).map(&:curso_id)).map(&:nome))
      else
        asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
      end
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
      total = @asCoresNd['Não declarada'].to_f + @asCoresIn['Indígena'].to_f + @asCoresPr['Preta'].to_f + @asCoresPa['Parda'].to_f + @asCoresAM['Amarela'].to_f + @asCoresBr['Branca'].to_f
      if total != 0
      @asCoresBr['Branca'] =  100*(@asCoresBr['Branca'].to_f/total).to_d.round(4)
      @asCoresAM['Amarela'] =  100*(@asCoresAM['Amarela'].to_f/total).to_d.round(4)
      @asCoresPa['Parda'] =  100*(@asCoresPa['Parda'].to_f/total).to_d.round(4)
      @asCoresPr['Preta'] =  100*(@asCoresPr['Preta'].to_f/total).to_d.round(4)
      @asCoresIn['Indígena'] =  100*(@asCoresIn['Indígena'].to_f/total).to_d.round(4)
      @asCoresNd['Não declarada'] =  100*(@asCoresNd['Não declarada'].to_f/total).to_d.round(4)
      else
        @asCoresBr['Branca'] = 0
      @asCoresAM['Amarela'] = 0
      @asCoresPa['Parda'] =  0
      @asCoresPr['Preta'] =  0
      @asCoresIn['Indígena'] =  0
      @asCoresNd['Não declarada']
      end
      respond_to do |format|
       format.json { render json: [{name: 'Branca', data: @asCoresBr },{name: 'Amarela', data: @asCoresAM },{name: 'Parda', data: @asCoresPa },{name: 'Preta', data: @asCoresPr },{name: 'Indígena', data: @asCoresIn },{name: 'Não declarada', data: @asCoresNd }]}
      end
end

if @coluna == 'ig_est_conjug'
 if @curso == "true"
      asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: @cursos).first.nome)
      osQuestionarios = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(realizado: true).where("updated_at <= (?)", @data_ate)
 else
      if (current_admin.email.include? "coord") || (current_admin.email.include? "dir")
        asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: Coord.where(admin_id: current_admin.id).map(&:curso_id)).map(&:nome))
      else
        asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
      end
      osQuestionarios = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(realizado: true).where("updated_at <= (?)", @data_ate)
 end
      osEgressos = Egresso.none
      osQuestionarios.each do |oQuestionario|
       oEgresso = Egresso.where(id: oQuestionario.egresso_id)
       osEgressos += oEgresso
      end

      @osEstConjSol = Egresso.where(id: osEgressos.map(&:id)).where(est_conjugal: 'Solteiro(a)').group(:est_conjugal).count
      @osEstConjSep = Egresso.where(id: osEgressos.map(&:id)).where(est_conjugal: 'Separado(a) / Desquitado(a) / Divorciado(a)').group(:est_conjugal).count
      @osEstConjCas = Egresso.where(id: osEgressos.map(&:id)).where(est_conjugal: 'Casado(a) / União Estável').group(:est_conjugal).count
      @osEstConjViu = Egresso.where(id: osEgressos.map(&:id)).where(est_conjugal: 'Viúvo(a)').group(:est_conjugal).count
      total = @osEstConjSol['Solteiro(a)'].to_f + @osEstConjViu['Viúvo(a)'].to_f+@osEstConjSep['Separado(a) / Desquitado(a) / Divorciado(a)'].to_f+@osEstConjCas['Casado(a) / União Estável'].to_f
      if total != 0
      @osEstConjSol['Solteiro(a)'] = 100*(@osEstConjSol['Solteiro(a)'].to_f/total).to_d.round(4)
      @osEstConjSep['Separado(a) / Desquitado(a) / Divorciado(a)'] = 100*(@osEstConjSep['Separado(a) / Desquitado(a) / Divorciado(a)'].to_f/total).to_d.round(4)
      @osEstConjCas['Casado(a) / União Estável'] = 100*(@osEstConjCas['Casado(a) / União Estável'].to_f/total).to_d.round(4)
      @osEstConjViu['Viúvo(a)'] = 100*(@osEstConjViu['Viúvo(a)'].to_f/total).to_d.round(4)

      else
        @osEstConjSol['Solteiro(a)'] = 0
      @osEstConjSep['Separado(a) / Desquitado(a) / Divorciado(a)'] = 0
      @osEstConjCas['Casado(a) / União Estável'] = 0
      @osEstConjViu['Viúvo(a)'] = 0 
      end
      respond_to do |format|
       format.json { render json: [{name: 'Solteiro(a)', data: @osEstConjSol },{name: 'Separado(a) / Desquitado(a) / Divorciado(a)', data: @osEstConjSep },{name: 'Casado(a) / União Estável', data: @osEstConjCas },{name: 'Viúvo(a)', data: @osEstConjViu }]}
      end
end

if @coluna == 'ig_idade'
  
   if @curso == "true"
      asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: @cursos).first.nome)
      osQuestionarios = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(realizado: true).where("updated_at <= (?)", @data_ate)
    else
      if (current_admin.email.include? "coord") || (current_admin.email.include? "dir")
        asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: Coord.where(admin_id: current_admin.id).map(&:curso_id)).map(&:nome))
      else
        asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
      end
       osQuestionarios = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(realizado: true).where("updated_at <= (?)", @data_ate)
      
    end
       faixa1 = 0
       faixa2 = 0
       faixa3 = 0
       faixa4 = 0
       faixa5 = 0
       faixa6 = 0
       osQuestionarios.each do |oQuestionario|
        if age_questionario(oQuestionario.egresso.data_nasc,oQuestionario.form_acad.data_fim) < 18
          faixa1 += 1
        end
        if age_questionario(oQuestionario.egresso.data_nasc,oQuestionario.form_acad.data_fim) >= 18 && age_questionario(oQuestionario.egresso.data_nasc,oQuestionario.form_acad.data_fim) <= 20
          faixa2 += 1
        end
        if age_questionario(oQuestionario.egresso.data_nasc,oQuestionario.form_acad.data_fim) > 20 && age_questionario(oQuestionario.egresso.data_nasc,oQuestionario.form_acad.data_fim) <= 25
          faixa3 += 1
        end
        if age_questionario(oQuestionario.egresso.data_nasc,oQuestionario.form_acad.data_fim) > 25 && age_questionario(oQuestionario.egresso.data_nasc,oQuestionario.form_acad.data_fim) <= 30
          faixa4 += 1
        end
        if age_questionario(oQuestionario.egresso.data_nasc,oQuestionario.form_acad.data_fim) > 30 && age_questionario(oQuestionario.egresso.data_nasc,oQuestionario.form_acad.data_fim) <= 40
          faixa5 +=1
        end
        if age_questionario(oQuestionario.egresso.data_nasc,oQuestionario.form_acad.data_fim) > 40
          faixa6 +=1
        end
       end
       total = faixa1 + faixa2 + faixa3 + faixa4 +  faixa5 + faixa6
       if total != 0 
       faixa1 = 100*(faixa1.to_f/total.to_f).to_d.round(4)
       faixa2 = 100*(faixa2.to_f/total.to_f).to_d.round(4)
       faixa3 = 100*(faixa3.to_f/total.to_f).to_d.round(4)
       faixa4 = 100*(faixa4.to_f/total.to_f).to_d.round(4)
       faixa5 = 100*(faixa5.to_f/total.to_f).to_d.round(4)
       faixa6 = 100*(faixa6.to_f/total.to_f).to_d.round(4)
     else
       faixa1 = 0
       faixa2 = 0
       faixa3 = 0
       faixa4 = 0
       faixa5 = 0
       faixa6 = 0
     end
       @asFaixas = [["Menor de 18 anos", faixa1],["Entre 18 e 20 anos", faixa2],["Entre 21 e 25 anos", faixa3],["Entre 26 e 30 anos", faixa4],["Entre 31 e 40 anos", faixa5],["Maior de 40 anos", faixa6]]

     respond_to do |format|
      format.json { render json: [{name: 'Faixa Etária', data: @asFaixas }]}
    end
end





if @coluna == "saip_pq_nunca" || @coluna == "saip_vinculo"|| @coluna == "saip_pq_nao_esta" || @coluna ==  "saip_prim_oport" || @coluna == "saip_renda" || @coluna == "saip_local"
    if @curso == "true"
      asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: @cursos).first.nome)
      osQuestionarios = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(realizado: true).where("updated_at <= (?)", @data_ate)
    else
      if current_admin.email.include? "coord"
        asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: Coord.where(admin_id: current_admin.id).map(&:curso_id)).map(&:nome))
      else
        asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
      end
      osQuestionarios = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(realizado: true).where("updated_at <= (?)", @data_ate)
    end
    @osSaip_pq_nunca =  osQuestionarios.where.not(@coluna+" IN (?)", "").group(@coluna).count
    respond_to do |format|
      format.json { render json: [{name: 'Motivo', data: @osSaip_pq_nunca }]}
    end
end

if  @coluna =="saip_curso_atual"
    if @curso == "true"
      asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: @cursos).first.nome)
    else
      if (current_admin.email.include? "coord") || (current_admin.email.include? "dir")
        asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: Coord.where(admin_id: current_admin.id).map(&:curso_id)).map(&:nome))
      else
        asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
      end
    end
    @osCursos =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(realizado: true).where.not(saip_curso_atual: "").where("updated_at <= (?)", @data_ate).group(:saip_curso_atual).count 
    respond_to do |format|
     format.json { render json: [{name: 'Cursos', data: @osCursos }]}
    end
end



 if @coluna == 'saip_tempo'
 if @curso == "true"
      asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: @cursos).first.nome)
      osQuestionarios = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(realizado: true).where("updated_at <= (?)", @data_ate)
    else
      if (current_admin.email.include? "coord") || (current_admin.email.include? "dir")
        asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: Coord.where(admin_id: current_admin.id).map(&:curso_id)).map(&:nome))
      else
        asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
      end
       osQuestionarios = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(realizado: true).where("updated_at <= (?)", @data_ate)
    end
      osEgressos = Egresso.none
      osQuestionarios.each do |oQuestionario|
       oEgresso = Egresso.where(id: oQuestionario.egresso_id)
       osEgressos += oEgresso
      end
      @osTrabalhos1 = QuestionarioEgresso.where(egresso_id: osEgressos.map(&:id)).where(saip_tempo: 'Menos de 1 ano').where(realizado: true).where("updated_at <= (?)", @data_ate).group(:saip_tempo).count
      @osTrabalhos2 = QuestionarioEgresso.where(egresso_id: osEgressos.map(&:id)).where(saip_tempo: 'De 1 a 2 anos').where(realizado: true).where("updated_at <= (?)", @data_ate).group(:saip_tempo).count
      @osTrabalhos3 = QuestionarioEgresso.where(egresso_id: osEgressos.map(&:id)).where(saip_tempo: 'De 2 a 5 anos').where(realizado: true).where("updated_at <= (?)", @data_ate).group(:saip_tempo).count
      @osTrabalhos4 = QuestionarioEgresso.where(egresso_id: osEgressos.map(&:id)).where(saip_tempo: 'Mais de 5 anos').where(realizado: true).where("updated_at <= (?)", @data_ate).group(:saip_tempo).count

      respond_to do |format|
       format.json { render json: [{name: 'Menos de 1 ano', data: @osTrabalhos1 },{name: 'De 1 a 2 anos', data: @osTrabalhos2 },{name: 'De 2 a 5 anos', data: @osTrabalhos3 },{name: 'Mais de 5 anos', data: @osTrabalhos4 }]}
      end
  end





if @coluna == "saip_esta_inst" || @coluna == "ia_nessec_atlzr" || @coluna == "saip_trab_atual" || @coluna == "saip_trab_area" || @coluna == "saip_ja_trab" || @coluna == "ia_est_dur_curso"  || @coluna == "saip_back_inst"

   if @curso == "true"
      asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: @cursos).first.nome)
    else
      if (current_admin.email.include? "coord") || (current_admin.email.include? "dir")
        asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim).where(nome_curso: Curso.where(id: Coord.where(admin_id: current_admin.id).map(&:curso_id)).map(&:nome))
      else
        asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
      end
    end

    @osQuestionariosSIM =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(@coluna+' IN (?)','Sim').where(realizado: true).where("updated_at <= (?)", @data_ate).group(:nome_curso).count 
    @osQuestionariosNAO =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(@coluna+' IN (?)','Não').where(realizado: true).where("updated_at <= (?)", @data_ate).group(:nome_curso).count 

     respond_to do |format|
      format.json { render json: [{name: 'Sim', data: @osQuestionariosSIM },{name: 'Não', data: @osQuestionariosNAO}]}
    end

  end

end


end
