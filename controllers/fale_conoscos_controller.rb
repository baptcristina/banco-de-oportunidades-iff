class FaleConoscosController < ApplicationController
    before_action :set_fale_conosco, only: [:show, :edit, :update, :destroy]

  # GET /fale_conoscos
  # GET /fale_conoscos.json
  def index
    @fale_conoscos = FaleConosco.all
  end

  # GET /fale_conoscos/1
  # GET /fale_conoscos/1.json
  def show
  end

  # GET /fale_conoscos/new
  def new
    @fale_conosco = FaleConosco.new
  end

  # GET /fale_conoscos/1/edit
  def edit
  end

  # POST /fale_conoscos
  # POST /fale_conoscos.json
  def create
    @fale_conosco = FaleConosco.new(fale_conosco_params)
    begin
    if user_signed_in?
          ExampleMailer.fale_conosco_email(@current_user,@fale_conosco).deliver
          @usuario=@current_user
    else
      if empressa_signed_in?
          ExampleMailer.fale_conosco_email(@current_empressa,@fale_conosco).deliver
          @usuario=@current_empressa
      else
        if  admin_signed_in?
          ExampleMailer.fale_conosco_email(@current_admin,@fale_conosco).deliver
          @usuario=@current_admin
        else
          ExampleMailer.fale_conosco_email(@fale_conosco,@fale_conosco).deliver
          @usuario=@fale_conosco
        end
      end
    end
    rescue Exception
        i = 1
    end
    ExampleMailer.sample_email(@usuario,@fale_conosco).deliver

    respond_to do |format|
      if i == 1
         format.html { redirect_to "/", alert: 'Erro no envio da mensagem. Favor tentar novamente.' }
      else
        if @fale_conosco.save
          format.html { redirect_to "/", notice: 'Sua mensagem foi enviada com sucesso.' }
          format.json { render :show, status: :created, location: home_path }
        else
          format.html { render :new }
          format.json { render json: @fale_conosco.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /fale_conoscos/1
  # PATCH/PUT /fale_conoscos/1.json
  def update
    respond_to do |format|
      if @fale_conosco.update(fale_conosco_params)
        format.html { redirect_to @fale_conosco, notice: 'Fale conosco was successfully updated.' }
        format.json { render :show, status: :ok, location: @fale_conosco }
      else
        format.html { render :edit }
        format.json { render json: @fale_conosco.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fale_conoscos/1
  # DELETE /fale_conoscos/1.json
  def destroy
    @fale_conosco.destroy
    respond_to do |format|
      format.html { redirect_to fale_conoscos_url, notice: 'Fale conosco was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fale_conosco
      @fale_conosco = FaleConosco.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fale_conosco_params
      params.require(:fale_conosco).permit(:email, :assunto, :mensagem)
    end
end
