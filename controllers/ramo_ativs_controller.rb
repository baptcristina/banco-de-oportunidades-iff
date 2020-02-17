class RamoAtivsController < ApplicationController
  devise_group :person, contains: [:admin]
  before_action :authenticate_person!
  before_action :set_ramo_ativ, only: [:show, :edit, :update, :destroy]

   include ApplicationHelper

  # GET /ramo_ativs
  # GET /ramo_ativs.json

  def index

    checar_super

    @ramo_ativ = params[:pramo]
    filtro = "ramo_ativ like '%"+@ramo_ativ.to_s+"%'"
    osRamos = RamoAtiv.where(filtro)
    @ramo_ativs = osRamos.paginate(page: params[:page], per_page: 5).order("ramo_ativ")

  end

  # GET /ramo_ativs/1
  # GET /ramo_ativs/1.json
  def show

  end

  # GET /ramo_ativs/new
  def new
    @ramo_ativ = RamoAtiv.new
  end

  # GET /ramo_ativs/1/edit
  def edit
  end

  # POST /ramo_ativs
  # POST /ramo_ativs.json
  def create
    @ramo_ativ = RamoAtiv.new(ramo_ativ_params)

    respond_to do |format|
      if @ramo_ativ.save
        format.html { redirect_to  ramo_ativs_path, notice: 'Ramo de atividade criado com successo.' }
        format.json { render ramo_ativs_path, status: :created, location: ramo_ativs_path }
      else
        format.html { render :new }
        format.json { render json: @ramo_ativ.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ramo_ativs/1
  # PATCH/PUT /ramo_ativs/1.json
  def update
    respond_to do |format|
      if @ramo_ativ.update(ramo_ativ_params)
        format.html { redirect_to  ramo_ativs_path, notice: 'Ramo de atividade atualizado com successo.' }
        format.json { render ramo_ativs_path , status: :ok, location: ramo_ativs_path}
      else
        format.html { render :edit }
        format.json { render json: @ramo_ativ.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ramo_ativs/1
  # DELETE /ramo_ativs/1.json
  def destroy
    @ramo_ativ.destroy
    respond_to do |format|
      format.html { redirect_to ramo_ativs_path, notice: 'Ramo de atividade excluído com successo.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ramo_ativ
      @ramo_ativ = RamoAtiv.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ramo_ativ_params
      params.require(:ramo_ativ).permit(:ramo_ativ)
    end
end
