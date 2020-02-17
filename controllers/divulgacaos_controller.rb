class DivulgacaosController < ApplicationController
  before_action :set_divulgacao, only: [:show, :edit, :update, :destroy]
  
    include ApplicationHelper 
  # GET /divulgacaos
  # GET /divulgacaos.json
  def index
    checar_super_agencia
    @data_ini = params[:pinicio]
    @data_fim = params[:pfim]
    


        if @data_ini.present?
          if @data_fim.present?
            @asDivulgacoes = Divulgacao.where("created_at >= (?) AND created_at <= (?)", @data_ini.to_time, @data_fim.to_time)
          else
            @asDivulgacoes = Divulgacao.where("created_at >= (?)", @data_ini.to_time)
          end
        else
          if @data_fim.present?          
            @asDivulgacoes = Divulgacao.where("created_at <= (?)", @data_fim.to_time)
          else
            @asDivulgacoes = Divulgacao.all
          end
        end
        @divulgacaos = @asDivulgacoes.all.paginate(page: params[:page], per_page: 5).order("created_at DESC")
  end

  # GET /divulgacaos/1
  # GET /divulgacaos/1.json
  def show
    checar_super_agencia
  end

  # GET /divulgacaos/new
  def new
    checar_super_agencia
    @divulgacao = Divulgacao.new
  end

  # GET /divulgacaos/1/edit
  def edit
    checar_super_agencia
  end

  # POST /divulgacaos
  # POST /divulgacaos.json
  def create
    @divulgacao = Divulgacao.new(divulgacao_params)

    respond_to do |format|
      if @divulgacao.save
        format.html { redirect_to divulgacaos_path, notice: 'Divulgação foi criada com sucesso.' }
        format.json { render :show, status: :created, location: @divulgacao }
      else
        format.html { render :new }
        format.json { render json: @divulgacao.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /divulgacaos/1
  # PATCH/PUT /divulgacaos/1.json
  def update
    respond_to do |format|
      if @divulgacao.update(divulgacao_params)
        format.html { redirect_to divulgacaos_path, notice: 'Divulgação foi atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @divulgacao }
      else
        format.html { render :edit }
        format.json { render json: @divulgacao.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /divulgacaos/1
  # DELETE /divulgacaos/1.json
  def destroy
    @divulgacao.destroy
    respond_to do |format|
      format.html { redirect_to divulgacaos_path, notice: 'Divulgação foi excluída com sucesso' }
      format.json { head :no_content }
    end
  end

  def clonar
    divulg_id = params[:divulgacao_id]
    aDivulgacao = Divulgacao.where(id: divulg_id).first
    divulg = Divulgacao.new(data: aDivulgacao.data, descricao: aDivulgacao.descricao, tipo: aDivulgacao.tipo, situacao: aDivulgacao.situacao, preview: aDivulgacao.preview, assunto_evento: aDivulgacao.assunto_evento, foto1: aDivulgacao.foto1, link1: aDivulgacao.link1, foto2: aDivulgacao.foto2, link2: aDivulgacao.link2, foto3: aDivulgacao.foto3, link3: aDivulgacao.link3, foto4: aDivulgacao.foto4, link4: aDivulgacao.link4, assunto_video: aDivulgacao.assunto_video, video: aDivulgacao.video)
    divulg.save
    redirect_to divulgacaos_path, notice: 'Divulgacao duplicada com sucesso. Favor inserir informações não preenchidas.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_divulgacao
      @divulgacao = Divulgacao.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def divulgacao_params
      params.require(:divulgacao).permit(:data, :descricao, :tipo, :situacao, :preview, :assunto_evento, :foto1, :link1, :foto2, :link2 ,:foto3, :link3, :foto4, :link4, :assunto_video, :video, infos_attributes: [:id, :_destroy,:assunto, :conteudo, :link, :anexos, :divulgacao_id], feeds_attributes: [:id, :_destroy,:assunto, :conteudo, :divulgacao_id])
    end
end
