class IdiomasController < ApplicationController
  devise_group :person, contains: [:user, :admin]
  before_action :authenticate_person!
  before_action :set_idioma, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper

  # GET /idiomas
  # GET /idiomas.json

def index
 checar_egresso_super
 if current_admin.try(:super?)

@pidioma = params[:pidioma]
@pegresso = params[:pegresso]


 if @pegresso.present?
  filtro_nome = " nome_completo like '%"+@pegresso+"%'"
  osEgressos = Egresso.where(filtro_nome)
  id = osEgressos.ids
  idioma_egresso_1 = Idioma.where(egresso_id: id)
 else
  idioma_egresso_1 = Idioma.all
 end

 if @pidioma.present?
  filtro_idioma = "descricao like '%"+@pidioma+"%'"
  idioma_egresso_2 = idioma_egresso_1.where(filtro_idioma)
else
  idioma_egresso_2 = idioma_egresso_1
end
 form = idioma_egresso_2
 @idiomas = form.paginate(page: params[:page], per_page: 5).order("egresso_id","descricao")

else 
  form = Idioma.where(egresso_id: current_user.egresso_id)
 @idiomas = form.paginate(page: params[:page], per_page: 5).order("descricao")
end


end


  # GET /idiomas/1
  # GET /idiomas/1.json
  def show
    checar_egresso_super
  end

  # GET /idiomas/new
  def new
    checar_egresso_super
    @idioma = Idioma.new
  end

  # GET /idiomas/1/edit
  def edit
    checar_egresso_super
  end

  # POST /idiomas
  # POST /idiomas.json
  def create

    @idioma = Idioma.new(idioma_params)

    respond_to do |format|
      if @idioma.save
        format.html { redirect_to idiomas_path(@idioma, egresso_id: @idioma.egresso_id), notice: 'Idioma criado com sucesso.' }
        format.json { render :show, status: :created, location: idiomas_path }
      else
        format.html { render :new }
        format.json { render json: @idioma.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /idiomas/1
  # PATCH/PUT /idiomas/1.json
  def update

    respond_to do |format|
      if @idioma.update(idioma_params)
        format.html { redirect_to idiomas_path(@idioma, egresso_id: @idioma.egresso_id), notice: 'Idioma atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: idiomas_path }
      else
        format.html { render :edit }
        format.json { render json: @idioma.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /idiomas/1
  # DELETE /idiomas/1.json
  def destroy

    @idioma.destroy
    respond_to do |format|
      format.html { redirect_to idiomas_path(@idioma, egresso_id: @idioma.egresso_id), notice: 'Idioma excluído com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_idioma
      @idioma = Idioma.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def idioma_params
      params.require(:idioma).permit(:egresso_id, :descricao, :valor)
    end
end
