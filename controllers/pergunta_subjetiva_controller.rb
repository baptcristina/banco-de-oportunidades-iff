class PerguntaSubjetivaController < ApplicationController

  def show
    checar_super
    render 'pergunta_subjetiva/pergunta_subjetiva'
  end

  def pesquisar
    checar_super
    @pnome = params[:pnome]
    @pdata_ini = params[:pdata_ini]
    @pdata_fim = params[:pdata_fim]
    @pcurso = params[:pcurso]

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
    if not( @pdata_ini.present?) && not(@pdata_fim.present?) && @curso.present?
      asFormAcads = FormAcad.where(egresso_id: osEgressos.map(&:id)).where(filtro_curso)
    else
      asFormAcads = FormAcad.where(egresso_id: osEgressos.map(&:id))
    end
  end
    @forms = QuestionarioEgresso.where(form_acad_id: asFormAcads.map(&:id))

    @questionario_egressos = @forms.paginate(page: params[:page], per_page: 5).order("egresso_id")
  end

end