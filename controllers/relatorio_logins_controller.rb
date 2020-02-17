class RelatorioLoginsController < ApplicationController
  devise_group :person, contains: [:admin]
  before_action :authenticate_person!
  before_action :set_relatorio_login, only: [:show, :edit, :update, :destroy]

  # GET /relatorio_logins
  # GET /relatorio_logins.json
  def index
    @relatorio_logins = RelatorioLogin.all
  end

  # GET /relatorio_logins/1
  # GET /relatorio_logins/1.json
  def show
  end

  # GET /relatorio_logins/new
  def new
    @relatorio_login = RelatorioLogin.new
  end

  # GET /relatorio_logins/1/edit
  def edit
  end

  # POST /relatorio_logins
  # POST /relatorio_logins.json
  def create
    @relatorio_login = RelatorioLogin.new(relatorio_login_params)

    respond_to do |format|
      if @relatorio_login.save
        format.html { redirect_to @relatorio_login, notice: 'Relatório criado com sucesso.' }
        format.json { render :show, status: :created, location: @relatorio_login }
      else
        format.html { render :new }
        format.json { render json: @relatorio_login.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /relatorio_logins/1
  # PATCH/PUT /relatorio_logins/1.json
  def update
    respond_to do |format|
      if @relatorio_login.update(relatorio_login_params)
        format.html { redirect_to @relatorio_login, notice: 'Relatório atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @relatorio_login }
      else
        format.html { render :edit }
        format.json { render json: @relatorio_login.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /relatorio_logins/1
  # DELETE /relatorio_logins/1.json
  def destroy
    @relatorio_login.destroy
    respond_to do |format|
      format.html { redirect_to relatorio_logins_url, notice: 'Relatório excluído com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_relatorio_login
      @relatorio_login = RelatorioLogin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def relatorio_login_params
      params.require(:relatorio_login).permit(:user_id)
    end
end
