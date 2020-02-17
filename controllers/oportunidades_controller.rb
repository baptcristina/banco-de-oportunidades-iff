class OportunidadesController < ApplicationController
  devise_group :person, contains: [:user, :admin, :empressa]
  before_action :authenticate_person!
  before_action :set_oportunidade, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper

  # GET /oportunidades
  # GET /oportunidades.json
 
 def index
      checar_empresa_super
      empresa_id = params[:empresa_id]
      @pinstituicao = params[:pinstituicao]
      @pcurso = params[:pcurso]
      @pcargo = params[:pcargo]
      @pinicio = params[:pinicio]
      @pfim = params[:pfim]
      @psituacao = params[:psituacao]    

        asEmpresas = Empresa.all
        if @pinstituicao.present?
          filtro = "razao_social like '%"+@pinstituicao+"%'"
          asEmpresas_filtradas = asEmpresas.where(filtro)
        else
          asEmpresas_filtradas = asEmpresas.all
        end
        asOportunidades = Oportunidade.where(empresa: asEmpresas_filtradas.ids)

        if @pcurso.present?
          filtro = "curso like  '%"+@pcurso+"%'"
        else
          filtro = "1=1"
        end
        @asOportunidades_finais1 = asOportunidades.where(filtro)

        if @pcargo.present?
          filtro = "cargo ilike  '%"+@pcargo+"%'"
        else
          filtro = "1=1"
        end
        @asOportunidades_finais = @asOportunidades_finais1.where(filtro)

        if @pinicio.present?
          if @pfim.present?
            asOportunidades = @asOportunidades_finais.where("ini_oferta >= (?) AND fim_oferta <= (?)", @pinicio.to_time, @pfim.to_time)
          else
            asOportunidades = @asOportunidades_finais.where("ini_oferta >= (?)", @pinicio.to_time)
          end
        else
          if @pfim.present?          
            asOportunidades = @asOportunidades_finais.where("fim_oferta <= (?)", @pfim.to_time)
          else
            asOportunidades = @asOportunidades_finais.all
          end
        end
        
        if @psituacao == "C" || @psituacao == "E" || @psituacao == "X"
          if @psituacao == "C"
            @situacao = "Cancelada"
          end
          if @psituacao == "E"  
            @situacao = "Encerrada"
          end
          if @psituacao == "X"
            @situacao = "Expirada"
          end
        else
          @situacao = "Vigente"
        end

        @asOportunidades_S = asOportunidades.where("situacao like '%"+@situacao+"%'")
        asOportunidades = @asOportunidades_S         

    if current_admin.try(:super?)
        @oportunidades = asOportunidades.paginate(page: params[:page], per_page: 5).order("empresa_id","fim_oferta DESC")  
    else
        asOportunidades = asOportunidades.where( :empresa => current_empressa.empresa)
        @oportunidades = asOportunidades.paginate(page: params[:page], per_page: 5).order("fim_oferta DESC")
    end
  end



  # GET /oportunidades/1
  # GET /oportunidades/1.json
  def show 
    checar_egresso_empresa_super_show_empresa 
    @oportunidade = Oportunidade.find(params[:id])
  end

  def mostrar
    checar_empresa_super
    cnpj = params[:cnpj]
    @empresa = Empresa.where(cnpj: cnpj).first
    respond_to do |format|
       format.html { render :show }
    end
  end

  # GET /oportunidades/new
  def new
    checar_empresa_super
    if not params[:pidioma].nil?
      session[:pidioma]=params[:pidioma]
    else
      session[:pidioma]=""
    end
    if not params[:ptipo].nil?
      session[:ptipo]=params[:ptipo]
    else
      session[:ptipo]=""
    end
    @oportunidade = Oportunidade.new 

  end

  # GET /oportunidades/1/edit
  def edit
    checar_empresa_super
    session[:pidioma]=@oportunidade.pidioma
    session[:ptipo]=@oportunidade.ptipo
  end

  # POST /oportunidades
  # POST /oportunidades.json
  def create
    session[:empresa_id] = current_empressa.try(:empresa_id)
    
    @oportunidade = Oportunidade.new(oportunidade_params)
    
    respond_to do |format|
      if @oportunidade.save
        ahoy.track "Oportunidade Criada", {language: "Ruby", curso: @oportunidade.curso, created_at: @oportunidade.created_at}
        format.html { redirect_to oportunidades_path(@oportunidade, empresa_id: @oportunidade.empresa_id), notice: 'Oportunidade criada com sucesso.' }
        format.json { render oportunidades_path, status: :created, location: @oportunidade }
      else
        session[:pidioma]=@oportunidade.pidioma
        session[:ptipo]=@oportunidade.ptipo
        format.html { render :new, locals: { pidioma: @oportunidade.pidioma, ptipo: @oportunidade.ptipo}}
        format.json { render json: @oportunidade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /oportunidades/1
  # PATCH/PUT /oportunidades/1.json
  def update
    
    respond_to do |format|
      if @oportunidade.update(oportunidade_params)
        if oportunidade_params[:ptipo] == nil
          @oportunidade.ptipo = nil
          @oportunidade.save
        end
        format.html { redirect_to oportunidades_path(@oportunidade, empresa_id: @oportunidade.empresa_id), notice: 'Oportunidade atualizada com sucesso.' }
        format.json { render oportunidades_path, status: :ok, location: @oportunidade }
      else
        format.html { render :edit }
        format.json { render json: @oportunidade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /oportunidades/1
  # DELETE /oportunidades/1.json
  def destroy

    @oportunidade.destroy
    respond_to do |format|
      format.html { redirect_to oportunidades_path(@oportunidade, empresa_id: @oportunidade.empresa_id), notice: 'Oportunidade excluída com sucesso.' }
      format.json { head :no_content }
    end
  end

  def enviar_email
    @erro = 0
    @oportunidade = Oportunidade.where(id: params[:oportunidade]).first

     @nomes_curso = Curso.where(titulacao_id: Titulacao.where(titulo: @oportunidade.curso).first.id).or(Curso.where(nome: @oportunidade.curso))

     @form_ids = []
     @nomes_curso.each do |nome_curso|
        filtro = "nome_curso like '%"+nome_curso.nome+"%'"
        @form_ids << FormAcad.where(filtro).where(habilitado: false).map(&:id)
      end
      @array_ids = []
      (1..@form_ids.length).each do |i|
        @array_ids = @array_ids + @form_ids[i-1]
      end
      @forms = FormAcad.where(id: @array_ids)
 
    if not(@oportunidade.panoconclusao_fim == nil) && not(@oportunidade.panoconclusao_inicio == nil)
        @form_acad_filtrado = @forms.where('data_fim <= (?)',@oportunidade.panoconclusao_fim).where('data_fim >= (?)', @oportunidade.panoconclusao_inicio).where(habilitado: false).map(&:egresso_id)
      end
    if (@oportunidade.panoconclusao_fim == nil)&& not(@oportunidade.panoconclusao_inicio == nil)
        @form_acad_filtrado = @forms.where('data_fim >= (?)', @oportunidade.panoconclusao_inicio).where(habilitado: false).map(&:egresso_id)
    end
    if not(@oportunidade.panoconclusao_fim == nil)&& (@oportunidade.panoconclusao_inicio == nil)
       @form_acad_filtrado = @forms.where('data_fim <= (?)',@oportunidade.panoconclusao_fim).where(habilitado: false).map(&:egresso_id)
    end
    if (@oportunidade.panoconclusao_fim == nil && @oportunidade.panoconclusao_inicio == nil)
      @form_acad_filtrado = @forms.where(habilitado: false).map(&:egresso_id)
    end
    

    if @oportunidade.pidioma == "" && @oportunidade.ptipo == nil
      @egressos = Egresso.where(id: @form_acad_filtrado).uniq
    end

     if (not @oportunidade.pidioma == "") &&  @oportunidade.ptipo == nil
      @egressos = Egresso.where(id: @form_acad_filtrado).where(id: Idioma.where(descricao: @oportunidade.pidioma).map(&:egresso_id)).uniq
    end

     if (not @oportunidade.pidioma == "") && not( @oportunidade.ptipo == nil)
      @egressos = Egresso.where(id: @form_acad_filtrado).where(id: Idioma.where(descricao: @oportunidade.pidioma).where("valor >= (?)",@oportunidade.ptipo).map(&:egresso_id)).uniq
    end

    @egressos.where.not(email_princ: nil).each do |egresso|
      @egresso= egresso
        begin
          ExampleMailer.aviso_oportunidade_email(@egresso,@oportunidade).deliver
        rescue Errno::ECONNREFUSED, Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
          @erro +=1
        end
    end

        if @erro > 0 
          redirect_to :back , alert: 'Falha na comunicação, '+(@egressos.count-@erro).to_s+' emails foram enviados. Contudo, todos os profissionais que se enquadram no perfil têm acesso a esta oportunidade.'
        else          
          message = 'Oportunidade encaminhada para '+@egressos.count.to_s+' profissional(is) com sucesso.'
          redirect_to :back, notice: message 
        end
  end

  def clonar
    oport_id = params[:oportunidade_id]
    aOportunidade = Oportunidade.where(id: oport_id).first
    oport = Oportunidade.new(contato_id: aOportunidade.id, empresa_id: aOportunidade.empresa_id, curso: nil, cargo: aOportunidade.cargo, requisitos: aOportunidade.requisitos, salario: aOportunidade.salario, observacoes: aOportunidade.observacoes, local_inscricao: aOportunidade.local_inscricao, fim_oferta: nil, ini_oferta: nil, tipo_oferta: aOportunidade.tipo_oferta, formadoa: aOportunidade.formadoa, nivel: aOportunidade.nivel, descricao: aOportunidade.descricao, panoconclusao_inicio: aOportunidade.panoconclusao_inicio, panoconclusao_fim: aOportunidade.panoconclusao_fim, pidioma: aOportunidade.pidioma, ptipo: aOportunidade.ptipo, dispo: aOportunidade.dispo, visivel: aOportunidade.visivel, situacao: nil)
    oport.save(validate: false)
    if oport.save
      ahoy.track "Oportunidade Criada", {language: "Ruby", curso: oport.curso, created_at: oport.created_at}
    end
    redirect_to edit_oportunidade_path(oport, id: oport.id, empresa_id: oport.empresa_id, clone: 'yes'), notice: 'Oportunidade duplicada com sucesso. Favor inserir informações não preenchidas.'
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_oportunidade
      @oportunidade = Oportunidade.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def oportunidade_params
       params.require(:oportunidade).permit(:contato_id, :empresa_id, :curso, :cargo, :requisitos, :salario, :observacoes, :local_inscricao, :fim_oferta, :ini_oferta, :tipo_oferta, :formadoa, :nivel, :descricao, :panoconclusao_inicio, :panoconclusao_fim, :pidioma, :ptipo, :dispo, :visivel, :situacao)
    end
end

