class ResultadoPdf < Prawn::Document

  def initialize(curso,view, data_ini,data_fim, data_ate)
      super()
      @curso = curso
      @view = view
      @data_ini = data_ini
      @data_fim = data_fim
      @data_ate = (data_ate.to_date-1.days).to_s 

      repeat :all, :dynamic => :true do

        brand = "#{Rails.root}/app/assets/images/iff4.png"

      image brand, :at => [bounds.left , bounds.top], :fit => [120, 125]
        stroke_color "f0f0f0"

        stroke do
      # just lower the current y position
           move_down 50

           vertical_line  25, 720, :at => 0
           vertical_line  25, 720, :at => 540
         
        end

    # header
        bounding_box [bounds.left, bounds.top], :width  => bounds.width do
          fill_gradient [120, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '000000', '149937'
          fill_rectangle [120, "#{cursor}".to_f], 270, 50
          fill_gradient [540, "#{cursor}".to_f+60], 0, [540, "#{cursor}".to_f+60], 540/2, '000000', '149937'
          fill_rectangle [270, "#{cursor}".to_f], 270, 50
            cabecalho 
            corpo
            stroke_color "f0f0f0"
            stroke_bounds 
        end

    bounding_box([bounds.left, bounds.top - 100], :width  => bounds.width, :height => bounds.height - 300) do                 
    titulo
    end
    # footer
        bounding_box [bounds.left, bounds.bottom + 25], :width  => bounds.width do
            rodape
            
        end
      end

    bounding_box([bounds.left, bounds.top - 150], :width  => bounds.width, :height => bounds.height - 300) do                 
      informacoes_gerais
        move_down 10

      informacoes_academicas
        move_down 10

       # situacao_atual

    move_down 5
#    indicadores
   end


  end



def titulo
   data = [["Nome do Curso","","Data de Início","","Data de Término"]]
   data += [["#{@curso.nome}","","#{I18n.l @data_ini.to_date}","","#{I18n.l @data_fim.to_date}"]]

   table(data, position: :center, :cell_style => { border_width: 0.2, :font => "Times-Roman", size: 10, align: :center }
) do

    row(0).background_color = "f0f0f0"
    row(0).column(1).background_color = "ffffff"
    row(0).column(1).borders =[:right, :left]
    row(0).column(1).width = 100
    row(1).column(3).borders =[:right, :left]
    row(0).column(3).borders =[:right, :left]
    row(1).column(1).borders =[:right, :left]
    row(0).column(3).background_color = "ffffff"
    row(0).column(3).width = 100
    row(1).column(3).borders =[:right, :left]
    column(0).width = 330
    column(1).width = 15
    column(2).width = 80
    column(3).width = 15
    column(4).width = 80
    

  end
  linha



end

  def cabecalho
  # header
      bounding_box [bounds.left, bounds.top], :width  => bounds.width do
       move_down 15
       text 'Banco de Oportunidades' , :align => :center, color: 'ffffff', size: 24
       move_down 10
      end
    linha
  end



  def rodape
    bounding_box [bounds.left, bounds.bottom + 0], :width  => bounds.width do
          font "Helvetica"
          stroke_horizontal_rule
          stroke_bounds
          move_down(5)
          text "#{I18n.l Date.today, :format => :long}", :size => 8
      end
      number_pages "<page> / <total>", { :start_count_at => 0, :page_filter => :all, :at => [bounds.right - 50, -25], :align => :right, :size => 10 }
  end

  def corpo
  bounding_box [bounds.left, bounds.top-55], :width  => bounds.width do
          fill_gradient [0, "#{cursor}".to_f], 0, [0, "#{cursor}".to_f+60], 540/2, '000000', '149937'
          fill_rectangle [0, "#{cursor}".to_f], 270, 32
          fill_gradient [540, "#{cursor}".to_f], 0, [540, "#{cursor}".to_f+60], 540/2, '000000', '149937'
          fill_rectangle [270, "#{cursor}".to_f], 270, 32
    move_down 10          
    text "#{Prawn::Text::NBSP}" +"Egressos por data de colação de grau e respostas até "+ (@data_ate.to_date + 1.days).strftime("%d/%m/%y").to_s, :align => :center, size: 16, color: 'ffffff';
    move_down 3
  end
  end

def linha 
  stroke do
        move_down 5
        stroke_color "f0f0f0"
        line_width 1
        stroke_horizontal_rule
      end  
    move_down 5

def linha2
  stroke do
        move_down 5
        stroke_color "f0f0f0"
        line_width 2
        stroke_horizontal_rule
end
      end  
    move_down 5
end


def linha3
  stroke do
        stroke_color 'f0f0ff'
        line_width 1
        stroke_horizontal_rule
      end  
end




def informacoes_gerais
  
  move_down 3
    linha3

fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '000000', '149937'
fill_rectangle [0, "#{cursor}".to_f], 270, 17
fill_gradient [540, "#{cursor}".to_f+60], 0, [540, "#{cursor}".to_f+60], 540/2, '000000', '149937'
fill_rectangle [270, "#{cursor}".to_f], 270, 17

    move_down 3
    text 'Informações Gerais' , :align => :center, color: 'ffffff'
    linha3
    move_down 5
    linha3
move_down 15

    text "#{Prawn::Text::NBSP}" +"Perfil do Egresso", size: 16;

       asFormAcads = FormAcad.where(habilitado: false).where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
       @Formados2 = asFormAcads.where(nome_curso: Curso.where(id: @curso).first.nome)

      osQuestionarios = QuestionarioEgresso.where(form_acad_id: @Formados2.ids).where(realizado: true).where("updated_at <= (?)", @data_ate)
    osEgressos = Egresso.none
      osQuestionarios.each do |oQuestionario|
          oEgresso = Egresso.where(id: oQuestionario.egresso_id)
          osEgressos += oEgresso
        end
        @asCoresBr = Egresso.where(id: osEgressos.map(&:id)).where(link: 'Branca').group(:link).count
        @asCoresAM = Egresso.where(id: osEgressos.map(&:id)).where(link: 'Amarela').group(:link).count
        @asCoresPa = Egresso.where(id: osEgressos.map(&:id)).where(link: 'Parda').group(:link).count
        @asCoresPr = Egresso.where(id: osEgressos.map(&:id)).where(link: 'Preta').group(:link).count
        @asCoresIn = Egresso.where(id: osEgressos.map(&:id)).where(link: 'Indígena').group(:link).count
        @asCoresNd = Egresso.where(id: osEgressos.map(&:id)).where(link: 'Não declarada').group(:link).count
        total = @asCoresNd['Não declarada'].to_f + @asCoresIn['Indígena'].to_f + @asCoresPr['Preta'].to_f + @asCoresPa['Parda'].to_f + @asCoresAM['Amarela'].to_f + @asCoresBr['Branca'].to_f
        @asCoresBr['Cor ou Raça'] =  100*(@asCoresBr['Branca'].to_f/total).to_d.round(4).to_f
        @asCoresBr.delete('Branca')
        @asCoresAM['Amarela'] =  100*(@asCoresAM['Amarela'].to_f/total).to_d.round(4).to_f
        @asCoresPa['Parda'] =  100*(@asCoresPa['Parda'].to_f/total).to_d.round(4).to_f
        @asCoresPr['Preta'] =  100*(@asCoresPr['Preta'].to_f/total).to_d.round(4)
        @asCoresIn['Indígena'] =  100*(@asCoresIn['Indígena'].to_f/total).to_d.round(4).to_f
        @asCoresNd['Não declarada'] =  100*(@asCoresNd['Não declarada'].to_f/total).to_d.round(4).to_f
        if @asCoresBr['Cor ou Raça'].nan?
          @asCoresBr['Cor ou Raça'] = 0
        end
        if @asCoresAM['Amarela'].nan?
          @asCoresAM['Amarela'] = 0
        end
        if @asCoresPa['Parda'].nan?
          @asCoresPa['Parda'] = 0
        end

        if @asCoresPr['Preta'].nan?
          @asCoresPr['Preta'] = 0
        end

        if @asCoresIn['Indígena'].nan?
          @asCoresIn['Indígena'] = 0
        end
        if @asCoresNd['Não declarada'].nan?
          @asCoresNd['Não declarada'] = 0
        end
     
      @data = {Branca: @asCoresBr, Amarela: @asCoresAM ,Parda: @asCoresPa, Preta: @asCoresPr, Indígena: @asCoresIn, 'Não declarada' => @asCoresNd}

    bounding_box [bounds.left+6, bounds.top - 65], :width  => bounds.width/2 +15 do
              fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 270+16, 12
              stroke_color '000000'
              stroke_bounds
              vertical_line 0 , -12, at: "#{cursor}".to_f
              move_down 2
       text " Percentual em relação à Cor ou Raça " , :align => :center, color: 'ffffff', size: 10, font: 'Arial'
        chart @data, colors: %w(ff0000  0000ff 149937 ffff00 ff00ff eeeeee) ,  format: :percentage, labels: [false, false,false, false,false, false] , border: true,height: 150,  legend: {right: 0}
    end



      @osGenerosM = Egresso.where(id: osEgressos.map(&:id)).where(genero: 'Masculino').group(:genero).count

      @osGenerosF = Egresso.where(id: osEgressos.map(&:id)).where(genero: 'Feminino').group(:genero).count
      @osGenerosO = Egresso.where(id: osEgressos.map(&:id)).where(genero: 'Outro').group(:genero).count

      total = (@osGenerosM['Masculino'].to_f+ @osGenerosF['Feminino'].to_f+ @osGenerosO['Outro'].to_f)
      if not(total == 0)
      @osGenerosM['Masculino'] = (100*(@osGenerosM['Masculino'].to_f/total)*100).round/100.0
      @osGenerosF['Feminino'] = (100*(@osGenerosF['Feminino'].to_f/total)*100).round/100.0
      @osGenerosO['Outro'] = (100*(@osGenerosO['Outro'].to_f/total)*100).round/100.0

      @osGenerosM['Gênero'] =  @osGenerosM['Masculino']
        @osGenerosM.delete('Masculino')
      end
      @data2 = {Masculino: @osGenerosM, Feminino: @osGenerosF ,Outro: @osGenerosO}
      
    bounding_box [bounds.left+1+ bounds.width/2 +30, bounds.top - 65], :width  => bounds.width/2 - 35 do
                   fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 270-35, 12
              stroke_color '000000'
              stroke_bounds
              vertical_line 0 , -12, at: "#{cursor}".to_f
              move_down 2
       text " Percentual em relação ao Sexo " , :align => :center, color: 'ffffff', size: 10, font: 'Arial'
        chart @data2, colors: %w(ff0000  0000ff 149937 ),  format: :percentage, labels: [false  , false  ,false ] , border: true,height: 150,  legend: {right: 53}
    end

       faixa1 = 0
       faixa2 = 0
       faixa3 = 0
       faixa4 = 0
       faixa5 = 0
       faixa6 = 0
       osEgressos.each do |oEgresso|
        if oEgresso.data_nasc.present?
        if age(oEgresso.data_nasc) <= 18
          faixa1 += 1
        end
        if age(oEgresso.data_nasc) > 18 && age(oEgresso.data_nasc) <= 20
          faixa2 += 1
        end
        if age(oEgresso.data_nasc) > 21 && age(oEgresso.data_nasc) <= 25
          faixa3 += 1
        end
        if age(oEgresso.data_nasc) > 25 && age(oEgresso.data_nasc) <= 30
          faixa4 += 1
        end
        if age(oEgresso.data_nasc) > 30 && age(oEgresso.data_nasc) <= 40
          faixa5 +=1
        end
        if age(oEgresso.data_nasc) > 40
          faixa6 +=1
        end
        end
       end
       if not(total == 0)
       total = faixa1 + faixa2 + faixa3 + faixa4 +  faixa5 + faixa6
       if faixa1 != 0
        faixa1 = 100*(faixa1.to_f/total.to_f).to_d.round(4)
       else
        faixa1 = 0.to_d.round(4)
       end
       if faixa2 != 0
        faixa2 = 100*(faixa2.to_f/total.to_f).to_d.round(4)
       else
        faixa2 = 0.to_d.round(4)
       end
       if faixa3 != 0
        faixa3 = 100*(faixa3.to_f/total.to_f).to_d.round(4)
       else
        faixa3 = 0.to_d.round(4)
       end
       if faixa4 != 0
        faixa4 = 100*(faixa4.to_f/total.to_f).to_d.round(4)
       else
        faixa4 = 0.to_d.round(4)
       end
       if faixa5 != 0
        faixa5 = 100*(faixa5.to_f/total.to_f).to_d.round(4)
       else
        faixa5 = 0.to_d.round(4)
       end
       if faixa6 != 0
        faixa6 = 100*(faixa6.to_f/total.to_f).to_d.round(4)
       else
        faixa6 = 0.to_d.round(4)
       end
     end
       @asFaixas = {"Menor de 18 anos" => faixa1,"Entre 18 e 20 anos" => faixa2,"Entre 21 e 25 anos" => faixa3,"Entre 26 e 30 anos" => faixa4,"Entre 31 e 40 anos" => faixa5,"Maior de 40 anos" => faixa6}

       @data3 = {'Faixa Etária' => @asFaixas}

       bounding_box [bounds.left+6, 150 ], :width  => bounds.width/2 +15 do
                      fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 270+16, 12
              stroke_color '000000'
              stroke_bounds
              vertical_line 0 , -12, at: "#{cursor}".to_f
              move_down 2
         text " Percentual em relação à Faixa Etária " , :align => :center, color: 'ffffff', size: 10, font: 'Arial'
        chart @data3, colors: %w(ff0000),  format: :percentage, labels: [false] , border: true,height: 150,  legend: {right: 110}
      end


      @osEstConjSol = Egresso.where(id: osEgressos.map(&:id)).where(est_conjugal: 'Solteiro(a)').group(:est_conjugal).count
      @osEstConjSep = Egresso.where(id: osEgressos.map(&:id)).where(est_conjugal: 'Separado(a) / Desquitado(a) / Divorciado(a)').group(:est_conjugal).count
      @osEstConjCas = Egresso.where(id: osEgressos.map(&:id)).where(est_conjugal: 'Casado(a) / União Estável').group(:est_conjugal).count
      @osEstConjViu = Egresso.where(id: osEgressos.map(&:id)).where(est_conjugal: 'Viúvo(a)').group(:est_conjugal).count
      
      total = @osEstConjSol['Solteiro(a)'].to_f + @osEstConjViu['Viúvo(a)'].to_f+@osEstConjSep['Separado(a) / Desquitado(a) / Divorciado(a)'].to_f+@osEstConjCas['Casado(a) / União Estável'].to_f
      if not(total == 0)
      @osEstConjSol['Solteiro(a)'] = 100*(@osEstConjSol['Solteiro(a)'].to_f/total).to_d.round(4)
      @osEstConjSep['Separado(a) / Desquitado(a) / Divorciado(a)'] = 100*(@osEstConjSep['Separado(a) / Desquitado(a) / Divorciado(a)'].to_f/total).to_d.round(4)
      @osEstConjCas['Casado(a) / União Estável'] = 100*(@osEstConjCas['Casado(a) / União Estável'].to_f/total).to_d.round(4)
      @osEstConjViu['Viúvo(a)'] = 100*(@osEstConjViu['Viúvo(a)'].to_f/total).to_d.round(4)


    @osEstConjSol['Estado Conjugal'] =  @osEstConjSol['Solteiro(a)']
        @osEstConjSol.delete('Solteiro(a)')
      end
      @data4 = {Solteiro: @osEstConjSol, Separado: @osEstConjSep ,Casado: @osEstConjCas, Viúvo: @osEstConjViu}

    bounding_box [bounds.left+1+ bounds.width/2 +30, 150], :width  => bounds.width/2 - 35 do
              fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 270-35, 12
              stroke_color '000000'
              stroke_bounds
              vertical_line 0 , -12, at: "#{cursor}".to_f
              move_down 2
       text " Percentual em relação ao Estado Conjugal " , :align => :center, color: 'ffffff', size: 10, font: 'Arial'
        chart @data4, colors: %w(ff0000  0000ff 149937 00FFFF),  format: :percentage, labels: [false, false,false,false] , border: true,height: 150,  legend: {right: 33}
    end

    start_new_page
    move_down 10
    text "#{Prawn::Text::NBSP}" +"Dados Estatísticos no Período", size: 16;
    move_down 10

     @Formados2 = asFormAcads.where(nome_curso: Curso.where(id: @curso).first.nome)
     osQuestionariosFiltrados = QuestionarioEgresso.where(form_acad_id: @Formados2.ids).where(realizado: true).where("updated_at <= (?)", @data_ate)


      @Formados = FormAcad.where(habilitado: false).where(egresso_id: osQuestionarios.map(&:egresso_id))

     @FormadosHash = @Formados2.group_by_year(:data_fim, format: "%Y").count #botei

     @Trabalhando = osQuestionariosFiltrados.where(saip_trab_area: 'Sim')
      @Trabalhando.each do |oTrabalho|
        oTrabalho.auxiliar = FormAcad.where(id: FormAcad.where(habilitado: false).where(egresso_id: oTrabalho.egresso_id).first.id).first.data_fim.to_date.strftime("%Y")
        oTrabalho.save
      end
      @Trabalhando = @Trabalhando.group(:auxiliar).count


    inicio = @data_ini.to_date.strftime("%Y").to_i
    fim = @data_fim.to_date.strftime("%Y").to_i
    array  = []
    i= 0
    (inicio..fim).each do |bla|
      array[i] = bla
      i+=1
    end
@Trabalhando1= {}
@FormadosHash1 = {}
    (inicio..fim).each do |bla|
        @Trabalhando1[bla.to_s] = @Trabalhando[bla.to_s].to_f
        @FormadosHash1[bla.to_s] = @FormadosHash[bla.to_s].to_f
       if  @Trabalhando[bla.to_s] == nil
         @Trabalhando1[bla.to_s] = 0
      end
      if @FormadosHash1[bla.to_s] == nil 
          @FormadosHash1[bla.to_s] = 0
      end
    end

bounding_box [bounds.left+6  , 380], :width  => bounds.width-13 do
              fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 540-12, 12
              stroke_color '000000'
              vertical_line 0 , -12, at: "#{cursor}".to_f
              stroke_bounds
              move_down 3
              text "Egressos que atuam na área de formação" , :align => :center, color: 'FFFFFF', size: 10, font: 'Arial'
              @data8 =  {'Total de Egressos Importados' => @FormadosHash1, 'Trabalhando na área' => @Trabalhando1}
              chart @data8, colors: %w(ff0000 0000ff), labels: [true,true] , border: true,height: 150,  legend: {right: 185}
    end

move_down 100
text "#{Prawn::Text::NBSP}" +"Indicador nº1 - Taxa de Empregabilidade", size: 14;


  @Trabalhando1={}

    (inicio..fim).each do |bla|
       @Trabalhando1[bla.to_s] =  100*(@Trabalhando[bla.to_s].to_f/@FormadosHash[bla.to_s].to_f).to_d.round(4)
       if @Trabalhando1[bla.to_s].nan? || @Trabalhando1[bla.to_s] == nil || @FormadosHash[bla.to_s].to_f == 0
        @Trabalhando1[bla.to_s] = 0
      end
    end

    bounding_box [bounds.left+6  , 100], :width  => bounds.width-13 do
              fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 540-12, 12
              stroke_color '000000'
              vertical_line 0 , -12, at: "#{cursor}".to_f
              stroke_bounds
              move_down 3
              text "Índice nº1 - Taxa de Empregabilidade" , :align => :center, color: 'FFFFFF', size: 10, font: 'Arial'
              @data9 =  {'Taxa de Empregabilidade' => @Trabalhando1}
              chart @data9, type: :line, line_widths: [1],colors: %w(ff0000),  format: :percentage, labels: [true] , border: true,height: 150,  legend: {right: 220}
    end



end

def informacoes_academicas
 start_new_page
  linha3
  move_down 5
  linha3

  fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '000000', '149937'
  fill_rectangle [0, "#{cursor}".to_f], 270, 17
  fill_gradient [540, "#{cursor}".to_f+60], 0, [540, "#{cursor}".to_f+60], 540/2, '000000', '149937'
  fill_rectangle [270, "#{cursor}".to_f], 270, 17

    move_down 3
    text 'Informações Acadêmicas' , :align => :center, color: 'ffffff'
    linha3
    move_down 5
    linha3
    move_down 15
    text "#{Prawn::Text::NBSP}" +"Dados Qualitativos", size: 16;

    asFormAcads = FormAcad.where("data_fim >= (?) AND data_fim <= (?)", @data_ini, @data_fim)
    array = ['ia_satisf_palestras','ia_satisf_oficina','ia_satisf_minicurso','ia_satisf_seminario','ia_satisf_vis_tec','ia_satisf_estagio','ia_satisf_prat_prof','ia_satisf_bolsas']
    array.each do |coluna|
        @osQuestionariosSuf =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @curso).first.nome).where(coluna+' IN (?)', 'Suficiente').where(realizado: true).where("updated_at <= (?)", @data_ate).group(coluna).count 
        @osQuestionariosReg =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @curso).first.nome).where(coluna+' IN (?)', 'Regular').where(realizado: true).where("updated_at <= (?)", @data_ate).group(coluna).count 
        @osQuestionariosIns =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @curso).first.nome).where(coluna+' IN (?)', 'Insuficiente').where(realizado: true).where("updated_at <= (?)", @data_ate).group(coluna).count 
        @osQuestionariosNun =  QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @curso).first.nome).where(coluna+' IN (?)', 'Nunca soube da oferta').where(realizado: true).where("updated_at <= (?)", @data_ate).group(coluna).count 
    
        total = @osQuestionariosSuf['Suficiente'].to_f + @osQuestionariosReg['Regular'].to_f + @osQuestionariosIns['Insuficiente'].to_f + @osQuestionariosNun['Nunca soube da oferta'].to_f

        @osQuestionariosSuf['Suficiente'] = 100*(@osQuestionariosSuf['Suficiente'].to_f/total).to_d.round(4)
        @osQuestionariosReg['Regular'] = 100*(@osQuestionariosReg['Regular'].to_f/total).to_d.round(4)
        @osQuestionariosIns['Insuficiente'] = 100*(@osQuestionariosIns['Insuficiente'].to_f/total).to_d.round(4)
        @osQuestionariosNun['Nunca soube da oferta'] = 100*(@osQuestionariosNun['Nunca soube da oferta'].to_f/total).to_d.round(4)
         @osQuestionariosSuf['Grau de Satisfação'] =  @osQuestionariosSuf['Suficiente']
          @osQuestionariosSuf.delete('Suficiente')
        if @osQuestionariosSuf['Grau de Satisfação'].nan?
          @osQuestionariosSuf['Grau de Satisfação'] = 0
        end
        if @osQuestionariosReg['Regular'].nan?
          @osQuestionariosReg['Regular'] = 0
        end
        if @osQuestionariosIns['Insuficiente'].nan?
          @osQuestionariosIns['Insuficiente'] = 0
        end
        if    @osQuestionariosNun['Nunca soube da oferta'].nan?
             @osQuestionariosNun['Nunca soube da oferta'] = 0
        end

        if coluna == 'ia_satisf_palestras'

            bounding_box [bounds.left+6 , 350], :width  => bounds.width/2 -13  do
              fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 270-12, 12
              stroke_color '000000'
              vertical_line 0 , -12, at: "#{cursor}".to_f
              stroke_bounds
              move_down 2
              text "Percentual de Satisfação de Oferta de Palestras" , :align => :center, color: 'FFFFFF', size: 10, font: 'Arial'
              @data5 =  {Suficiente: @osQuestionariosSuf, Regular: @osQuestionariosReg ,Insuficiente: @osQuestionariosIns, 'N.S.O *' => @osQuestionariosNun}
              chart @data5, colors: %w(ff0000  0000ff 149937 FFFF00),  format: :percentage, labels: [false, false,false,false] , border: true,height: 150,  legend: {right: 33}
            end
        end
        if coluna == 'ia_satisf_oficina'

            bounding_box [bounds.left+6 + bounds.width/2,350], :width  => bounds.width/2-13  do
              fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 270-12, 12
              stroke_color '000000'
              vertical_line 0 , -12, at: "#{cursor}".to_f
              stroke_bounds
              move_down 2
              text "Percentual de Satisfação de Oferta de Oficinas" , :align => :center, color: 'FFFFFF', size: 10, font: 'Arial'
              @data6 =  {Suficiente: @osQuestionariosSuf, Regular: @osQuestionariosReg ,Insuficiente: @osQuestionariosIns, 'N.S.O *' => @osQuestionariosNun}
              chart @data6, colors: %w(ff0000  0000ff 149937 FFFF00),  format: :percentage, labels: [false, false,false,false] , border: true,height: 150,  legend: {right: 33}
            end
        end
        if coluna == 'ia_satisf_minicurso'

            bounding_box [bounds.left+6 , 150], :width  => bounds.width/2 -13  do
              fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 270-12, 12
              stroke_color '000000'
              vertical_line 0 , -12, at: "#{cursor}".to_f
              stroke_bounds
              move_down 2
              text "Percentual de Satisfação de Oferta de Minicursos" , :align => :center, color: 'FFFFFF', size: 10, font: 'Arial'
              @data5 =  {Suficiente: @osQuestionariosSuf, Regular: @osQuestionariosReg ,Insuficiente: @osQuestionariosIns, 'N.S.O *' => @osQuestionariosNun}
              chart @data5, colors: %w(ff0000  0000ff 149937 FFFF00),  format: :percentage, labels: [false, false,false,false] , border: true,height: 150,  legend: {right: 33}
            end
        end
        if coluna == 'ia_satisf_seminario'

          bounding_box [bounds.left+6  + bounds.width/2 , 150], :width  => bounds.width/2 -13 do
              fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 270-12, 12
              stroke_color '000000'
              vertical_line 0 , -12, at: "#{cursor}".to_f
              stroke_bounds
              move_down 2
              text "Percentual de Satisfação de Oferta de Seminários" , :align => :center, color: 'FFFFFF', size: 10, font: 'Arial'
              @data5 =  {Suficiente: @osQuestionariosSuf, Regular: @osQuestionariosReg ,Insuficiente: @osQuestionariosIns, 'N.S.O *' => @osQuestionariosNun}
              chart @data5, colors: %w(ff0000  0000ff 149937 FFFF00),  format: :percentage, labels: [false, false,false,false] , border: true,height: 150,  legend: {right: 33}
            end

            bounding_box [bounds.left-80, -50], :width  => bounds.width/2 -13 do
              text "(*) N.S.O - nunca soube de oferta" , :align => :center, color: '000000', size: 6, font: 'Arial'
            end
        end


        if coluna == 'ia_satisf_vis_tec'

        start_new_page

  linha3
  move_down 5
  linha3

  fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '000000', '149937'
  fill_rectangle [0, "#{cursor}".to_f], 270, 17
  fill_gradient [540, "#{cursor}".to_f+60], 0, [540, "#{cursor}".to_f+60], 540/2, '000000', '149937'
  fill_rectangle [270, "#{cursor}".to_f], 270, 17

    move_down 3
    text 'Informações Acadêmicas' , :align => :center, color: 'ffffff'
    linha3
    move_down 5
    linha3
    move_down 15
    text "#{Prawn::Text::NBSP}" +"Dados Qualitativos", size: 16;

            bounding_box [bounds.left+6 , 350], :width  => bounds.width/2 -13 do  
              fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 270-12, 12
              stroke_color '000000'
              vertical_line 0 , -12, at: "#{cursor}".to_f
              stroke_bounds
              move_down 2
              text "Percentual de Satisfação de Oferta de Visitas Técnicas" , :align => :center, color: 'FFFFFF', size: 10, font: 'Arial'          
              @data5 =  {Suficiente: @osQuestionariosSuf, Regular: @osQuestionariosReg ,Insuficiente: @osQuestionariosIns, 'N.S.O *' => @osQuestionariosNun}
              chart @data5, colors: %w(ff0000  0000ff 149937 FFFF00),  format: :percentage, labels: [false, false,false,false] , border: true,height: 150,  legend: {right: 33}
            end
        end
        if coluna == 'ia_satisf_estagio'

            bounding_box [bounds.left+6  + bounds.width/2, 350], :width  => bounds.width/2  -13 do
              fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 270-12, 12
              stroke_color '000000'
              vertical_line 0 , -12, at: "#{cursor}".to_f
              stroke_bounds
              move_down 2
              text "Percentual de Satisfação de Oferta de Estágios" , :align => :center, color: 'FFFFFF', size: 10, font: 'Arial'
              @data5 =  {Suficiente: @osQuestionariosSuf, Regular: @osQuestionariosReg ,Insuficiente: @osQuestionariosIns, 'N.S.O *' => @osQuestionariosNun}
              chart @data5, colors: %w(ff0000  0000ff 149937 FFFF00),  format: :percentage, labels: [false, false,false,false] , border: true,height: 150,  legend: {right: 33}
            end
        end
        if coluna == 'ia_satisf_prat_prof'
            bounding_box [bounds.left+6 , 150], :width  => bounds.width/2 -13 do
              fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 270-12, 24
              stroke_color '000000'
              vertical_line 0 , -24, at: "#{cursor}".to_f
              stroke_bounds
              move_down 2
              text "Percentual de Satisfação de Oferta de Práticas Profissionais" , :align => :center, color: 'FFFFFF', size: 10, font: 'Arial'
              @data5 =  {Suficiente: @osQuestionariosSuf, Regular: @osQuestionariosReg ,Insuficiente: @osQuestionariosIns, 'N.S.O *' => @osQuestionariosNun}
              chart @data5, colors: %w(ff0000  0000ff 149937 FFFF00),  format: :percentage, labels: [false, false,false,false] , border: true,height: 150,  legend: {right: 33}
            end
        end
        if coluna == 'ia_satisf_bolsas'
            bounding_box [bounds.left+6  + bounds.width/2, 150], :width  => bounds.width/2 -13 do
              fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 270-12, 24
              stroke_color '000000'
              vertical_line 0 , -24, at: "#{cursor}".to_f
              stroke_bounds
              move_down 2
              text "Percentual de Satisfação de Oferta de Bolsas Institucionais" , :align => :center, color: 'FFFFFF', size: 10, font: 'Arial'
              @data5 =  {Suficiente: @osQuestionariosSuf, Regular: @osQuestionariosReg ,Insuficiente: @osQuestionariosIns, 'N.S.O *' => @osQuestionariosNun}
              chart @data5, colors: %w(ff0000  0000ff 149937 FFFF00),  format: :percentage, labels: [false, false,false,false] , border: true,height: 150,  legend: {right: 33}
            end
            bounding_box [bounds.left-80, -50], :width  => bounds.width/2 -12 do
              text "(*) N.S.O - nunca soube de oferta" , :align => :center, color: '000000', size: 6, font: 'Arial'
            end
        end

    end

