class PesquisaEmpresasController < ApplicationController
  devise_group :person, contains: [:admin, :empressa]
  before_action :authenticate_person!
  before_action :set_pesquisa_empresa, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper

  # GET /pesquisa_empresas
  # GET /pesquisa_empresas.json
  def index
    checar_empresa_super_esp
    @pformacao = params[:pformacao]
    @panoconclusao_inicio = params[:panoconclusao_inicio]
    @panoconclusao_fim = params[:panoconclusao_fim]    
    @pidioma = params[:pidioma]
    @ptipo = params[:ptipo]

    if (@pformacao.nil?||@pformacao == "")&&(@panoconclusao_inicio.nil?||@panoconclusao_inicio == "")  && (@panoconclusao_fim.nil?||@panoconclusao_fim == "") &&(@pidioma.nil?||@pidioma == "") && (@ptipo.nil?||@ptipo == "")
      osEgressos_datas_idioma_tipo = FormAcad.none
    else
    if not(@pformacao.nil?||@pformacao == "")
      @form_ids = []
      @nomes_curso = Curso.where(titulacao_id: Titulacao.where(titulo: @pformacao).first.id).or(Curso.where(nome: @pformacao))
      @nomes_curso.each do |nome_curso|
        filtro = "nome_curso like '%"+nome_curso.nome+"%'"
        @form_ids << FormAcad.where(filtro).where(habilitado: false).map(&:id)
      end
      @array_ids = []
      (1..@form_ids.length).each do |i|
        @array_ids = @array_ids + @form_ids[i-1]
      end
      @forms = FormAcad.where(id: @array_ids)
    else
      @forms = FormAcad.all.where(habilitado: false)
    end
      if @panoconclusao_inicio.present? && @panoconclusao_fim.present?
        osEgressos_datas = @forms.where("data_fim >= (?) AND data_fim <= (?)", @panoconclusao_inicio , @panoconclusao_fim )
      end
      if @panoconclusao_inicio.present? && not(@panoconclusao_fim.present?)
        osEgressos_datas = @forms.where("data_fim >= (?)", @panoconclusao_inicio)
      end
      if @panoconclusao_fim.present?   && not(@panoconclusao_inicio.present?)       
        osEgressos_datas = @forms.where("data_fim <= (?)", @panoconclusao_fim)
      end
      if not(@panoconclusao_inicio.present?) && not(@panoconclusao_fim.present?)
        osEgressos_datas = @forms.all
      end

      if @pidioma.present?
         osIdiomas = Idioma.where(egresso_id: osEgressos_datas.map(&:egresso_id))
         osIdiomas_filtrados = osIdiomas.where("descricao = (?)", @pidioma)
         if @ptipo.present?
          osIdiomas_filtrados_tipo = osIdiomas_filtrados.where("valor >= (?)", @ptipo)
          osEgressos_datas_idioma_tipo = osEgressos_datas.where(egresso_id: osIdiomas_filtrados_tipo.map(&:egresso_id))
         else
          osEgressos_datas_idioma_tipo = osEgressos_datas.where(egresso_id: osIdiomas_filtrados.map(&:egresso_id))
         end
      else
        osEgressos_datas_idioma_tipo = osEgressos_datas
      end
    end
    osEgressos_final = Egresso.where(id: osEgressos_datas_idioma_tipo.map(&:egresso_id))
    osEgressos_final_2 = osEgressos_final.where.not(email_princ: nil).order(:nome_completo)
    


    @form_final = osEgressos_final_2.paginate(page: params[:page], per_page: 5)

  end


  # GET /pesquisa_empresas/1
  # GET /pesquisa_empresas/1.json
  def show
    checar_empresa_super_esp
  end

  # GET /pesquisa_empresas/new
  def new
    checar_empresa_super_esp
    @pesquisa_empresa = PesquisaEmpresa.new
  end

  # GET /pesquisa_empresas/1/edit
  def edit
    checar_empresa_super_esp
  end




  # POST /pesquisa_empresas
  # POST /pesquisa_empresas.json
  def create
    checar_empresa_super_esp
    @pesquisa_empresa = PesquisaEmpresa.new(pesquisa_empresa_params)

    respond_to do |format|
      if @pesquisa_empresa.save
        format.html { redirect_to @pesquisa_empresa, notice: 'Pesquisa empresa was successfully created.' }
        format.json { render :show, status: :created, location: @pesquisa_empresa }
      else
        format.html { render :new }
        format.json { render json: @pesquisa_empresa.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pesquisa_empresas/1
  # PATCH/PUT /pesquisa_empresas/1.json
  def update
    checar_empresa_super_esp
    respond_to do |format|
      if @pesquisa_empresa.update(pesquisa_empresa_params)
        format.html { redirect_to @pesquisa_empresa, notice: 'Pesquisa empresa was successfully updated.' }
        format.json { render :show, status: :ok, location: @pesquisa_empresa }
      else
        format.html { render :edit }
        format.json { render json: @pesquisa_empresa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pesquisa_empresas/1
  # DELETE /pesquisa_empresas/1.json
  def destroy
    checar_empresa_super_esp
    @pesquisa_empresa.destroy
    respond_to do |format|
      format.html { redirect_to pesquisa_empresas_url, notice: 'Pesquisa empresa was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pesquisa_empresa
      @pesquisa_empresa = PesquisaEmpresa.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pesquisa_empresa_params
      params.require(:pesquisa_empresa).permit(:cpf, :cnpj)
    end
end
