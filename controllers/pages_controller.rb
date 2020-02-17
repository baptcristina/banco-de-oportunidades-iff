class PagesController < ApplicationController

include ApplicationHelper

	def show
		render 'pages/home'
	end

 
def pesquisar
   @data_ini = params[:data_ini]
   @data_fim = params[:data_fim]
   @curso = params[:curso]
   @cursos = params[:cursos]
   @coluna = params[:coluna]

if @coluna == "1" 

	  if @curso == "true"
	   	asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
      @Formados = asFormAcads.group_by_year(:data_fim, format: "%Y").count


      @Trabalhando = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @cursos).first.nome).where(saip_trab_atual: 'Sim')
      @Trabalhando.each do |oTrabalho|
        oTrabalho.auxiliar = asFormAcads.where(id: oTrabalho.form_acad_id).first.data_fim.to_date.strftime("%Y")
        oTrabalho.save!
      end
      @Trabalhando = @Trabalhando.group(:auxiliar).count
    end

    

#osQuestionariosSuf =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(ia_satisf_palestras: 'Suficiente').where.not(saip_esta_inst: nil).group(:nome_curso).count 

     respond_to do |format|
      format.json { render json: [{name: 'Formados', data: @Formados},{name: 'Empregados na Área', data: @Trabalhando}]}
    end
end
end

  def analytics
    render 'pages/analytics'
  end

end
