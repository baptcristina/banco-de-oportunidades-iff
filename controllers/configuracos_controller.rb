class ConfiguracosController < ApplicationController
  devise_group :person, contains: [:admin]
  before_action :authenticate_person!
  before_action :set_configuraco, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper

  # GET /configuracos
  # GET /configuracos.json
  def trocar
  checar_super
  id = params[:id]
  admin = Admin.where(id: id).first

    if admin.super == true
      admin.super = false
      admin.save
    else
      if admin.super == false
      admin.super = true
      admin.save
      end
    end
    redirect_to configuracos_path
 end

def deletar
  checar_super
  id = params[:id]
  admin = Admin.where(id: id).first
  begin
     admin.delete
     redirect_to configuracos_path, notice: "Email de Administrador exclu´do com sucesso."
  rescue ActiveRecord::InvalidForeignKey
     redirect_to :back, alert: "Email possui coordenação associada. Favor excluí-la antes."
  end
end

  def index
  checar_super
    @configuracos = Configuraco.all
    @admin = Admin.all.paginate(page: params[:page], per_page: 4).order("created_at")
  end



  # GET /configuracos/1
  # GET /configuracos/1.json
  def show
  checar_super
  end

  # GET /configuracos/new
 
 def novo
  checar_super
  email = params[:pemail]
  @admin = Admin.new(email: email, password: "123456", password_confirmation: "123456")
  respond_to do |format|
    if @admin.save
      format.html{ redirect_to configuracos_path, notice: "Email de Administrador criado com sucesso."}
    else
      format.html { redirect_to configuracos_path, alert: "Email já existe."}
    end
  end
 end



  # GET /configuracos/1/edit
  def edit
    checar_super
  end

  # POST /configuracos
  # POST /configuracos.json
  def create
  checar_super
    @configuraco = Configuraco.new(configuraco_params)

    respond_to do |format|
      if @configuraco.save
        format.html { redirect_to @configuraco, notice: 'Configuracão criada com sucesso.' }
        format.json { render :show, status: :created, location: @configuraco }
      else
        format.html { render :new }
        format.json { render json: @configuraco.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /configuracos/1
  # PATCH/PUT /configuracos/1.json
  def update
  checar_super
    respond_to do |format|
      if @configuraco.update(configuraco_params)
        format.html { redirect_to @configuraco, notice: 'Configuracão atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @configuraco }
      else
        format.html { render :edit }
        format.json { render json: @configuraco.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /configuracos/1
  # DELETE /configuracos/1.json
  def destroy
  checar_super
    @configuraco.destroy
    respond_to do |format|
      format.html { redirect_to configuracos_url, notice: 'Configuracão excluída com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_configuraco
      @configuraco = Configuraco.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def configuraco_params
      params.fetch(:configuraco, {})
    end

end