start_new_page
move_down 20
text "#{Prawn::Text::NBSP}" +"Dados Estatísticos no Período", size: 16;
      @Formados = asFormAcads.group_by_year(:data_fim, format: "%Y").count
      @Questionarios = QuestionarioEgresso.where(form_acad_id: asFormAcads.ids).where(nome_curso:  Curso.where(id: @curso).first.nome).where(realizado: true).where("updated_at <= (?)", @data_ate)

      @Palestras = @Questionarios.where(ia_satisf_palestras: 'Suficiente').or(@Questionarios.where(ia_satisf_palestras: 'Regular'))
      @Palestras.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save
      end
      @Palestras = @Palestras.group(:auxiliar).count
      @PalestrasTot = @Questionarios.where.not(ia_satisf_palestras: nil)
      @PalestrasTot.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save
      end
      @PalestrasTot = @PalestrasTot.group(:auxiliar).count


      @oficinas = @Questionarios.where(ia_satisf_oficina: 'Suficiente').or(@Questionarios.where(ia_satisf_oficina: 'Regular'))
      @oficinas.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save
      end
      @oficinas = @oficinas.group(:auxiliar).count
      @oficinasTot = @Questionarios.where.not(ia_satisf_oficina: nil)
      @oficinasTot.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save
      end
      @oficinasTot = @oficinasTot.group(:auxiliar).count

      @minicurso = @Questionarios.where(ia_satisf_minicurso: 'Suficiente').or(@Questionarios.where(ia_satisf_minicurso: 'Regular'))
      @minicurso.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save
      end
      @minicurso = @minicurso.group(:auxiliar).count
      @minicursoTot = @Questionarios.where.not(ia_satisf_minicurso: nil)
      @minicursoTot.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save
      end
      @minicursoTot = @minicursoTot.group(:auxiliar).count

      @seminario = @Questionarios.where(ia_satisf_seminario: 'Suficiente').or(@Questionarios.where(ia_satisf_seminario: 'Regular'))
      @seminario.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save
      end
      @seminario = @seminario.group(:auxiliar).count
      @seminarioTot = @Questionarios.where.not(ia_satisf_seminario: nil)
      @seminarioTot.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save
      end
      @seminarioTot = @seminarioTot.group(:auxiliar).count

      @vis_tec = @Questionarios.where(ia_satisf_vis_tec: 'Suficiente').or(@Questionarios.where(ia_satisf_vis_tec: 'Regular'))
      @vis_tec.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save
      end
      @vis_tec = @vis_tec.group(:auxiliar).count
      @vistecTot = @Questionarios.where.not(ia_satisf_vis_tec: nil)
      @vistecTot.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save
      end
      @vistecTot = @vistecTot.group(:auxiliar).count

      @estagio = @Questionarios.where(ia_satisf_estagio: 'Suficiente').or(@Questionarios.where(ia_satisf_estagio: 'Regular'))
      @estagio.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save
      end
      @estagio = @estagio.group(:auxiliar).count
      @estagioTot = @Questionarios.where.not(ia_satisf_estagio: nil)
      @estagioTot.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save
      end
      @estagioTot = @estagioTot.group(:auxiliar).count


      @pratprof = @Questionarios.where(ia_satisf_prat_prof: 'Suficiente').or(@Questionarios.where(ia_satisf_prat_prof: 'Regular'))
      @pratprof.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save
      end
      @pratprof = @pratprof.group(:auxiliar).count
      @pratprofTot = @Questionarios.where.not(ia_satisf_prat_prof: nil)
      @pratprofTot.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save
      end
      @pratprofTot = @pratprofTot.group(:auxiliar).count

      @bolsas = @Questionarios.where(ia_satisf_bolsas: 'Suficiente').or(@Questionarios.where(ia_satisf_bolsas: 'Regular'))
      @bolsas.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save
      end
      @bolsas = @bolsas.group(:auxiliar).count
      @bolsasTot = @Questionarios.where.not(ia_satisf_bolsas: nil)
      @bolsasTot.each do |aPalestra|
        aPalestra.auxiliar = asFormAcads.where(id: aPalestra.form_acad_id).first.data_fim.to_date.strftime("%Y")
        aPalestra.save
      end
      @bolsasTot = @bolsasTot.group(:auxiliar).count



    inicio = @data_ini.to_date.strftime("%Y").to_i
    fim = @data_fim.to_date.strftime("%Y").to_i
    array  = []
    i= 0
    (inicio..fim).each do |bla|
      array[i] = bla
      i+=1
    end

