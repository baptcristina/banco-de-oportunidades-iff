class FormComplsController < ApplicationController
  devise_group :person, contains: [:user, :admin]
  before_action :authenticate_person!
  before_action :set_form_compl, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper

  # GET /form_compls
  # GET /form_compls.json
  def index
    checar_egresso_super     
     if current_admin.try(:super?)
      @forms = FormCompl.all
      @pcurso = params[:pcurso]
      @pinstituicao = params[:pinstituicao]
      @pegresso = params[:pegresso]

      if not(@pcurso.present?) && (@pinstituicao.present?)
        if @pegresso.present?
          filtro_egresso = "nome_completo like '%"+@pegresso+"%'"
          osEgressos = Egresso.where(filtro_egresso)
          id = osEgressos.ids
          form_complem  = FormCompl.where(egresso_id: id)
          filtro = "inst like '%"+@pinstituicao+"%'"          
        else
          form_complem  = FormCompl.all
          filtro = "inst like '%"+@pinstituicao+"%'"
        end
      else
       if  not(@pinstituicao.present?) && (@pcurso.present?)
        if @pegresso.present?
          filtro_egresso = "nome_completo like '%"+@pegresso+"%'"
          osEgressos = Egresso.where(filtro_egresso)
          id = osEgressos.ids
          form_complem  = FormCompl.where(egresso_id: id)
          filtro = "inst like '%"+@pcurso+"%'"            
        else
          form_complem  = FormCompl.all
          filtro = "nome_curso like '%"+@pcurso+"%'"
        end
       else
        if  (@pcurso.present?) && (@pinstituicao.present?)
         if @pegresso.present?
            filtro_egresso = "nome_completo like '%"+@pegresso+"%'"
            osEgressos = Egresso.where(filtro_egresso)
            id = osEgressos.ids
            form_complem  = FormCompl.where(egresso_id: id)
            filtro = "inst like '%"+@pinstituicao+"%' and nome_curso like '%"+@pcurso+"%'" 
         else
            form_complem  = FormCompl.all
            filtro = "inst like '%"+@pinstituicao+"%' and nome_curso like '%"+@pcurso+"%'" 
         end
        else
          if not(@pcurso.present?) &&  not(@pinstituicao.present?)
            if @pegresso.present?
              filtro_egresso = "nome_completo like '%"+@pegresso+"%'"
              osEgressos = Egresso.where(filtro_egresso)
              id = osEgressos.ids
              form_complem  = FormCompl.where(egresso_id: id)
            else
              form_complem = FormCompl.all
            end
          end
        end
       end
      end
      @forms = form_complem.where(filtro)
      @form_compls = @forms.paginate(page: params[:page], per_page: 5).order("egresso_id","data_fim DESC")
    else

    @forms = FormCompl.where( :egresso_id => current_user.egresso_id)
    @form_compls = @forms.paginate(page: params[:page], per_page: 5).order("data_fim DESC")
    end

  end

  # GET /form_compls/1
  # GET /form_compls/1.json
  def show
    checar_egresso_super
  end

  # GET /form_compls/new
  def new
    checar_egresso_super
    @form_compl = FormCompl.new
  end

  # GET /form_compls/1/edit
  def edit
    checar_egresso_super
  end

  # POST /form_compls
  # POST /form_compls.json
  def create
    @form_compl = FormCompl.new(form_compl_params)

    respond_to do |format|
      if @form_compl.save
        format.html { redirect_to form_compls_path(@form_compl, egresso_id: @form_compl.egresso_id), notice: 'Formação complementar criada com sucesso.'  }
        format.json { render :show, status: :created, location: form_compls_path }
      else
        format.html { render :new }
        format.json { render json: @form_compl.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /form_compls/1
  # PATCH/PUT /form_compls/1.json
  def update
    respond_to do |format|
      if @form_compl.update(form_compl_params)
        format.html { redirect_to form_compls_path(@form_compl, egresso_id: @form_compl.egresso_id), notice: 'Formação complementar atualizada com sucesso.'  }
        format.json { render :show, status: :ok, location: form_compls_path }
      else
        format.html { render :edit }
        format.json { render json: @form_compl.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /form_compls/1
  # DELETE /form_compls/1.json
  def destroy
    @form_compl.destroy
    respond_to do |format|
      format.html { redirect_to form_compls_path(@form_compl, egresso_id: @form_compl.egresso_id), notice: 'Formação complementar excluída com sucesso.'}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form_compl
      @form_compl = FormCompl.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def form_compl_params
      params.require(:form_compl).permit(:egresso_id, :inst, :nome_curso, :data_fim, :carga)
    end
end
