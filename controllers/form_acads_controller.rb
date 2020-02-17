class FormAcadsController < ApplicationController
  devise_group :person, contains: [:user, :admin]
  before_action :authenticate_person!
  before_action :set_form_acad, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper

  # GET /form_acads
  # GET /form_acads.json

def index
  checar_egresso_super

 if current_admin.try(:super?)
      @forms = FormAcad.all
      @pcurso = params[:pcurso]
      @pinstituicao = params[:pinstituicao]
      @pegresso = params[:pegresso]
      @turma = params[:turma]
      @pformacao = params[:pformacao]

      if not(@pcurso.present?) && (@pinstituicao.present?)
        if @pegresso.present?
          filtro_egresso = "nome_completo like '%"+@pegresso+"%'"
          osEgressos = Egresso.where(filtro_egresso)
          id = osEgressos.ids
          form_academicas  = FormAcad.where(egresso_id: id)
          filtro = "inst_ofert like '%"+@pinstituicao+"%'"          
        else
          form_academicas  = FormAcad.all
          filtro = "inst_ofert like '%"+@pinstituicao+"%'"
        end
      else
       if  not(@pinstituicao.present?) && (@pcurso.present?)
        if @pegresso.present?
          filtro_egresso = "nome_completo like '%"+@pegresso+"%'"
          osEgressos = Egresso.where(filtro_egresso)
          id = osEgressos.ids
          form_academicas  = FormAcad.where(egresso_id: id)
          filtro = "inst_ofert like '%"+@pinstituicao+"%'"            
        else
          form_academicas  = FormAcad.all
          filtro = "nome_curso like '%"+@pcurso+"%'"
        end
       else
        if  (@pcurso.present?) && (@pinstituicao.present?)
         if @pegresso.present?
            filtro_egresso = "nome_completo like '%"+@pegresso+"%'"
            osEgressos = Egresso.where(filtro_egresso)
            id = osEgressos.ids
            form_academicas  = FormAcad.where(egresso_id: id)
            filtro = "inst_ofert like '%"+@pinstituicao+"%' and nome_curso like '%"+@pcurso+"%'" 
         else
            form_academicas  = FormAcad.all
            filtro = "inst_ofert like '%"+@pinstituicao+"%' and nome_curso like '%"+@pcurso+"%'" 
         end
        else
          if not(@pcurso.present?) &&  not(@pinstituicao.present?)
            if @pegresso.present?
              filtro_egresso = "nome_completo like '%"+@pegresso+"%'"
              osEgressos = Egresso.where(filtro_egresso)
              id = osEgressos.ids
              form_academicas  = FormAcad.where(egresso_id: id)
            else
              form_academicas = FormAcad.all
            end
          end
        end
       end
      end

      if @turma.present?
        @form = form_academicas.where(filtro).where("semestre_letivo like '%"+@turma+"%'")
      else 
        @form = form_academicas.where(filtro)
      end

      if not(@pformacao == "T")
        if @pformacao == "O"
          @habilitado = "false"
        else
          @habilitado = "true"
        end
        @forms = @form.where("habilitado= "+@habilitado)
      else
        @forms = @form.where(filtro)       
      end
          @form_acads = @forms.joins(:egresso).paginate(page: params[:page], per_page: 5).order("nome_completo","nome_curso", "semestre_letivo", "data_fim DESC")
        else
          @forms  = FormAcad.where(egresso_id: params[:egresso_id])
    end
          @form_acads = @forms.joins(:egresso).paginate(page: params[:page], per_page: 5).order("nome_completo","data_fim DESC")
  end

  # GET /form_acads/1
  # GET /form_acads/1.json
  def show
    checar_egresso_super
  end

  # GET /form_acads/new
  def new
    checar_egresso_super
    @form_acad = FormAcad.new
  end

  # GET /form_acads/1/edit
  def edit
   checar_egresso_super
  end

  # POST /form_acads
  # POST /form_acads.json
  def create

    @form_acad = FormAcad.new(form_acad_params)

    respond_to do |format|
      if @form_acad.save
        format.html { redirect_to form_acads_path(@form_acad, egresso_id: current_user.egresso_id), notice: 'Nova formação acadêmica foi incluída.' }
        format.json { render :show, status: :created, location: form_acads_path }
      else
        format.html { render :new }
        format.json { render json: @form_acad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /form_acads/1
  # PATCH/PUT /form_acads/1.json
  def update

    respond_to do |format|
      if @form_acad.update(form_acad_params)
        format.html { redirect_to form_acads_path(@form_acad, egresso_id: @form_acad.egresso_id), notice: 'Formação acadêmica atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: form_acads_path }
      else
        format.html { render :edit }
        format.json { render json: @form_acad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /form_acads/1
  # DELETE /form_acads/1.json
  def destroy

    @form_acad.destroy
    respond_to do |format|
      format.html { redirect_to form_acads_path(@form_acad, egresso_id: @form_acad.egresso_id), notice: 'Formação acadêmica foi excluída.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form_acad
      @form_acad = FormAcad.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def form_acad_params
      params.require(:form_acad).permit(:relatorio_id, :egresso_id, :inst_ofert, :nome_curso, :data_ini, :data_fim, :semestre_letivo, :habilitado)
    end
end
