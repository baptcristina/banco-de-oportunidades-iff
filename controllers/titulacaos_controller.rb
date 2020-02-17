class TitulacaosController < ApplicationController
  before_action :set_titulacao, only: [:show, :edit, :update, :destroy]

  # GET /titulacaos
  # GET /titulacaos.json

  include ApplicationHelper

  def index

    checar_super_registro
    @ptitulo = params[:pcurso]
    filtro = "titulo like '%"+@ptitulo.to_s+"%'"
    asTitulacaos = Titulacao.where(filtro)
    @titulacaos = asTitulacaos.paginate(page: params[:page], per_page: 5).order("titulo")
  end

  # GET /titulacaos/1
  # GET /titulacaos/1.json
  def show
  end

  # GET /titulacaos/new
  def new
    @titulacao = Titulacao.new
  end

  # GET /titulacaos/1/edit
  def edit
  end

  # POST /titulacaos
  # POST /titulacaos.json
  def create
    @titulacao = Titulacao.new(titulacao_params)

    respond_to do |format|
      if @titulacao.save
        format.html { redirect_to titulacaos_path, notice: 'Titulo criado com successo.' }
        format.json { render :index, status: :created, location: titulacaos_path }
      else
        format.html { render :new }
        format.json { render json: @titulacao.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /titulacaos/1
  # PATCH/PUT /titulacaos/1.json
  def update
    respond_to do |format|
      if @titulacao.update(titulacao_params)
        format.html { redirect_to titulacaos_path, notice: 'Titulo atualizado com successo.' }
        format.json { render titulacaos_path, status: :ok, location: titulacaos_path }
      else
        format.html { render :edit }
        format.json { render json: @titulacao.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /titulacaos/1
  # DELETE /titulacaos/1.json
  def destroy
    @titulacao.destroy
    respond_to do |format|
      format.html { redirect_to titulacaos_path, notice: 'Titulo excluído com successo.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_titulacao
      @titulacao = Titulacao.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def titulacao_params
      params.require(:titulacao).permit(:titulo)
    end
end
