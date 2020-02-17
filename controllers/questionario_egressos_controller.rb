class QuestionarioEgressosController < ApplicationController
  devise_group :person, contains: [:user, :admin]
  before_action :authenticate_person!
  before_action :set_questionario_egresso, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper
 
  # GET /questionario_egressos
  # GET /questionario_egressos.json
  def index
    checar_super
    @pnome = params[:pnome]
    @pdata_ini = params[:pdata_ini]
    @pdata_fim = params[:pdata_fim]
    @pdata_ate = params[:pdata_ate] 
    @data_ate = (params[:pdata_ate].to_date+1.days).to_s  if params[:pdata_ate]# +1 pegar a data cheia, update_at time
    @pcurso = params[:pcurso]
    @prealizado = params[:prealizado]

    if not(@pcurso ==nil)
      filtro_curso = "nome_curso like '%"+@pcurso+"%'"
    else
      filtro_curso  = "1=1"
    end

    if not(@pnome ==nil)
      filtro_nome = "nome_completo like '%"+@pnome+"%'"
    else
      filtro_nome = "1=1"
    end

    osEgressos = Egresso.where(filtro_nome)

    if @pdata_ini.present? && @pdata_fim.present?
      asFormAcads = FormAcad.where(egresso_id: osEgressos.map(&:id)).where(filtro_curso).where("data_fim >= (?) AND data_fim <= (?)", @pdata_ini, @pdata_fim)
    else
      if @pdata_ini.present? && not(@pdata_fim.present?)
        asFormAcads = FormAcad.where(egresso_id: osEgressos.map(&:id)).where(filtro_curso).where("data_fim >= (?) ", @pdata_ini)
      end
      if not( @pdata_ini.present?) && @pdata_fim.present?
        asFormAcads = FormAcad.where(egresso_id: osEgressos.map(&:id)).where(filtro_curso).where("data_fim <= (?) ", @pdata_fim)
      end
      if not( @pdata_ini.present?) && not(@pdata_fim.present?) &&@pcurso.present?
        asFormAcads = FormAcad.where(egresso_id: osEgressos.map(&:id)).where(filtro_curso)
        else
          asFormAcads = FormAcad.where(egresso_id: osEgressos.map(&:id))
      end
    end
    if @prealizado == "S"
      @realizado = "true"
    else
      @realizado = "false"
    end
puts @prealizado
    @forms = QuestionarioEgresso.where(form_acad_id: asFormAcads.map(&:id)).where(filtro_curso).where("realizado = '"+@realizado+"'").where("updated_at <= (?)" , @pdata_ate)
    @questionario_egressos = @forms.paginate(page: params[:page], per_page: 5).order("egresso_id")

end
  # GET /questionario_egressos/1
  # GET /questionario_egressos/1.json
  def show

  end

  # GET /questionario_egressos/new
  def new

    @questionario_egresso = QuestionarioEgresso.new
  end

  # GET /questionario_egressos/1/edit
  def edit

  end

  # POST /questionario_egressos
  # POST /questionario_egressos.json
  def create
    @questionario_egresso = QuestionarioEgresso.new(questionario_egresso_params)

    respond_to do |format|
      if @questionario_egresso.save
        format.html { redirect_to questionario_egressos_path, notice: 'Questionario incluído com sucesso.' }
        format.json { render :show, status: :created, location: questionario_egressos_path }
      else
        format.html { render :new }
        format.json { render json: @questionario_egresso.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questionario_egressos/1
  # PATCH/PUT /questionario_egressos/1.json
  def update
    respond_to do |format|
      if @questionario_egresso.update(questionario_egresso_params)
        format.html { redirect_to home_path, notice: 'Questionario preenchido com sucesso.' }
        format.json { render :show, status: :ok, location: questionario_egressos_path }
      else
        format.html { render :edit }
        format.json { render json: @questionario_egresso.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questionario_egressos/1
  # DELETE /questionario_egressos/1.json
  def destroy
    @questionario_egresso.destroy
    respond_to do |format|
      format.html { redirect_to questionario_egressos_path(@questionario_egresso, egresso_id: @questionario_egresso.egresso_id), notice: 'Questionario excluído com sucesso.' }
      format.json { head :no_content }
    end
  end


  def populate_field
    form_acad_id = params[:form_acad_id]
    @form_acad = FormAcad.where( id: form_acad_id).first
    respond_to do |format|
      format.json { render json: @form_acad }
    end
  end
  
  def populate_field2
    egresso_id = params[:egresso_id]
    @form_acad = FormAcad.where( egresso_id: egresso_id)
    respond_to do |format|
      format.json { render json: @form_acad }
    end
  end

   def populate_egresso
    id = params[:egresso_id]
    @egresso = Egresso.where( id: id).first
    respond_to do |format|
      format.json { render json: @egresso }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_questionario_egresso
      @questionario_egresso = QuestionarioEgresso.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def questionario_egresso_params
      params.require(:questionario_egresso).permit(:auxiliar, :nome_curso,:curso_id, :realizado, :form_acad_id, :egresso_id, :ig_idade, :ig_genero, :ig_cor, :ig_est_conjug, :ia_qual_curso, :ia_nome_curso, :ia_ano_iniciou, :ia_ano_concluiu, :ia_satisf_palestras, :ia_satisf_oficina, :ia_satisf_minicurso, :ia_satisf_seminario, :ia_satisf_vis_tec, :ia_satisf_estagio, :ia_satisf_prat_prof, :ia_satisf_bolsas, :ia_est_dur_curso, :ia_empresa_pq_sim, :ia_empresa_pq_nao, :ia_avalia_curso, :ia_nessec_atlzr, :ia_fazer_atlzr, :saip_esta_inst, :saip_back_inst, :saip_curso_atual, :saip_pq_back, :saip_pqnao_back, :saip_trab_atual, :saip_trab_area, :saip_tempo, :saip_vinculo, :saip_local, :saip_renda, :saip_ja_trab, :saip_prim_oport, :saip_pq_nao_esta, :saip_texto1, :saip_pq_nunca, :saip_texto2)
    end
end

