class ExcluidosController < ApplicationController
  devise_group :person, contains: [:admin]
  before_action :authenticate_person!
  before_action :set_excluido, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper

  # GET /excluidos
  # GET /excluidos.json
  def index
    checar_super
    @excluidos = Excluido.all
  end

  def deletar
    checar_super
    tipo = params[:tipo]

    if tipo == "Egressos"
      Egresso.where("1=1").destroy_all
    end
    if tipo == "Empresas"
      Empresa.destroy_all 
    end

    if tipo == "Oportunidades"
       Oportunidade.delete_all
    end
    
    if tipo == "Questionarios"
       QuestionarioEgresso.delete_all
    end

    if tipo == "Relatorios"
       Relatorio.destroy_all
    end

    if tipo == "Todos"

      Egresso.where("1=1").destroy_all
      Empresa.destroy_all 
      Relatorio.destroy_all
      QuestionarioEgresso.destroy_all
    end
    redirect_to home_path, notice: "Dados excluídos com sucesso!"
  end

  # GET /excluidos/1
  # GET /excluidos/1.json
  def show
    checar_super
  end

  # GET /excluidos/new
  def new
    checar_super
    @excluido = Excluido.new
  end

  # GET /excluidos/1/edit
  def edit
    checar_super
  end

  # POST /excluidos
  # POST /excluidos.json
  def create
    checar_super
    @excluido = Excluido.new(excluido_params)

    respond_to do |format|
      if @excluido.save
        format.html { redirect_to @excluido, notice: 'Excluido was successfully created.' }
        format.json { render :show, status: :created, location: @excluido }
      else
        format.html { render :new }
        format.json { render json: @excluido.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /excluidos/1
  # PATCH/PUT /excluidos/1.json
  def update
    checar_super
    respond_to do |format|
      if @excluido.update(excluido_params)
        format.html { redirect_to @excluido, notice: 'Excluido was successfully updated.' }
        format.json { render :show, status: :ok, location: @excluido }
      else
        format.html { render :edit }
        format.json { render json: @excluido.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /excluidos/1
  # DELETE /excluidos/1.json
  def destroy
    checar_super
    @excluido.destroy
    respond_to do |format|
      format.html { redirect_to excluidos_url, notice: 'Excluido was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_excluido
      @excluido = Excluido.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def excluido_params
      params.require(:excluido).permit(:dado)
    end
end
