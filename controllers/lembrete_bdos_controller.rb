class LembreteBdosController < ApplicationController

  before_action :set_lembrete_bdo, only: [:show]

  include ApplicationHelper 

  # GET /divulga_avulsas
  # GET /divulga_avulsas.json
  def index
    checar_super
  end

  def lembrete_bdo
    checar_super
    @errors = 0
    @curso = params[:pcurso]
    @texto = params[:ptexto]
    @count = 0

    @egressos = Egresso.where.not(email_princ: nil).where.not(email_princ: "").where(id: FormAcad.where(nome_curso: @curso).map(&:egresso_id))
    @egressos.each do |egresso|
      @egresso= egresso
      if User.where(egresso_id: @egresso.id).where(email: @egresso.email_princ).present?
        begin
          ExampleMailer.lembrete_bdo(@egresso,@texto).deliver
          @count += 1
        rescue Errno::ECONNREFUSED, Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
          @errors += 1
        end
      end
    end

    if @errors > 0
      message = 'Mensagem encaminhada para '+@count.to_s+' profissional(is) com sucesso e '+@errors.to_s+' erros(s) encontrado(s), desconsiderando os usuários sem acesso.'
    else
      message = 'Mensagem encaminhada para '+@count.to_s+' profissional(is) com sucesso e nenhum erro foi econtrado, desconsiderando usuários sem acesso.'
    end
    redirect_to :back , notice: message
  end

end