@PalestrasTot1 = {}
@oficinasTot1 = {}
@minicursoTot1 = {}
@seminarioTot1 = {}
@vistecTot1 = {}
@estagioTot1 = {}
@pratprofTot1 = {}
@bolsasTot1 = {}

    (inicio..fim).each do |bla|
       @PalestrasTot1[bla.to_s] =  100*((@Palestras[bla.to_s].to_f/@PalestrasTot[bla.to_s].to_f)).round(4)
        @oficinasTot1[bla.to_s] =  100*((@oficinas[bla.to_s].to_f/@oficinasTot[bla.to_s].to_f)).round(4)
         @minicursoTot1[bla.to_s] =  100*((@minicurso[bla.to_s].to_f/@minicursoTot[bla.to_s].to_f)).round(4)
          @seminarioTot1[bla.to_s] =  100*((@seminario[bla.to_s].to_f/@seminarioTot[bla.to_s].to_f)).round(4)
           @vistecTot1[bla.to_s] =  100*((@vis_tec[bla.to_s].to_f/@vistecTot[bla.to_s].to_f)).round(4)
            @estagioTot1[bla.to_s] =  100*((@estagio[bla.to_s].to_f/@estagioTot[bla.to_s].to_f)).round(4)
             @pratprofTot1[bla.to_s] =  100*((@pratprof[bla.to_s].to_f/@pratprofTot[bla.to_s].to_f)).round(4)
              @bolsasTot1[bla.to_s] =  100*((@bolsas[bla.to_s].to_f/@bolsasTot[bla.to_s].to_f)).round(4)
    if @PalestrasTot1[bla.to_s].nan?
      @PalestrasTot1[bla.to_s] = 0
    end
    if @oficinasTot1[bla.to_s].nan?
      @oficinasTot1[bla.to_s] = 0
    end
    if @minicursoTot1[bla.to_s].nan?
      @minicursoTot1[bla.to_s] = 0
    end
    if @seminarioTot1[bla.to_s].nan?
      @seminarioTot1[bla.to_s] = 0
    end
    if @vistecTot1[bla.to_s].nan?
      @vistecTot1[bla.to_s] = 0
    end
    if @estagioTot1[bla.to_s].nan?
      @estagioTot1[bla.to_s] = 0
    end
    if @pratprofTot1[bla.to_s].nan?
      @pratprofTot1[bla.to_s] = 0
    end
    if @bolsasTot1[bla.to_s].nan?
      @bolsasTot1[bla.to_s] = 0
    end
    end
    bounding_box [bounds.left+6 , 350], :width  => bounds.width/2 -13  do
              fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 270-12, 12
              stroke_color '000000'
              vertical_line 0 , -12, at: "#{cursor}".to_f
              stroke_bounds
              move_down 2
              text "Percentual de Satisfação de Oferta de Palestras" , :align => :center, color: 'FFFFFF', size: 10, font: 'Arial'
              @data6 =  {Palestras: @PalestrasTot1}
              chart @data6, type: :line, line_widths: [1],colors: %w(ff0000),  format: :percentage, labels: [true], border: true,height: 150,  legend: {right: 110}
    end
    bounding_box [bounds.left+6 + bounds.width/2,350], :width  => bounds.width/2-13  do
              fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 270-12, 12
              stroke_color '000000'
              vertical_line 0 , -12, at: "#{cursor}".to_f
              stroke_bounds
              move_down 2
              text "Percentual de Satisfação de Oferta de Oficinas" , :align => :center, color: 'FFFFFF', size: 10, font: 'Arial'
              @data6 =  {Oficinas: @oficinasTot1}
              chart @data6, type: :line, line_widths: [1],colors: %w(ff0000),  format: :percentage, labels: [true], border: true,height: 150,  legend: {right: 110}
    end
    bounding_box [bounds.left+6 , 150], :width  => bounds.width/2 -13  do
              fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 270-12, 12
              stroke_color '000000'
              vertical_line 0 , -12, at: "#{cursor}".to_f
              stroke_bounds
              move_down 2
              text "Percentual de Satisfação de Oferta de Minicursos" , :align => :center, color: 'FFFFFF', size: 10, font: 'Arial'
              @data6 =  {Minicursos: @minicursoTot1}
              chart @data6, type: :line, line_widths: [1],colors: %w(ff0000),  format: :percentage, labels: [true] , border: true,height: 150,  legend: {right: 110}
    end
    bounding_box [bounds.left+6  + bounds.width/2 , 150], :width  => bounds.width/2 -13 do
              fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 270-12, 12
              stroke_color '000000'
              vertical_line 0 , -12, at: "#{cursor}".to_f
              stroke_bounds
              move_down 2
              text "Percentual de Satisfação de Oferta de Seminários" , :align => :center, color: 'FFFFFF', size: 10, font: 'Arial'
              @data6 =  {Seminários: @seminarioTot1}
              chart @data6, type: :line, line_widths: [1],colors: %w(ff0000),  format: :percentage, labels: [true], border: true,height: 150,  legend: {right: 110}
    end
    start_new_page
    move_down 20
