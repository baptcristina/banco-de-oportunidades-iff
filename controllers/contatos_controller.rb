class ContatosController < ApplicationController
  devise_group :person, contains: [ :admin, :empressa]
  before_action :authenticate_person!
  before_action :set_contato, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper

  # GET /contatos
  # GET /contatos.json
  def index
    empresa_id = params[:empresa_id]
    checar_empresa_super
if current_admin.try(:super?)
    cnpj = params[:cnpj]
    aEmpresa = Empresa.where(cnpj: cnpj).first
    @contatos = Contato.where(empresa_id: aEmpresa).paginate(page: params[:page], per_page: 5).order("nome")
  else
    @contatos = Contato.where(empresa_id: empresa_id).paginate(page: params[:page], per_page: 5).order("nome")
  end
  end

  # GET /contatos/1
  # GET /contatos/1.json
  def show
    checar_empresa_super
  end

  # GET /contatos/new
  def new
    checar_empresa_super
    session[:prev_url] = request.referer
    @contato = Contato.new
  end

  # GET /contatos/1/edit
  def edit
    checar_empresa_super
    session[:prev_url] = request.referer
  end

  # POST /contatos
  # POST /contatos.json
  def create
    @contato = Contato.new(contato_params)

    respond_to do |format|
      if @contato.save
        format.html { redirect_to session[:prev_url], notice: 'Contato criado com sucesso.' }
        format.json { render :show, status: :created, location: session[:prev_url] }
      else
        format.html { render :new }
        format.json { render json: @contato.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contatos/1
  # PATCH/PUT /contatos/1.json
  def update
    respond_to do |format|
      if @contato.update(contato_params)
        format.html { redirect_to session[:prev_url], notice: 'Contato atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: session[:prev_url] }
      else
        format.html { render :edit }
        format.json { render json: @contato.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contatos/1
  # DELETE /contatos/1.json
  def destroy
    begin
    @contato.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Contato excluído com sucesso.' }
      format.json { head :no_content }
    end
        rescue ActiveRecord::InvalidForeignKey
        flash[:alert] = 'Existem Oportunidades ainda relacionadas a este contato.'
        redirect_to :back
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contato
      @contato = Contato.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contato_params
      params.require(:contato).permit(:empresa_id, :nome, :cargo, :setor, :tel, :email, :telefone_cel)
    end
end
