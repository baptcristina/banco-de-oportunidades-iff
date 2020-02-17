class FerramentasController < ApplicationController
  devise_group :person, contains: [:admin]
  before_action :authenticate_person!
  before_action :set_ferramenta, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper

  # GET /ferramentas
  # GET /ferramentas.json
  def index
  checar_super_agencia
    @empresas = Empresa.all
  end
 
 def importempresa
  checar_super_agencia
  begin
  Empresa.importempresa(params[:file])
    oRelatorio = Relatorio.last
    erros = oRelatorio.quantidade_erros
    total = oRelatorio.quantidade_total
    sucesso = (total.to_i - erros.to_i).to_s
    print "\a"
    if erros.to_i == 0
      redirect_to :back, notice: sucesso+" empresas foram importadas com sucesso e nenhum erro foi encontrado!"
    end
    if erros.to_i == 1
      redirect_to :back, notice: sucesso+" empresas foram importadas com sucesso e "+erros+" apresentou erro!"  
    else
      redirect_to :back, notice: sucesso+" empresas foram importadas com sucesso e "+erros+" apresentaram erros!"  
    end

  end
end



def import
  checar_super_agencia
begin
  @id = Egresso.import(params[:file])
  oRelatorio = Relatorio.where(id: @id).first
  if oRelatorio.tipo.include? "Dados do Registro Acadêmico inválidos"
    Egresso.where(id: FormAcad.where(relatorio_id: oRelatorio.id).map(&:egresso_id)).destroy_all
    redirect_back(fallback_location: "/", alert: "Dados de Importação Inválidos, todos as entradas válidas foram removidas" ) 
  else
  erros = oRelatorio.quantidade_erros
  total = oRelatorio.quantidade_total

  print "\a"
  if erros.to_i == 0
    redirect_back(fallback_location: "/", notice: total+" egressos foram importados com sucesso e nenhum erro foi encontrado!")
 else
  if erros.to_i == 1
    redirect_back(fallback_location: "/", notice: total+" egressos foram importados com sucesso e "+erros+" apresentou erro!" ) 
  else
        redirect_back(fallback_location: "/", notice: total+" egressos foram importados com sucesso e "+erros+" apresentaram erros!" ) 
  end
 end
 end
    rescue NoMethodError
        print "\a"
    redirect_to ferramentas_path, alert: "Nenhum arquivo selecionado!"
    rescue ArgumentError => e
      print "\a"
      redirect_back(fallback_location: ferramentas_path , alert: "Formato de arquivo inválido!")
  end

end




  # GET /ferramentas/1
  # GET /ferramentas/1.json
  def show
    checar_super_agencia
  end

  # GET /ferramentas/new
  def new
    checar_super_agencia
  end

  # GET /ferramentas/1/edit
  def edit
    checar_super_agencia
  end

  # POST /ferramentas
  # POST /ferramentas.json
  def create
    
    @ferramenta = Ferramenta.new(ferramenta_params)

    respond_to do |format|
      if @ferramenta.save
        format.html { redirect_to @ferramenta, notice: 'Ferramenta was successfully created.' }
        format.json { render :show, status: :created, location: @ferramenta }
      else
        format.html { render :new }
        format.json { render json: @ferramenta.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ferramentas/1
  # PATCH/PUT /ferramentas/1.json
  def update
    respond_to do |format|
      if @ferramenta.update(ferramenta_params)
        format.html { redirect_to @ferramenta, notice: 'Ferramenta was successfully updated.' }
        format.json { render :show, status: :ok, location: @ferramenta }
      else
        format.html { render :edit }
        format.json { render json: @ferramenta.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ferramentas/1
  # DELETE /ferramentas/1.json
  def destroy
    @ferramenta.destroy
    respond_to do |format|
      format.html { redirect_to ferramentas_url, notice: 'Ferramenta was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ferramenta
      @ferramenta = Ferramenta.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ferramenta_params
      params.require(:ferramenta).permit(:ferramenta)
    end
end

