class RelatoriosController < ApplicationController
  devise_group :person, contains: [:admin]
  before_action :authenticate_person!
  before_action :set_relatorio, only: [:show, :edit, :update, :destroy]

  # GET /relatorios
  # GET /relatorios.json

 def importquestionario
begin
  QuestionarioEgresso.import(params[:file])
  redirect_to :back  
end
end



  def index
    egresso_id = params[:egresso_id]
    if not egresso_id.nil?
      asFormAcads = FormAcad.where(egresso_id: egresso_id).where(habilitado: false)
      form_ids = []
      asFormAcads.each do |formacad|
        form_ids << formacad.relatorio_id
      end
      osRelatorios = Relatorio.where(id: form_ids)
    else
      osRelatorios = Relatorio.all
    end
    @relatorios = osRelatorios.paginate(page: params[:page], per_page: 5).order("created_at DESC")
  end

  # GET /relatorios/1
  # GET /relatorios/1.json
  def show

    relatorio_id = params[:relatorio_id]
    asFormAcads = FormAcad.where(relatorio_id: relatorio_id);
    osEgressos = Egresso.none
    asFormAcads.each do |aFormAcad|
      oEgresso = Egresso.where(id: aFormAcad.egresso_id)
      if not(oEgresso.first.cpf.present?)||not(oEgresso.first.email_princ.present?)||not(aFormAcad.data_fim.present?)
        osEgressos += oEgresso
      end
    end
    @osEgressos= Egresso.where(id: osEgressos.map(&:id)).paginate(page: params[:page], per_page: 5).order("id")
  end

   

  # GET /relatorios/new
  def new
    @relatorio = Relatorio.new
  end

  # GET /relatorios/1/edit
  def edit
  end

  # POST /relatorios
  # POST /relatorios.json
  def create
    @relatorio = Relatorio.new(relatorio_params)

    respond_to do |format|
      if @relatorio.save
        format.html { redirect_to @relatorio, notice: 'Relatório criado com sucesso.' }
        format.json { render :show, status: :created, location: @relatorio }
      else
        format.html { render :new }
        format.json { render json: @relatorio.errors, status: :unprocessable_entity }
      end
    end
  end

def deletar
    id = params[:id]
    relatorio = Relatorio.where(id: id).first
    relatorio.tipo = 'Importação de egressos do banco de dados do Registro Acadêmico (importação revertida)  -'+ relatorio.arquivo.to_s
        @forms_acads = FormAcad.where(relatorio_id: relatorio.id)
        @forms_acads.each do |forms_acad|
          oEgresso = Egresso.where(id: forms_acad.egresso_id).first
          forms_acad.destroy
          if not(FormAcad.where(egresso_id: oEgresso.id).present?)
            oEgresso.destroy
          end
        end
    relatorio.save!
    redirect_to relatorios_path
end

def deletar_registro
    id = params[:relatorio_id]
    relatorio = Relatorio.where(id: id).first
    relatorio.tipo = 'Importação de egressos do banco de dados do Registro Acadêmico (importação parcialmente revertida) -'+ relatorio.arquivo.to_s
    oEgresso = Egresso.where(id: params[:egresso_id]).first
    aFormAcad = FormAcad.where(relatorio_id: id).where(egresso_id: oEgresso.id).first
    aFormAcad.destroy
    if not(FormAcad.where(egresso_id: oEgresso.id).present?)
      oEgresso.destroy
    end

    erros = relatorio.quantidade_erros.to_i
    relatorio.quantidade_erros  = erros -1.to_i
    relatorio.save!
    redirect_to :back
end

  # PATCH/PUT /relatorios/1
  # PATCH/PUT /relatorios/1.json
  def update
    respond_to do |format|
      if @relatorio.update(relatorio_params)
        format.html { redirect_to @relatorio, notice: 'Relatório atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @relatorio }
      else
        format.html { render :edit }
        format.json { render json: @relatorio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /relatorios/1
  # DELETE /relatorios/1.json
  def destroy
    @relatorio.destroy
    respond_to do |format|
      format.html { redirect_to relatorios_url, notice: 'Relatório excluído com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_relatorio
      @relatorio = Relatorio.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def relatorio_params
      params.require(:relatorio).permit(:tipo, :quantidade_total, :quantidade_erros)
    end
end
