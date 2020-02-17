class ResultadosIndicadoresController < ApplicationController
  before_action :authenticate_admin!, only: [:show]
  include ApplicationHelper
 
  
  def show
    render 'pages/resultados_indicadores'
  end

  def pesquisar
   @data_ini = params[:data_ini]
   @data_fim = params[:data_fim]
   @pdata_ate = params[:pdata_ate] 
   @data_ate = (params[:pdata_ate].to_date+1.days).to_s
   @curso = params[:curso]
   @cursos = params[:cursos]
   @coluna = params[:coluna]

if @coluna == "1" 

    if @curso == "true"
      asFormAcads = FormAcad.where(habilitado: false).where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
      @Formados2 = asFormAcads.where(nome_curso: Curso.where(id: @cursos).first.nome)

     osQuestionariosFiltrados = QuestionarioEgresso.where(form_acad_id: @Formados2.ids).where(realizado: true).where("updated_at <= (?)", @data_ate)


      #@Formados = FormAcad.where(egresso_id: osQuestionariosFiltrados.map(&:egresso_id))
      @Formados = @Formados2

     @FormadosHash = @Formados.group_by_year(:data_fim, format: "%Y").count

     @Trabalhando = osQuestionariosFiltrados.where(saip_trab_area: 'Sim')
      @Trabalhando.each do |oTrabalho|
        oTrabalho.auxiliar = FormAcad.where(id: FormAcad.where(habilitado: false).where(egresso_id: oTrabalho.egresso_id).first.id).first.data_fim.to_date.strftime("%Y")
        oTrabalho.save!
      end
      @Trabalhando = @Trabalhando.group(:auxiliar).count


    inicio = @data_ini.to_date.strftime("%Y").to_i
    fim = @data_fim.to_date.strftime("%Y").to_i
    array  = []
    i= 0
    (inicio..fim).each do |bla|
      array[i] = bla
      i+=1
    end
    @Trabalhando1= {}
    @Trabalhando2= {}
    @FormadosHash1 = {}
    (inicio..fim).each do |bla|
        @Trabalhando1[bla.to_s] = @Trabalhando[bla.to_s].to_f
       @Trabalhando2[bla.to_s] =  100*(@Trabalhando[bla.to_s].to_f/@FormadosHash[bla.to_s].to_f).to_d.round(4)
        @FormadosHash1[bla.to_s] = @FormadosHash[bla.to_s].to_f
       if  @Trabalhando[bla.to_s] == nil
         @Trabalhando1[bla.to_s] = 0
      end
      if @FormadosHash1[bla.to_s] == nil 
          @FormadosHash1[bla.to_s] = 0
      end
       if @Trabalhando2[bla.to_s].nan? || @Trabalhando2[bla.to_s] == nil || @FormadosHash[bla.to_s].to_f == 0
        @Trabalhando2[bla.to_s] = 0
      end
    end


    end

  

#osQuestionariosSuf =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(ia_satisf_palestras: 'Suficiente').where.not(saip_esta_inst: nil).group(:nome_curso).count 

     respond_to do |format|
      format.json { render json: [{ name: 'Total de Egressos Importados', data: @FormadosHash1},{ name: 'Trabalhando na área', data: @Trabalhando1},{name: 'Taxa de Empregabilidade', data: @Trabalhando2}]}
    end

end


##Faltou