text "#{Prawn::Text::NBSP}" +"Dados Estatísticos no Período", size: 16;
            bounding_box [bounds.left+6 , 350], :width  => bounds.width/2 -13 do  
              fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 270-12, 12
              stroke_color '000000'
              vertical_line 0 , -12, at: "#{cursor}".to_f
              stroke_bounds
              move_down 2
              text "Percentual de Satisfação de Oferta de Visitas Técnicas" , :align => :center, color: 'FFFFFF', size: 10, font: 'Arial'
              @data6 =  {'Visitas Técnicas' => @vistecTot1}
              chart @data6, type: :line, line_widths: [1],colors: %w(ff0000),  format: :percentage, labels: [true], border: true,height: 150,  legend: {right: 90}
    end
            bounding_box [bounds.left+6  + bounds.width/2, 350], :width  => bounds.width/2  -13 do
              fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 270-12, 12
              stroke_color '000000'
              vertical_line 0 , -12, at: "#{cursor}".to_f
              stroke_bounds
              move_down 2
              text "Percentual de Satisfação de Oferta de Estágios" , :align => :center, color: 'FFFFFF', size: 10, font: 'Arial'
              @data6 =  {Estágios: @estagioTot1}
              chart @data6, type: :line, line_widths: [1],colors: %w(ff0000),  format: :percentage, labels: [true] , border: true,height: 150,  legend: {right: 110}
    end
            bounding_box [bounds.left+6 , 150], :width  => bounds.width/2 -13 do
              fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 270-12, 24
              stroke_color '000000'
              vertical_line 0 , -24, at: "#{cursor}".to_f
              stroke_bounds
              move_down 2
              text "Percentual de Satisfação de Oferta de Práticas Profissionais" , :align => :center, color: 'FFFFFF', size: 10, font: 'Arial'
              @data6 =  {'Práticas Profissionais' => @pratprofTot1}
              chart @data6, type: :line, line_widths: [1],colors: %w(ff0000),  format: :percentage, labels: [true] , border: true,height: 150,  legend: {right: 90}
    end
    bounding_box [bounds.left+6  + bounds.width/2, 150], :width  => bounds.width/2 -13 do
              fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 270-12, 24
              stroke_color '000000'
              vertical_line 0 , -24, at: "#{cursor}".to_f
              stroke_bounds
              move_down 2
              text "Percentual de Satisfação de Oferta de Bolsas Institucionais" , :align => :center, color: 'FFFFFF', size: 10, font: 'Arial'
              @data6 =  {Bolsas: @bolsasTot1}
              chart @data6, type: :line, line_widths: [1],colors: %w(ff0000),  format: :percentage, labels: [true] , border: true,height: 150,  legend: {right: 110}
    end

