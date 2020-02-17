class PesquisasController < ApplicationController
  devise_group :person, contains: [:user, :admin, :empressa]
  before_action :authenticate_person!
  before_action :set_pesquisa, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper

  # GET /pesquisas
  # GET /pesquisas.json
  def index
    checar_egresso_super
    if user_signed_in?

    @contador = 0
    @valores = Idioma.where(egresso_id: current_user.egresso_id).map(&:valor)
    @descricoes = Idioma.where(egresso_id: current_user.egresso_id).map(&:descricao)
        
    @forms = FormAcad.where(egresso_id: current_user.egresso_id).where(habilitado: false)
    @oport_prim = []
    @forms.each do |forma|
      catch :counter do
        filtro = "nome_curso like '%"+forma.nome_curso+"%'"
        @oportunidades_validas = Oportunidade.where("fim_oferta >= (?)", Time.zone.now).where(curso: Titulacao.where(id: Curso.where(nome: forma.nome_curso).first.try(:titulacao_id)).first.try(:titulo)).where.not(situacao: 'Cancelada').where.not(situacao: 'Expirada').or(Oportunidade.where("fim_oferta >= (?)", Time.zone.now).where(curso: Curso.where(nome: forma.nome_curso).where(titulacao_id: nil).first.try(:nome)).where.not(situacao: 'Cancelada').where.not(situacao: 'Expirada'))
        @oportunidades_validas.each do |oportunidade|
          if not(oportunidade.panoconclusao_fim == nil || oportunidade.panoconclusao_inicio == nil)
            @oport_prim << Oportunidade.where(id: oportunidade.id).where("panoconclusao_inicio <= (?) AND panoconclusao_fim >= (?)", FormAcad.where(egresso_id: current_user.egresso_id).where(filtro).where(habilitado: false).first.data_fim,FormAcad.where(egresso_id: current_user.egresso_id).where(filtro).where(habilitado: false).first.data_fim).map(&:id)
          end
          if (oportunidade.panoconclusao_fim == nil)&& not(oportunidade.panoconclusao_inicio == nil)
            @oport_prim << Oportunidade.where(id: oportunidade.id).where("panoconclusao_inicio <= (?)", FormAcad.where(egresso_id: current_user.egresso_id).where(filtro).where(habilitado: false).first.data_fim).map(&:id)
          end
          if not(oportunidade.panoconclusao_fim == nil)&& (oportunidade.panoconclusao_inicio == nil)
            @oport_prim << Oportunidade.where(id: oportunidade.id).where("panoconclusao_fim >= (?)", FormAcad.where(egresso_id: current_user.egresso_id).where(filtro).where(habilitado: false).first.data_fim).map(&:id)
          end
          if (oportunidade.panoconclusao_fim == nil && oportunidade.panoconclusao_inicio == nil)
            @oport_prim << Oportunidade.where(id: oportunidade.id).where(panoconclusao_inicio: nil).where(panoconclusao_fim: nil).map(&:id)

          end
        end
      @array_ids = []
      (1..@oport_prim.length).each do |i|
        @array_ids = @array_ids + @oport_prim[i-1]
      end
      @oportunidades_validas_filtradas_1 = Oportunidade.where(id: @array_ids)
      @oportunidades_final = Oportunidade.none

        if @descricoes.length == 0
          @oportunidades_final = @oportunidades_final+@oportunidades_validas_filtradas_1.where(pidioma: "").where(ptipo: nil)

        else
        (0..@descricoes.length-1).each do |i|
          @oportunidades_final = @oportunidades_final + @oportunidades_validas_filtradas_1.where(pidioma: @descricoes[i]).where('ptipo <= (?)', @valores[i]).or(@oportunidades_validas_filtradas_1.where(pidioma: @descricoes[i]).where(ptipo: nil)).or(@oportunidades_validas_filtradas_1.where(pidioma: "").where(ptipo: nil))
         end
      end
    end
    end
      @oport = @oportunidades_final.uniq
    else
      @oport = Oportunidade.all.order('fim_oferta DESC')
    end
end

  # GET /pesquisas/1
  # GET /pesquisas/1.json
  def show
  end

  # GET /pesquisas/new
  def new
    @pesquisa = Pesquisa.new
  end

  # GET /pesquisas/1/edit
  def edit
  end

  # POST /pesquisas
  # POST /pesquisas.json
  def create
    @pesquisa = Pesquisa.new(pesquisa_params)

    respond_to do |format|
      if @pesquisa.save
        format.html { redirect_to @pesquisa, notice: 'Pesquisa was successfully created.' }
        format.json { render :show, status: :created, location: @pesquisa }
      else
        format.html { render :new }
        format.json { render json: @pesquisa.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pesquisas/1
  # PATCH/PUT /pesquisas/1.json
  def update
    respond_to do |format|
      if @pesquisa.update(pesquisa_params)
        format.html { redirect_to @pesquisa, notice: 'Pesquisa was successfully updated.' }
        format.json { render :show, status: :ok, location: @pesquisa }
      else
        format.html { render :edit }
        format.json { render json: @pesquisa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pesquisas/1
  # DELETE /pesquisas/1.json
  def destroy
    @pesquisa.destroy
    respond_to do |format|
      format.html { redirect_to pesquisas_url, notice: 'Pesquisa was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pesquisa
      @pesquisa = Pesquisa.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pesquisa_params
      params.require(:pesquisa).permit(:nome_egresso, :nome_empresa, :ramo_atividade, :formacao, :periodo_formacao)
    end
end
