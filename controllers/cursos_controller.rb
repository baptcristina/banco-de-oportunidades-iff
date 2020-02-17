class CursosController < ApplicationController
  devise_group :person, contains: [:admin]
  before_action :authenticate_person!
  before_action :set_curso, only: [:show, :edit, :update, :destroy]

  # GET /cursos
    # GET /cursos.json
  

  include ApplicationHelper

  def index
    checar_super_registro 
    @pnome = params[:pcurso]
    filtro = "nome like '%"+@pnome.to_s+"%'"
    osCursos = Curso.where(filtro)
    @cursos = osCursos.paginate(page: params[:page], per_page: 5).order("nome")

  end

  # GET /cursos/1
  # GET /cursos/1.json
  def show
    checar_super_agencia
    @data_fim = params[:data_fim]
    @data_ini = params[:data_ini]
    @data_ate = params[:data_ate]
    @curso = Curso.where(id: params[:id]).first if params[:id]

    respond_to do |format|
      format.html
      format.pdf do
          pdf = ResultadoPdf.new(@curso, view_context, @data_ini, @data_fim, @data_ate)
          send_data pdf.render, filename: 'Resultado-'+@curso.nome.to_s+' - '+@data_ini.to_s+' - '+@data_fim.to_s+' - '+@data_ate.to_s+'.pdf', :width =>
          pdf.bounds.width,
          type: 'application/pdf', disposition: :inline, :page_size => "A4",
          :page_layout => :portrait
      end
    end
  end

  # GET /cursos/new
  def new
    checar_super_registro
    @curso = Curso.new
  end

  # GET /cursos/1/edit
  def edit
 checar_super_registro
  end

  # POST /cursos
  # POST /cursos.json

  def create
    @curso = Curso.new(curso_params)

    respond_to do |format|
      if @curso.save
        format.html { redirect_to cursos_path, notice: 'Curso criado com sucesso.' }
        format.json { render cursos_path, status: :created, location: cursos_path }
      else
        format.html { render :new }
        format.json { render json: @curso.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cursos/1
  # PATCH/PUT /cursos/1.json
  def update

    respond_to do |format|
      if @curso.update(curso_params)
        format.html { redirect_to cursos_path, notice: 'Curso atualizado com sucesso.' }
        format.json { render cursos_path, status: :ok, location: cursos_path }
      else
        format.html { render :edit }
        format.json { render json: @curso.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cursos/1
  # DELETE /cursos/1.json
  def destroy
    form_acad = FormAcad.where(nome_curso: @curso.nome)
    if form_acad.count > 0
      redirect_to cursos_path, alert: 'Não é possível excluir o curso.' 
    else
      @curso.destroy
      respond_to do |format|
        format.html { redirect_to cursos_path, notice: 'Curso excluído com sucesso.' }
        format.json { head :no_content }
      end
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_curso
      @curso = Curso.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def curso_params
      params.require(:curso).permit(:nome , :hidden, :titulacao_id)
    end
end



