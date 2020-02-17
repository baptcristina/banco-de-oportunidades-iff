class EmpresasController < ApplicationController
  devise_group :person, contains: [:admin, :empressa]
  before_action :authenticate_person!
  before_action :set_empresa, only: [:show, :edit, :update, :destroy]
  include ApplicationHelper
  # GET /empresas
  # GET /empresas.json
  def index
    checar_empresa_super
    @prazao_social = params[:prazao_social]
    @perrados = params[:perrados]
    filtro = "1=1"

    if not(@prazao_social.nil?) 
      if  @perrados ==  'S' 
        filtro = "cnpj is not null and email is not null and razao_social like '%"+@prazao_social+"%'"
        @empresas = Empresa.where(filtro).paginate(page: params[:page], per_page: 5).order("razao_social")
      else
        if @perrados ==  'C'
         filtro = "cnpj is null OR email is null and razao_social like '%"+@prazao_social+"%' "
         @empresas = Empresa.where(filtro).paginate(page: params[:page], per_page: 5).order("razao_social")
        else
           filtro = "razao_social like '%"+@prazao_social+"%'"
           @empresas = Empresa.where(filtro).paginate(page: params[:page], per_page: 5).order("razao_social")
        end        
      end
    else
      
      @empresas = Empresa.all.paginate(page: params[:page], per_page: 5).order("razao_social")
    end

  end

  # GET /empresas/1
  # GET /empresas/1.json

  def pesquisar
    empresa_id = current_empressa.empresa_id
    @contato = Contato.where(empresa_id: empresa_id).first

    redirect_to pesquisa_empresas_path(@empresa, empresa_id: empresa_id)
  end

  def contatar
    checar_super
    cnpj = params[:cnpj]
    empresa_id = Empresa.where(cnpj: cnpj).first
    osContatos = Contato.where(empresa_id: empresa_id)
    redirect_to contatos_path(:cnpj => cnpj)
  end



  def show
    checar_egresso_empresa_super_show_empresa
    @cidades_lista = @@cidades
    @estados_lista = @@estados

  end

  # GET /empresas/new
  def new
      checar_super
      @empresa = Empresa.new
 
  end

  # GET /empresas/1/edit
  def edit
    checar_empresa_super
  end

  # POST /empresas
  # POST /empresas.json
  def create
    @empresa = Empresa.new(empresa_params)

    respond_to do |format|
      if @empresa.save
        format.html { redirect_to @empresa, notice: 'Empresa criada com sucesso.' }
        format.json { render :show, status: :created, location: @empresa }
      else
        format.html { render :new }
        format.json { render json: @empresa.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /empresas/1
  # PATCH/PUT /empresas/1.json
  def update

    respond_to do |format|
      @empresa.skip_fields_validation = false
      if @empresa.update(empresa_params)
        format.html { redirect_to home_path, notice: 'Empresa atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @empresa }
      else
        format.html { render :edit }
        format.json { render json: @empresa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /empresas/1
  # DELETE /empresas/1.json
  def destroy

    @empresa.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Empresa excluída com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_empresa
      @empresa = Empresa.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def empresa_params
      params.require(:empresa).permit(:cnpj, :razao_social, :nome_fantasia, :ramo_ativ_id, :site, :email, :endereco, :cep, :cidade, :estado, :logo, :remove_logo)
    end
end
