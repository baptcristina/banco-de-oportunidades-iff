class ExampleMailer < ApplicationMailer
  default from: 'egressoscampos.centro@iff.edu.br'
  layout 'mailer'

    def sample_email(usuario,fale_conosco)
      @usuario = usuario
      @fale_conosco = fale_conosco
      mail(to: 'egressoscampos.centro@iff.edu.br', subject: 'Mensagem recebida pelo Banco de Oportunidades')
    end

  def fale_conosco_email(empressa,fale_conosco)
      @empressa = empressa
      @fale_conosco = fale_conosco
      mail(to: @fale_conosco.email, subject: 'Recebimento de mensagem pelo Fale Conosco - Banco de Oportunidades IFF Campus Campos Centro')
    end

  def aviso_oportunidade_email(egresso,oportunidade)
      @egresso = egresso
      @oportunidade = oportunidade
      mail(to: @egresso.email_princ, subject: 'Aviso de Oportunidade - Banco de Oportunidades IFF Campus Campos Centro')
    end


  def acesso_email(egresso)
      @egresso = egresso
      mail(to: @egresso.email_princ, subject: 'Primeiro Acesso - Banco de Oportunidades IFF Campus Campos Centro')
    end

  def lembrete_bdo(egresso,texto)
      @texto = texto
      @egresso = egresso
      mail(to: @egresso.email_princ, subject: 'Informação')
    end

  def divulga_avulsa(egresso,texto)
      @texto = texto
      @egresso = egresso
      mail(to: @egresso.email_princ, subject: 'Emprego')
    end
end