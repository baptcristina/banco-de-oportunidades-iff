class AtivAutsController < ApplicationController
  devise_group :person, contains: [:user, :admin]
  before_action :authenticate_person!
  before_action :set_ativ_aut, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper

  # GET /ativ_auts
  # GET /ativ_auts.json
  def index
    checar_egresso_super
 if current_admin.try(:super?)
      @forms = AtivAut.all
      @pfuncao = params[:pfuncao]
      @pprest_serv = params[:pprest_serv]
      @pegresso = params[:pegresso]

      if not(@pfuncao.present?) && (@pprest_serv.present?)
        if @pegresso.present?
          filtro_egresso = "nome_completo like '%"+@pegresso+"%'"
          osEgressos = Egresso.where(filtro_egresso)
          id = osEgressos.ids
          ativ_autonomas  = AtivAut.where(egresso_id: id)
          filtro = "prest_serv like '%"+@pprest_serv+"%'"          
        else
          ativ_autonomas  = AtivAut.all
          filtro = "prest_serv like '%"+@pprest_serv+"%'"
        end
      else
       if  not(@pprest_serv.present?) && (@pfuncao.present?)
        if @pegresso.present?
          filtro_egresso = "nome_completo like '%"+@pegresso+"%'"
          osEgressos = Egresso.where(filtro_egresso)
          id = osEgressos.ids
          ativ_autonomas  = AtivAut.where(egresso_id: id)
          filtro = "funcao like '%"+@pfuncao+"%'"            
        else
          ativ_autonomas  = AtivAut.all
          filtro = "funcao like '%"+@pfuncao+"%'"
        end
       else
        if  (@pfuncao.present?) && (@pprest_serv.present?)
         if @pegresso.present?
            filtro_egresso = "nome_completo like '%"+@pegresso+"%'"
            osEgressos = Egresso.where(filtro_egresso)
            id = osEgressos.ids
            ativ_autonomas  = AtivAut.where(egresso_id: id)
            filtro = "prest_serv like '%"+@pprest_serv+"%' and funcao like '%"+@pprest_serv+"%'" 
         else
            ativ_autonomas  = AtivAut.all
            filtro = "prest_serv like '%"+@pprest_serv+"%' and funcao like '%"+@pfuncao+"%'" 
         end
        else
          if not(@pfuncao.present?) &&  not(@pprest_serv.present?)
            if @pegresso.present?
              filtro_egresso = "nome_completo like '%"+@pegresso+"%'"
              osEgressos = Egresso.where(filtro_egresso)
              id = osEgressos.ids
              ativ_autonomas  = AtivAut.where(egresso_id: id)
            else
              ativ_autonomas = AtivAut.all
            end
          end
        end
       end
      end
      @forms = ativ_autonomas.where(filtro)
    @ativ_auts = @forms.paginate(page: params[:page], per_page: 5).order("egresso_id","data_ini DESC")
    else

    @forms = AtivAut.where( :egresso_id => current_user.egresso_id)
    @ativ_auts = @forms.paginate(page: params[:page], per_page: 5).order("data_ini DESC")
    end

  end

  # GET /ativ_auts/1
  # GET /ativ_auts/1.json
  def show
      checar_egresso_super
  end

  # GET /ativ_auts/new
  def new
    checar_egresso_super
    @ativ_aut = AtivAut.new
  end

  # GET /ativ_auts/1/edit
  def edit
    checar_egresso_super
  end

  # POST /ativ_auts
  # POST /ativ_auts.json
  def create

    @ativ_aut = AtivAut.new(ativ_aut_params)

    respond_to do |format|
      if @ativ_aut.save
        format.html { redirect_to ativ_auts_path(@ativ_aut, egresso_id: @ativ_aut.egresso_id), notice: 'Atividade autônoma criada com sucesso.'  }
        format.json { render :show, status: :created, location: ativ_auts_path }
      else
        format.html { render :new }
        format.json { render json: @ativ_aut.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ativ_auts/1
  # PATCH/PUT /ativ_auts/1.json
  def update

    respond_to do |format|
      if @ativ_aut.update(ativ_aut_params)
        format.html { redirect_to ativ_auts_path(@ativ_aut, egresso_id: @ativ_aut.egresso_id), notice: 'Atividade autônoma atualizada com sucesso.'  }
        format.json { render :show, status: :ok, location: ativ_auts_path }
      else
        format.html { render :edit }
        format.json { render json: @ativ_aut.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ativ_auts/1
  # DELETE /ativ_auts/1.json
  def destroy

    @ativ_aut.destroy
    respond_to do |format|
      format.html { redirect_to ativ_auts_path(@ativ_aut, egresso_id: @ativ_aut.egresso_id), notice: 'Atividade autônoma excluída com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ativ_aut
      @ativ_aut = AtivAut.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ativ_aut_params
      params.require(:ativ_aut).permit(:egresso_id, :prest_serv, :ramo_ativ_id, :funcao, :data_ini, :data_fim)
    end
end
