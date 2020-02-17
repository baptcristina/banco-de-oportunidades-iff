class CompetsController < ApplicationController
  devise_group :person, contains: [:user, :admin]
  before_action :authenticate_person!
  before_action :set_compet, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper
  
  # GET /compets
  # GET /compets.json

def index
 checar_egresso_super
 if current_admin.try(:super?)
@pcompet = params[:pcompet]
@pegresso = params[:pegresso]


 if @pegresso.present?
  filtro_nome = " nome_completo like '%"+@pegresso+"%'"
  osEgressos = Egresso.where(filtro_nome)
  id = osEgressos.ids
  competencias_egresso_1 = Compet.where(egresso_id: id)
 else
  competencias_egresso_1 = Compet.all
 end

 if @pcompet.present?
  filtro_compet = "descricao like '%"+@pcompet+"%'"
  competencias_egresso_2 = competencias_egresso_1.where(filtro_compet)
else
  competencias_egresso_2 = competencias_egresso_1
end
 form = competencias_egresso_2
@compets = form.paginate(page: params[:page], per_page: 5).order("egresso_id","descricao")

else
 form = Compet.where(egresso_id: current_user.egresso_id)
@compets = form.paginate(page: params[:page], per_page: 5).order("descricao")

end


end


  # GET /compets/1
  # GET /compets/1.json
  def show
    checar_egresso_super
  end

  # GET /compets/new
  def new
    checar_egresso_super   
    @compet = Compet.new
  end

  # GET /compets/1/edit
  def edit
    checar_egresso_super
  end

  # POST /compets
  # POST /compets.json
  def create

    @compet = Compet.new(compet_params)

    respond_to do |format|
      if @compet.save
        format.html { redirect_to compets_path(@compet, egresso_id: @compet.egresso_id), notice: 'Competência adicional criada com sucesso.' }
        format.json { render :show, status: :created, location: compets_path }
      else
        format.html { render :new }
        format.json { render json: @compet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /compets/1
  # PATCH/PUT /compets/1.json
  def update

    respond_to do |format|
      if @compet.update(compet_params)
        format.html { redirect_to compets_path(@compet, egresso_id: @compet.egresso_id), notice: 'Competência adicional atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: compets_path }
      else
        format.html { render :edit }
        format.json { render json: @compet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /compets/1
  # DELETE /compets/1.json

  def destroy

    @compet.destroy
    respond_to do |format|
      format.html { redirect_to compets_path(@compet, egresso_id: @compet.egresso_id), notice: 'Competência adicional excluída com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_compet
      @compet = Compet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def compet_params
      params.require(:compet).permit(:egresso_id, :descricao, :valor)
    end
end
