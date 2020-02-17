class PrimacessosController < ApplicationController
  before_action :set_primacesso, only: [:show]

include ApplicationHelper
  # GET /primacessos
  # GET /primacessos.json

  # GET /primacessos/1
  # GET /primacessos/1.json
  def index
    checar_super
  end

  def enviar
    checar_super
    @errors = 0
    @semestre = params[:psemestre]
    @curso = params[:pcurso]
    @acesso = params[:pacesso]
    @count = 0

    if @acesso == '0'
      @egressos = Egresso.where.not(email_princ: nil).where.not(email_princ: "").where(id: FormAcad.where(nome_curso: @curso).where(semestre_letivo: @semestre).map(&:egresso_id))
    else
      @egressos = Egresso.where.not(email_princ: nil).where.not(email_princ: "").where(id: FormAcad.where(nome_curso: @curso).where(semestre_letivo: @semestre).map(&:egresso_id)).where(primacesso: 0)
      puts @egresso.try(:count)
    end
    @egressos.each do |egresso|
      @egresso= egresso
      if User.where(egresso_id: @egresso.id).where(email: @egresso.email_princ).present?
        begin
          ExampleMailer.acesso_email(@egresso).deliver
          @egresso.primacesso = true
          @egresso.save
          @count += 1
          puts @count
        rescue Errno::ECONNREFUSED, Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
          @errors += 1
        end
      end
    end
    if @errors > 0
      message = 'Convite encaminhado para '+@count.to_s+' profissional(is) com sucesso e '+@errors.to_s+' erros(s) encontrado(s), desconsiderando os usuários sem acesso.'
    else
      message = 'Convite encaminhado para '+@count.to_s+' profissional(is) com sucesso e nenhum erro foi econtrado, desconsiderando usuários sem acesso.'
    end
    redirect_to :back , notice: message
  end

  def filtro
    curso = params[:curso]
    @form = FormAcad.none
    @form_acad = FormAcad.where(nome_curso: curso).where(habilitado: false).group(:semestre_letivo).sum(:id).sort

    respond_to do |format|
      format.json { render json: @form_acad }
    end
  end


  def filtro2
    @form_acad = FormAcad.where(nome_curso: params[:curso]).where(habilitado: false).where(semestre_letivo: params[:semestre])

    respond_to do |format|
      format.json { render json: @form_acad }
    end
  end
end

