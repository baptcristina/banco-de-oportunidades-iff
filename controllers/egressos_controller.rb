class EgressosController < ApplicationController
  devise_group :person, contains: [:user, :admin, :empressa]
  before_action :authenticate_person!
  
  before_action :set_egresso, only: [:show, :edit, :update, :destroy]


  include ApplicationHelper
  
  # GET /egressos
  # GET /egressos.json
  def index
    checar_super
    @pnome_completo = params[:pnome_completo]
    @perrados = params[:perrados]
    filtro = "1=1"


    if not(@pnome_completo.nil?)
      if  @perrados ==  'S' 
        filtro = "cpf is not null and email_princ is not null and nome_completo like '%"+@pnome_completo+"%'"
        osEgressos = Egresso.where(filtro)
        asFormAcads = FormAcad.where(egresso_id: osEgressos.ids).where("data_fim is not null")
        osEgressos_filtrados = Egresso.none
        asFormAcads.each do |aFormAcad|
          oEgresso = Egresso.where(id: aFormAcad.egresso_id)
          osEgressos_filtrados += oEgresso
        end

        osEgressos_filtrados_final =  Egresso.where(id: osEgressos_filtrados.map(&:id))
        @egressos = osEgressos_filtrados_final.paginate(page: params[:page], per_page: 5).order("nome_completo")

        
      else
        if @perrados ==  'C'
         filtro = "cpf is null OR email_princ is null and nome_completo like '%"+@pnome_completo+"%' "
         osEgressos = Egresso.where(filtro)
        osEgressos_filtrados_final =  Egresso.where(id: osEgressos.map(&:id))
        @egressos = osEgressos_filtrados_final.paginate(page: params[:page], per_page: 5).order("nome_completo")

        else
          filtro = "nome_completo like '%"+@pnome_completo+"%'"
           @egressos = Egresso.where(filtro).paginate(page: params[:page], per_page: 5).order("nome_completo")
        end
      end
    else
      @egressos = Egresso.all.paginate(page: params[:page], per_page: 5).order("nome_completo")
    end
  end
   
            
  def pesquisar
    
    egresso_id = current_user.egresso_id
    @forms = FormAcad.where(egresso_id: egresso_id).first
    if @forms.present?
    redirect_to pesquisas_path(@forms, :pformacao => @forms.nome_curso, egresso_id: current_user.egresso_id)
  else
    redirect_to pesquisas_path(FormAcad.all, :pformacao => FormAcad.all.nome_curso)
  end
  end

  def deletar
    checar_super
    Egresso.where("1=1").delete_all
    FormAcad.where("1=1").delete_all
    FormCompl.where("1=1").delete_all
    ExpProf.where("1=1").delete_all
    AtivAut.where("1=1").delete_all
    Compet.where("1=1").delete_all
    Idioma.where("1=1").delete_all
    User.where("1=1").delete_all    
    redirect_to home_path
  end


  def reparar_user
      relatorio_id = params[:relatorio_id]
      checar_super
      cpf = params[:cpf]
      @oEgresso = Egresso.where(cpf: cpf).first
      if not(@oEgresso.email_princ.nil?)&&(@oEgresso.email_princ =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
        filtro = "email like '%"+@oEgresso.email_princ+"%'"
        if User.where(filtro).count == 1
          i = 1
          filtro2 = "email like '%%'"
          while User.where(filtro2).count != 1  do
            filtro2 = "email like '%"+i.to_s+@oEgresso.email_princ.to_s+"%'"
            if User.where(filtro2).count == 0
                @email = i.to_s+@oEgresso.email_princ.to_s
                @oEgresso.email_princ = @email
                @oEgresso.save!
                break
            else
                i += 1
            end
          end
        end
      else
        @email = "egresso"+@oEgresso.id.to_s+"@troque.seu.email"
        @oEgresso.email_princ = @email
        @oEgresso.skip_fields_validation = true
        @oEgresso.save!        
      end
      User.create!(email: @email, password: "123456", password_confirmation: "123456", egresso_id: @oEgresso.id, tipo_usuario: "1") 
      osRelatorios = Relatorio.where(id: FormAcad.where(egresso_id: @oEgresso.id).map(&:relatorio_id))
      osRelatorios.each do |relatorio|
        relatorio.quantidade_erros = relatorio.quantidade_erros.to_i - 1
        relatorio.save!
      end
      redirect_to relatorios_path(egresso_id: @oEgresso.id)
  end

  # GET /egressos/1
  # GET /egressos/1.json
  def show
    checar_egresso_empresa_super
  end

  def mostrar
    checar_egresso_empresa_super
    id = params[:egresso_id]
    @egresso = Egresso.where(id: id).first
    respond_to do |format|
       format.html { render :show }
       format.pdf do
          pdf = CurriculoPdf.new(@egresso.id, view_context)
          send_data pdf.render, filename: 'Resultado.pdf', :width =>
          pdf.bounds.width,
          type: 'application/pdf', disposition: :inline, :page_size => "A4",
          :page_layout => :portrait
      end
    end
  end

  # GET /egressos/new
  def new
    checar_super
    @egresso = Egresso.new
  end

  # GET /egressos/1/edit
  def edit
    checar_egresso_super
  end

  # POST /egressos
  # POST /egressos.json
  def create
    @egresso = Egresso.new(egresso_params)

    respond_to do |format|
      if @egresso.save
        format.html { redirect_to @egresso, notice: 'Egresso criado com sucesso.' }
        format.json { render :show, status: :created, location: @egresso }
      else
        format.html { render :new }
        format.json { render json: @egresso.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /egressos/1
  # PATCH/PUT /egressos/1.json
  def update
    respond_to do |format|
      @egresso.skip_fields_validation = false
      if @egresso.update(egresso_params)
        if current_admin.try(:adm?)
          format.html { redirect_to egressos_path, notice: 'Egresso atualizado com sucesso.' }
          format.json { render :show, status: :ok, location: egressos_path }
        else
          format.html { redirect_to :back, notice: 'Dados atualizados com sucesso.' }
          format.json { render :show, status: :ok, location: :back }
        end

      else
        format.html { render :edit }
        format.json { render json: @egresso.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /egressos/1
  # DELETE /egressos/1.json
  def destroy
    checar_egresso_super
    @egresso.destroy
    respond_to do |format|
      format.html { redirect_to egressos_url, notice: 'Egresso excluído com sucesso.' }
      format.json { head :no_content }
    end
  end

def import
  checar_super
  Egresso.import(params[:file])



end

def listar
  checar_super
   @egressos = Egresso.all.paginate(page: params[:page], per_page: 10)
   respond_to do |format|
    format.html
    format.pdf do
      pdf = ReportPdf.new(@egressos)
      send_data pdf.render, filename: 'ReportPdf.pdf', :width =>
        pdf.bounds.width,
        type: 'application/pdf', disposition: :inline, :page_size => "A4",
        :page_layout => :portrait
    end
  end
end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_egresso
      @egresso = Egresso.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def egresso_params
      params.require(:egresso).permit(:cpf, :nome_completo, :nome_social, :data_nasc, :genero, :link, :est_conjugal, :end_completo, :email_princ, :email_alt, :link_face, :lattes, :lkdn, :tel_res, :tel_com, :tel_cel, :num_zap, :foto, :foto_cache, :relatorio, :remove_foto, :primacesso, :skip_fields_validation)
    end


end