start_new_page

      @Trabalhando = @Questionarios.where.not(ia_satisf_palestras: nil).or(@Questionarios.where.not(ia_satisf_oficina: nil).or(@Questionarios.where.not(ia_satisf_minicurso: nil).or(@Questionarios.where.not(ia_satisf_seminario: nil).or(@Questionarios.where.not(ia_satisf_vis_tec: nil).or(@Questionarios.where.not(ia_satisf_estagio: nil).or(@Questionarios.where.not(ia_satisf_prat_prof: nil).or(@Questionarios.where.not(ia_satisf_bolsas: nil))))))))
      @Trabalhando.each do |oTrabalho|
        oTrabalho.auxiliar = asFormAcads.where(id: oTrabalho.form_acad_id).first.data_fim.to_date.strftime("%Y")
        oTrabalho.save
      end
      @Trabalhando = @Trabalhando.group(:auxiliar).count


    inicio = @data_ini.to_date.strftime("%Y").to_i
    fim = @data_fim.to_date.strftime("%Y").to_i
    array  = []
    i= 0
    (inicio..fim).each do |bla|
      array[i] = bla
      i+=1
    end

  @Trabalhando1 = {}
    (inicio..fim).each do |bla|
       @Trabalhando1[bla.to_s] =  (@PalestrasTot1[bla.to_s].to_f+ @oficinasTot1[bla.to_s].to_f + @minicursoTot1[bla.to_s].to_f + @seminarioTot1[bla.to_s].to_f+@vistecTot1[bla.to_s].to_f+@estagioTot1[bla.to_s].to_f+@pratprofTot1[bla.to_s].to_f+@bolsasTot1[bla.to_s].to_f)/(8).round(4)
        if @Trabalhando1[bla.to_s].nan?
          @Trabalhando1[bla.to_s] = 0
        end
    end

move_down 15
text "#{Prawn::Text::NBSP}" +"Indicador nº2 - Taxa de Satisfação do Egresso", size: 14;

    bounding_box [bounds.left+6  , 375], :width  => bounds.width-13 do
              fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540, '149937', '000f00'
              fill_rectangle [0, "#{cursor}".to_f], 540-12, 12
              stroke_color '000000'
              vertical_line 0 , -12, at: "#{cursor}".to_f
              stroke_bounds
              move_down 3
              text "Índice nº2 - Taxa de Satisfação" , :align => :center, color: 'FFFFFF', size: 10, font: 'Arial'
              @data6 =  {'Taxa de Satisfação' => @Trabalhando1}
              chart @data6, type: :line, line_widths: [1],colors: %w(ff0000),  format: :percentage, labels: [true] , border: true,height: 150,  legend: {right: 220}
    end





end

def age(dob)
  now = Time.now.utc.to_date
  now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
end

end


