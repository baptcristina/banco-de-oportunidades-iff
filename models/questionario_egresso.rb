class QuestionarioEgresso < ApplicationRecord
    self.primary_key = :id
  belongs_to :egresso, :class_name => 'Egresso', optional: true
  belongs_to :curso, class_name: "Curso", optional: true
  belongs_to :form_acad, class_name: 'FormAcad', optional: true

  validates_presence_of :saip_back_inst, if: Proc.new { |a| a.saip_esta_inst == 'Não' }
  validates_presence_of :saip_pq_nao_esta,  if: Proc.new { |a| a.saip_ja_trab == 'Sim' }
  validates_presence_of :saip_prim_oport,  if: Proc.new { |a| a.saip_ja_trab == 'Sim' }
  validates_presence_of :saip_pq_nunca,   if: Proc.new { |a| a.saip_ja_trab == 'Não' }
  validates_presence_of :saip_tempo,   if: Proc.new { |a| a.saip_trab_atual == 'Sim' && a.saip_trab_area == 'Sim' }
  validates_presence_of :saip_vinculo,   if: Proc.new { |a| a.saip_trab_atual == 'Sim' && a.saip_trab_area == 'Sim' }
  validates_presence_of :saip_local,  if: Proc.new { |a| a.saip_trab_atual == 'Sim' && a.saip_trab_area == 'Sim' }
  validates_presence_of :saip_renda,  if: Proc.new { |a| a.saip_trab_atual == 'Sim' && a.saip_trab_area == 'Sim' }
  validates_presence_of :saip_curso_atual,  if: Proc.new { |a| a.saip_esta_inst == 'Sim'  }
  validates_presence_of :saip_pq_back,    if: Proc.new { |a| a.saip_back_inst == 'Sim'  }
  validates_presence_of :saip_pqnao_back,   if: Proc.new { |a| a.saip_back_inst == 'Não'  }
  validates_presence_of :ia_fazer_atlzr,  if: Proc.new { |a| a.ia_nessec_atlzr == 'Sim'  }
  validates_presence_of :ia_empresa_pq_sim,    if: Proc.new { |a| a.ia_est_dur_curso == 'Sim'  }
  validates_presence_of :ia_empresa_pq_nao,   if: Proc.new { |a| a.ia_est_dur_curso == 'Não'  }
  validates_presence_of :ia_satisf_bolsas
  validates_presence_of :ia_satisf_palestras
  validates_presence_of :ia_satisf_oficina
  validates_presence_of :ia_satisf_minicurso
  validates_presence_of :ia_satisf_estagio
  validates_presence_of :ia_satisf_seminario
  validates_presence_of :ia_satisf_vis_tec
  validates_presence_of :ia_satisf_prat_prof
  validates_presence_of :ia_est_dur_curso
  validates_presence_of :ia_avalia_curso
  validates_presence_of :ia_nessec_atlzr
  validates_presence_of :saip_esta_inst
  validates_presence_of :saip_trab_atual
  validates_presence_of :saip_trab_area, if: Proc.new { |a| a.saip_trab_atual == 'Sim' }
  validates_presence_of :saip_ja_trab, if: Proc.new { |a| a.saip_trab_atual == 'Não' && a.saip_trab_area == 'Não' }




attr_accessor :data_fim

def attributes
  super.merge('data_fim' => self.data_fim)
end

require 'csv'

def self.import(file)
    
      asFormAcads = FormAcad.where(nome_curso: 'Técnico em Mecânica')
      osEgressos = Egresso.none
      asFormAcads.each do |aFormAcad|
        oEgresso = Egresso.where(id: aFormAcad.egresso_id)
          osEgressos += oEgresso
        end
      osEgressosFiltrados = Egresso.where(id: osEgressos.map(&:id)).where.not(cpf: nil).where.not(email_princ: nil)
      array = osEgressosFiltrados.ids
      i = 0
      j = 0
  CSV.foreach(file.path) do |row|
      ia_satisf_palestra = row[0]
      ia_satisf_oficina = row[1]
      ia_satisf_minicurso = row[2]
      ia_satisf_seminario = row[3]
      ia_satisf_vis_tec = row[4]
      ia_satisf_estagio = row[5]
      ia_satisf_prat_prof = row[6]
      ia_satisf_bolsas = row[7]
      ia_est_dur_curso = row[8]
      ia_empresa_pq_nao = row[9]
      ia_avalia_curso = row[10]
      ia_nessec_atlzr = row[11]
      ia_fazer_atlzr = row[12]
      saip_esta_inst = row[13]
      saip_back_inst = row[14]
      saip_curso_atual = row[15]
      saip_pqnao_back = row[16]
      saip_trab_atual = row[17]
      saip_trab_area = row[18]
      saip_tempo = row[19]
      saip_vinculo = row[20]
      saip_local = row[21]
      saip_renda = row[22]
      saip_ja_trab = row[23]
      saip_prim_oport = row[24]
      saip_pq_nao_esta = row[25]
      saip_pq_nunca = row[26]
      ia_empresa_pq_sim = row[27]
      saip_pq_back = row[28]

      QuestionarioEgresso.create!( realizado: true, egresso_id: array[i], form_acad_id: FormAcad.where(egresso_id: array[i]).first.id, curso_id: 6, nome_curso: 'Técnico em Mecânica' , ia_satisf_palestras: ia_satisf_palestra, ia_satisf_oficina: ia_satisf_oficina, ia_satisf_minicurso: ia_satisf_minicurso, ia_satisf_seminario: ia_satisf_seminario, ia_satisf_vis_tec: ia_satisf_vis_tec, ia_satisf_prat_prof: ia_satisf_prat_prof, ia_satisf_bolsas: ia_satisf_bolsas, ia_satisf_estagio: ia_satisf_estagio, ia_est_dur_curso: ia_est_dur_curso, ia_empresa_pq_nao: ia_empresa_pq_nao, ia_avalia_curso: ia_avalia_curso, ia_nessec_atlzr: ia_nessec_atlzr, ia_fazer_atlzr: ia_fazer_atlzr, saip_esta_inst: saip_esta_inst, saip_back_inst: saip_back_inst, saip_curso_atual: saip_curso_atual, saip_pqnao_back: saip_pqnao_back, saip_trab_atual: saip_trab_atual, saip_trab_area: saip_trab_area, saip_tempo: saip_tempo, saip_vinculo: saip_vinculo, saip_local: saip_local, saip_renda: saip_renda, saip_ja_trab: saip_ja_trab, saip_prim_oport: saip_prim_oport, saip_pq_nao_esta: saip_pq_nao_esta, saip_pq_nunca: saip_pq_nunca, ia_empresa_pq_sim: ia_empresa_pq_sim, saip_pq_back: saip_pq_back )
 	    i += 1
      j += 1
      if j == 39
        break
      end
  end
end

end
