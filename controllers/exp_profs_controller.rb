class ExpProfsController < ApplicationController
  devise_group :person, contains: [:user, :admin]
  before_action :authenticate_person!
  before_action :set_exp_prof, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper
  
  # GET /exp_profs
  # GET /exp_profs.json

   def index
      checar_egresso_super

 if current_admin.try(:super?)
      @forms = ExpProf.all
      @pcargo = params[:pcargo]
      @pempresa = params[:pempresa]
      @pegresso = params[:pegresso]

      if not(@pcargo.present?) && (@pempresa.present?)
        if @pegresso.present?
          filtro_egresso = "nome_completo like '%"+@pegresso+"%'"
          osEgressos = Egresso.where(filtro_egresso)
          id = osEgressos.ids
          exp_profissionais  = ExpProf.where(egresso_id: id)
          filtro = "empresa like '%"+@pempresa+"%'"          
        else
          exp_profissionais  = ExpProf.all
          filtro = "empresa like '%"+@pempresa+"%'"
        end
      else
       if  not(@pempresa.present?) && (@pcargo.present?)
        if @pegresso.present?
          filtro_egresso = "nome_completo like '%"+@pegresso+"%'"
          osEgressos = Egresso.where(filtro_egresso)
          id = osEgressos.ids
          exp_profissionais  = ExpProf.where(egresso_id: id)
          filtro = "cargo like '%"+@pcargo+"%'"            
        else
          exp_profissionais  = ExpProf.all
          filtro = "cargo like '%"+@pcargo+"%'"
        end
       else
        if  (@pcargo.present?) && (@pempresa.present?)
         if @pegresso.present?
            filtro_egresso = "nome_completo like '%"+@pegresso+"%'"
            osEgressos = Egresso.where(filtro_egresso)
            id = osEgressos.ids
            exp_profissionais  = ExpProf.where(egresso_id: id)
            filtro = "empresa like '%"+@pempresa+"%' and cargo like '%"+@pempresa+"%'" 
         else
            exp_profissionais  = ExpProf.all
            filtro = "empresa like '%"+@pempresa+"%' and cargo like '%"+@pcargo+"%'" 
         end
        else
          if not(@pcargo.present?) &&  not(@pempresa.present?)
            if @pegresso.present?
              filtro_egresso = "nome_completo like '%"+@pegresso+"%'"
              osEgressos = Egresso.where(filtro_egresso)
              id = osEgressos.ids
              exp_profissionais  = ExpProf.where(egresso_id: id)
            else
              exp_profissionais = ExpProf.all
            end
          end
        end
       end
      end
      @forms = exp_profissionais.where(filtro)
      @exp_profs = @forms.paginate(page: params[:page], per_page: 5).order("egresso_id","data_ini DESC")
    else

    @forms = ExpProf.where( :egresso_id => current_user.egresso_id)
    @exp_profs = @forms.paginate(page: params[:page], per_page: 5).order("data_ini DESC")
    end


    
  end

  # GET /exp_profs/1
  # GET /exp_profs/1.json
  def show
    checar_egresso_super
  end

  # GET /exp_profs/new
  def new
    checar_egresso_super
    @exp_prof = ExpProf.new
  end

  # GET /exp_profs/1/edit
  def edit
    checar_egresso_super
  end

  # POST /exp_profs
  # POST /exp_profs.json
  def create

    @exp_prof = ExpProf.new(exp_prof_params)

    respond_to do |format|
      if @exp_prof.save
        format.html { redirect_to exp_profs_path(@exp_prof, egresso_id: @exp_prof.egresso_id), notice:'Nova experiência pofissional foi incluída.' }
        format.json { render :show, status: :created, location: exp_profs_path }
      else
        format.html { render :new }
        format.json { render json: @exp_prof.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exp_profs/1
  # PATCH/PUT /exp_profs/1.json
  def update

    respond_to do |format|
      if @exp_prof.update(exp_prof_params)
        format.html { redirect_to exp_profs_path(@exp_prof, egresso_id: @exp_prof.egresso_id), notice: 'Experiência profissional atualizada com sucesso'}
        format.json { render :show, status: :ok, location: exp_profs_path }
      else
        format.html { render :edit }
        format.json { render json: @exp_prof.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exp_profs/1
  # DELETE /exp_profs/1.json
  def destroy
  checar_egresso_super
    @exp_prof.destroy
    respond_to do |format|
      format.html { redirect_to exp_profs_path(@exp_prof, egresso_id: @exp_prof.egresso_id), notice: 'Experiência profissional foi excluída.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exp_prof
      @exp_prof = ExpProf.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exp_prof_params
      params.require(:exp_prof).permit(:egresso_id, :empresa, :ramo_ativ_id, :tipo_rel, :cargo, :data_ini, :data_fim)
    end
end