if @coluna =="2"
  if @curso == "true"

      asFormAcads = FormAcad.where(habilitado: false).where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
      @Formados = asFormAcads.group_by_year(:data_fim, format: "%Y").count
      @Questionarios = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(realizado: true).where("updated_at <= (?)", @data_ate)

      @Formados2 = asFormAcads.where(nome_curso: Curso.where(id: @cursos).first.nome)
      osQuestionariosFiltrados = QuestionarioEgresso.where(form_acad_id: @Formados2.ids).where(realizado: true).where("updated_at <= (?)", @data_ate)
      

      @Palestras = @Questionarios.where(ia_satisf_palestras: 'Suficiente').or(@Questionarios.where(ia_satisf_palestras: 'Regular'))
      @Palestras.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save!
      end
      @Palestras = @Palestras.group(:auxiliar).count
      @PalestrasTot = @Questionarios.where.not(ia_satisf_palestras: nil)
      @PalestrasTot.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save!
      end
      @PalestrasTot = @PalestrasTot.group(:auxiliar).count


      @oficinas = @Questionarios.where(ia_satisf_oficina: 'Suficiente').or(@Questionarios.where(ia_satisf_oficina: 'Regular'))
      @oficinas.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save!
      end
      @oficinas = @oficinas.group(:auxiliar).count
      @oficinasTot = @Questionarios.where.not(ia_satisf_oficina: nil)
      @oficinasTot.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save!
      end
      @oficinasTot = @oficinasTot.group(:auxiliar).count

      @minicurso = @Questionarios.where(ia_satisf_minicurso: 'Suficiente').or(@Questionarios.where(ia_satisf_minicurso: 'Regular'))
      @minicurso.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save!
      end
      @minicurso = @minicurso.group(:auxiliar).count
      @minicursoTot = @Questionarios.where.not(ia_satisf_minicurso: nil)
      @minicursoTot.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save!
      end
      @minicursoTot = @minicursoTot.group(:auxiliar).count

      @seminario = @Questionarios.where(ia_satisf_seminario: 'Suficiente').or(@Questionarios.where(ia_satisf_seminario: 'Regular'))
      @seminario.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save!
      end
      @seminario = @seminario.group(:auxiliar).count
      @seminarioTot = @Questionarios.where.not(ia_satisf_seminario: nil)
      @seminarioTot.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save!
      end
      @seminarioTot = @seminarioTot.group(:auxiliar).count

      @vis_tec = @Questionarios.where(ia_satisf_vis_tec: 'Suficiente').or(@Questionarios.where(ia_satisf_vis_tec: 'Regular'))
      @vis_tec.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save!
      end
      @vis_tec = @vis_tec.group(:auxiliar).count
      @vistecTot = @Questionarios.where.not(ia_satisf_vis_tec: nil)
      @vistecTot.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save!
      end
      @vistecTot = @vistecTot.group(:auxiliar).count

      @estagio = @Questionarios.where(ia_satisf_estagio: 'Suficiente').or(@Questionarios.where(ia_satisf_estagio: 'Regular'))
      @estagio.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save!
      end
      @estagio = @estagio.group(:auxiliar).count
      @estagioTot = @Questionarios.where.not(ia_satisf_estagio: nil)
      @estagioTot.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save!
      end
      @estagioTot = @estagioTot.group(:auxiliar).count


      @pratprof = @Questionarios.where(ia_satisf_prat_prof: 'Suficiente').or(@Questionarios.where(ia_satisf_prat_prof: 'Regular'))
      @pratprof.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save!
      end
      @pratprof = @pratprof.group(:auxiliar).count
      @pratprofTot = @Questionarios.where.not(ia_satisf_prat_prof: nil)
      @pratprofTot.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save!
      end
      @pratprofTot = @pratprofTot.group(:auxiliar).count

      @bolsas = @Questionarios.where(ia_satisf_bolsas: 'Suficiente').or(@Questionarios.where(ia_satisf_bolsas: 'Regular'))
      @bolsas.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save!
      end
      @bolsas = @bolsas.group(:auxiliar).count
      @bolsasTot = @Questionarios.where.not(ia_satisf_bolsas: nil)
      @bolsasTot.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save!
      end
      @bolsasTot = @bolsasTot.group(:auxiliar).count


 @Trabalhando = osQuestionariosFiltrados.where.not(ia_satisf_palestras: nil).or(osQuestionariosFiltrados.where.not(ia_satisf_oficina: nil).or(osQuestionariosFiltrados.where.not(ia_satisf_minicurso: nil).or(osQuestionariosFiltrados.where.not(ia_satisf_seminario: nil).or(osQuestionariosFiltrados.where.not(ia_satisf_vis_tec: nil).or(osQuestionariosFiltrados.where.not(ia_satisf_estagio: nil).or(osQuestionariosFiltrados.where.not(ia_satisf_prat_prof: nil).or(osQuestionariosFiltrados.where.not(ia_satisf_bolsas: nil))))))))
      @Trabalhando.each do |oTrabalho|
        oTrabalho.auxiliar = asFormAcads.where(id: oTrabalho.form_acad_id).first.data_fim.to_date.strftime("%Y")
        oTrabalho.save!
      end
      @Trabalhando = @Trabalhando.group(:auxiliar).count


    inicio = @data_ini.to_date.strftime("%Y").to_i
    fim = @data_fim.to_date.strftime("%Y").to_i
    array  = []
    i= 0
    (inicio..fim).each do |bla|
      array[i] = bla
      i+=1
    end

    (inicio..fim).each do |bla|
       @PalestrasTot[bla.to_s] =  100*((@Palestras[bla.to_s].to_f/@PalestrasTot[bla.to_s].to_f)).round(2)
        @oficinasTot[bla.to_s] =  100*((@oficinas[bla.to_s].to_f/@oficinasTot[bla.to_s].to_f)).round(2)
         @minicursoTot[bla.to_s] =  100*((@minicurso[bla.to_s].to_f/@minicursoTot[bla.to_s].to_f)).round(2)
          @seminarioTot[bla.to_s] =  100*((@seminario[bla.to_s].to_f/@seminarioTot[bla.to_s].to_f)).round(2)
           @vistecTot[bla.to_s] =  100*((@vis_tec[bla.to_s].to_f/@vistecTot[bla.to_s].to_f)).round(2)
            @estagioTot[bla.to_s] =  100*((@estagio[bla.to_s].to_f/@estagioTot[bla.to_s].to_f)).round(2)
             @pratprofTot[bla.to_s] =  100*((@pratprof[bla.to_s].to_f/@pratprofTot[bla.to_s].to_f)).round(2)
              @bolsasTot[bla.to_s] =  100*((@bolsas[bla.to_s].to_f/@bolsasTot[bla.to_s].to_f)).round(2)
            @Trabalhando[bla.to_s] =  100*((@Palestras[bla.to_s].to_f+ @oficinas[bla.to_s].to_f + @minicurso[bla.to_s].to_f + @seminario[bla.to_s].to_f+@vis_tec[bla.to_s].to_f+@estagio[bla.to_s].to_f+@pratprof[bla.to_s].to_f+@bolsas[bla.to_s].to_f)/(8*@Trabalhando[bla.to_s].to_f)).round(4)
    end

    respond_to do |format|
      format.json { render json: [{name: 'Palestras', data: @PalestrasTot},{name: 'Oficinas', data: @oficinasTot},{name: 'Minicursos', data: @minicursoTot},{name: 'Seminários', data: @seminarioTot},{name: 'Visitas Técnicas', data: @vistecTot},{name: 'Estágios', data: @estagioTot},{name: 'Pratica Profissional', data: @pratprofTot},{name: 'Bolsas', data: @bolsasTot},{name: 'Taxa de Satisfação', data: @Trabalhando}]}
    end

  end

end


end





end



