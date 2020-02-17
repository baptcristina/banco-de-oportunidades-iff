class CurriculoPdf < Prawn::Document
    include ApplicationHelper

	def initialize(egresso_id,view)
    	super()
      self.font_families.update("Arial" => {:normal => {file: "#{Rails.root}/public/DejaVuSans.ttf", font: 'normal'}, bold: { file: "#{Rails.root}/public/arial-bold.ttf", font: 'bold'}})
      font "Arial"
      @id = egresso_id;
      @oEgresso = Egresso.where(id: @id).first;

      repeat :all, :dynamic => :true do

        @brand = "#{Rails.root}/app/assets/images/BdO rotacionado.png"
        stroke_color "f0f0f0"


    # header
        bounding_box [bounds.left, bounds.top], :width  => bounds.width do
            fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '000000', '149937'
            fill_rectangle [0, "#{cursor}".to_f], 270, 70
            fill_gradient [540, "#{cursor}".to_f+60], 0, [540, "#{cursor}".to_f+60], 540/2, '000000', '149937'
            fill_rectangle [270, "#{cursor}".to_f], 270, 70
            cabecalho1
            cabecalho2
            formacao_academica
            if FormCompl.where(:egresso_id => @id).present? 
            formacao_complementar
            end
            if ExpProf.where(:egresso_id => @id).present?             
            experiencia_profissional
            end
            if AtivAut.where(:egresso_id => @id).present?                    
            atividade_autonoma
            end
            if Idioma.where(:egresso_id => @id).present?  
            idioma
            end
            if Compet.where(:egresso_id => @id).present? 
            competencia_adicional
            end

            end

    # footer
        bounding_box [bounds.left, bounds.bottom + 25], :width  => bounds.width do
            rodape   
            end

      end

  def cabecalho1
  # header
      bounding_box [bounds.left, bounds.top], :width  => bounds.width do
        move_down 15

        image @brand, :at => [bounds.left+50,bounds.top-10], :fit => [44, 48], :position => :left
        text 'Banco de Oportunidades' , :align => :center, color: 'ffffff', size: 24
        text "#{Prawn::Text::NBSP}" +"Curriculum Vitae" , size: 16, color: 'ffffff', :align => :center;
        move_down 10

      end
    linha
  end


  def cabecalho2

    formatted_text [ 
      { text: "#{Prawn::Text::NBSP}"+" #{@oEgresso.nome_completo}", size: 14, font: 'Times-Roman', color: '000000', style: :bold},
      { text: ",      #{age(@oEgresso.data_nasc)} anos", size: 14, font: 'Times-Roman', color: '000000', style: :normal, align: :right},
      ]

    formatted_text [ 
      { text: " ", size: 14, font: 'Times-Roman', color: '000000', style: :bold},
      ]
    if not(@oEgresso.tel_res == "")&&not(@oEgresso.tel_res == "(__) ____-____")&&not(@oEgresso.tel_res == nil)
    formatted_text [ 
      { text: "#{Prawn::Text::NBSP}"+" Telefone Residencial:  ", size: 14 , font: 'Times-Roman', color: '000000'},
      { text: "#{Prawn::Text::NBSP}" +"#{Prawn::Text::NBSP}" +"#{@oEgresso.tel_res}", size: 14 , font: 'Times-Roman', color: '000000'},
      ]  
    end
    if not( @oEgresso.tel_com == "") && not(@oEgresso.tel_com == "(__) _____-____")&&not(@oEgresso.tel_com == nil)
    formatted_text [ 
      { text: "#{Prawn::Text::NBSP}"+" Telefone Comercial:  ", size: 14 , font: 'Times-Roman', color: '000000'},
      { text: "#{Prawn::Text::NBSP}" +"#{Prawn::Text::NBSP}" +"#{@oEgresso.tel_com}", size: 14 , font: 'Times-Roman', color: '000000'},
      ]  
    end
    if not( @oEgresso.tel_cel == "") && not(@oEgresso.tel_cel == "(__) _____-____")&&not(@oEgresso.tel_cel == nil)
    formatted_text [ 
      { text: "#{Prawn::Text::NBSP}"+" Telefone Celular:  ", size: 14 , font: 'Times-Roman', color: '000000'},
      { text: "#{Prawn::Text::NBSP}" +"#{Prawn::Text::NBSP}" +"#{@oEgresso.tel_cel}", size: 14 , font: 'Times-Roman', color: '000000'},
      ]  
    end
    if not( @oEgresso.num_zap == "" ) && not(@oEgresso.num_zap == "(__) _____-____")&&not(@oEgresso.num_zap == nil)
    formatted_text [ 
      { text: "#{Prawn::Text::NBSP}"+" Whatsapp:  ", size: 14 , font: 'Times-Roman', color: '000000'},
      { text: "#{Prawn::Text::NBSP}" +"#{Prawn::Text::NBSP}" +"#{@oEgresso.num_zap}", size: 14 , font: 'Times-Roman', color: '000000'},
      ]  
    end
     formatted_text [ 
      { text: "#{Prawn::Text::NBSP}"+" E-mail:  ", size: 14 , font: 'Times-Roman', color: '000000'},
      { text: "#{Prawn::Text::NBSP}" +"#{Prawn::Text::NBSP}" +"#{@oEgresso.email_princ}", size: 14 , font: 'Times-Roman', color: '000000'},
      ]  

  end
 
  def rodape
    bounding_box [bounds.left, bounds.bottom + 0], :width  => bounds.width do
          font "Helvetica"
          stroke_horizontal_rule
          stroke_bounds
          move_down(5)
          text "#{I18n.l Date.today, :format => :long}", :size => 8
          move_up(22)
          text "(*) - Informado pelo Sistema Acadêmico do Instituto Federal Fluminense Campus Campos Centro", size: 8
      end
      number_pages "<page> / <total>", { :start_count_at => 0, :page_filter => :all, :at => [bounds.right - 50, -25], :align => :right, :size => 10 }
  end

def formacao_academica
    move_down 3
    linha3
    fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '000000', '149937'
    fill_rectangle [0, "#{cursor}".to_f], 270, 17
    fill_gradient [540, "#{cursor}".to_f+60], 0, [540, "#{cursor}".to_f+60], 540/2, '000000', '149937'
    fill_rectangle [270, "#{cursor}".to_f], 270, 17


    move_down 3
    text "#{Prawn::Text::NBSP}"+'Formação Acadêmica' , :align => :center, color: 'ffffff'
    linha3
    move_down 5
    linha3
    move_down 15
                FormAcad.where(:egresso_id => @id).order(data_fim: :DESC).each do |form_acad|
                  if y <= 106
                    start_new_page
                  end
                   text "#{Prawn::Text::NBSP}"+form_acad.inst_ofert+info_sistema?(form_acad), size: 13, style: :bold
                   move_down 5
                   if (form_acad.habilitado == false) 
                      if (Titulacao.where(id: Curso.where(nome: form_acad.nome_curso).map(&:titulacao_id)).present?)
                        text "#{Prawn::Text::NBSP}"+"#{Prawn::Text::NBSP}"+"Nome do Curso: " +Titulacao.where(id: Curso.where(nome: form_acad.nome_curso).first.titulacao_id).first.titulo, size: 12, style: :normal 
                        if form_acad.nome_curso == 'Licenciatura em Ciências da Natureza'&& (form_acad.semestre_letivo).present? 
                          if form_acad.semestre_letivo.include?('Bio')
                            text "#{Prawn::Text::NBSP}"+"Habilitação: Licenciado(a) em Biologia" 
                          else
                            if form_acad.semestre_letivo.include?('Quím')
                              text "#{Prawn::Text::NBSP}"+"Habilitação: Licenciado(a) em Química" 
                            else
                              if form_acad.semestre_letivo.include?('Fís')
                                text "#{Prawn::Text::NBSP}"+"Habilitação: Licenciado(a) em Física" 
                              end
                            end
                          end
                        end
                      else
                        text "#{Prawn::Text::NBSP}"+"#{Prawn::Text::NBSP}"+form_acad.nome_curso 
                      end
                      text "#{Prawn::Text::NBSP}"+"#{Prawn::Text::NBSP}"+'Formado(a) em: '+form_acad.data_fim.to_s, size: 12, style: :normal                     
                    else
                      text "#{Prawn::Text::NBSP}"+"#{Prawn::Text::NBSP}"+form_acad.nome_curso
                      text "#{Prawn::Text::NBSP}"+"#{Prawn::Text::NBSP}"+"Data de Início: " +form_acad.data_ini.to_s
                      if not(form_acad.data_fim.nil?) 
                         if form_acad.data_fim <= Time.now            
                            text "#{Prawn::Text::NBSP}"+"#{Prawn::Text::NBSP}"+"Data de Conclusão: " +form_acad.data_fim.to_s
                          else
                            text "#{Prawn::Text::NBSP}"+"#{Prawn::Text::NBSP}"+"Previsão de Conclusão em: " +form_acad.data_fim.to_s
                          end                
                      else
                        text "#{Prawn::Text::NBSP}"+"#{Prawn::Text::NBSP}"+"Previsão de Conclusão em: " 
                      end
                    end
                  linha
                  end
                end
end

def info_sistema?(form_acad)
    if form_acad.habilitado == true
        return ""
    else
        return " (*)"
    end
end
def formacao_complementar
    if y < 160 
        start_new_page
    end
    puts "#{cursor}"
    move_down 3
    linha3
    fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '000000', '149937'
    fill_rectangle [0, "#{cursor}".to_f], 270, 17
    fill_gradient [540, "#{cursor}".to_f+60], 0, [540, "#{cursor}".to_f+60], 540/2, '000000', '149937'
    fill_rectangle [270, "#{cursor}".to_f], 270, 17

    move_down 3
    text "#{Prawn::Text::NBSP}"+'Formação Complementar' , :align => :center, color: 'ffffff'
    linha3
    move_down 5
    linha3
    move_down 15
    
    FormCompl.where(:egresso_id => @id).order("data_fim DESC").each do |form_compl|
      if y < 106 
        start_new_page
      end
        text "#{Prawn::Text::NBSP}"+form_compl.inst, size: 13, style: :bold
        move_down 5
        text "#{Prawn::Text::NBSP}"+"#{Prawn::Text::NBSP}"+'Nome do Curso: '+form_compl.nome_curso 
        text "#{Prawn::Text::NBSP}"+"#{Prawn::Text::NBSP}"+'Carga Horária: '+form_compl.carga.to_s+" horas"
        text "#{Prawn::Text::NBSP}"+"#{Prawn::Text::NBSP}"+'Data de Conclusão: '+form_compl.data_fim.to_s                     
        linha
        move_down 10 

        puts y 
    end                  
 end

def experiencia_profissional
    if y < 160 
        start_new_page
    end
    
    move_down 3
    linha3
    fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '000000', '149937'
    fill_rectangle [0, "#{cursor}".to_f], 270, 17
    fill_gradient [540, "#{cursor}".to_f+60], 0, [540, "#{cursor}".to_f+60], 540/2, '000000', '149937'
    fill_rectangle [270, "#{cursor}".to_f], 270, 17

    move_down 3
    text "#{Prawn::Text::NBSP}"+'Experiência Profissional' , :align => :center, color: 'ffffff'
    linha3
    move_down 5
    linha3
    move_down 15
    
    ExpProf.where(:egresso_id => @id).order("data_fim DESC").each do |exp_prof|
      if y< 106 
        start_new_page
      end
      puts y
        text exp_prof.empresa, size: 13, style: :bold
        move_down 5
        text "#{Prawn::Text::NBSP}"+'Cargo: '+exp_prof.cargo 
        text "#{Prawn::Text::NBSP}"+'Data de Início: '+exp_prof.data_ini.to_s
        text "#{Prawn::Text::NBSP}"+'Data de Término: '+exp_prof.data_fim.to_s                     
        linha  
    end                  
    linha
 end

def atividade_autonoma
    if y < 160 
        start_new_page
    end
    
    move_down 3
    linha3
    fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '000000', '149937'
    fill_rectangle [0, "#{cursor}".to_f], 270, 17
    fill_gradient [540, "#{cursor}".to_f+60], 0, [540, "#{cursor}".to_f+60], 540/2, '000000', '149937'
    fill_rectangle [270, "#{cursor}".to_f], 270, 17

    move_down 3
    text "#{Prawn::Text::NBSP}"+'Atividade Autônoma' , :align => :center, color: 'ffffff'
    linha3
    move_down 5
    linha3
    move_down 15
    
    AtivAut.where(:egresso_id => @id).order("data_fim DESC").each do |ativ_aut|
      if y < 106 
        start_new_page
      end
        text ativ_aut.prest_serv, size: 13, style: :bold
        move_down 5
        text "#{Prawn::Text::NBSP}"+'Função: '+ativ_aut.funcao 
        text "#{Prawn::Text::NBSP}"+'Data de Início: '+ativ_aut.data_ini.to_s
        text "#{Prawn::Text::NBSP}"+'Data de Término: '+ativ_aut.data_fim.to_s                     
        linha  
    end                  
    linha
 end

def idioma
    if y < 160 
        start_new_page
    end
    move_down 3
    linha3
    fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '000000', '149937'
    fill_rectangle [0, "#{cursor}".to_f], 270, 17
    fill_gradient [540, "#{cursor}".to_f+60], 0, [540, "#{cursor}".to_f+60], 540/2, '000000', '149937'
    fill_rectangle [270, "#{cursor}".to_f], 270, 17

    move_down 3
    text "#{Prawn::Text::NBSP}"+'Idioma' , :align => :center, color: 'ffffff'
    linha3
    move_down 5
    linha3
    move_down 15
    
    Idioma.where(:egresso_id => @id).each do |idioma|
      if y < 60
        start_new_page
      end
        text"#{Prawn::Text::NBSP}"+idioma.descricao, size: 13, style: :bold
        if idioma.valor == "1"
            text "#{Prawn::Text::NBSP}"+"#{Prawn::Text::NBSP}"+'Nível de Conhecimento: Básico', size: 12
        end
        if idioma.valor == "2"
            text "#{Prawn::Text::NBSP}"+"#{Prawn::Text::NBSP}"+'Nível de Conhecimento: Intermediário', size: 12
        end
        if idioma.valor == "3"
            text "#{Prawn::Text::NBSP}"+"#{Prawn::Text::NBSP}"+'Nível de Conhecimento: Avançado', size: 12
        end
        if idioma.valor == "4"
            text "#{Prawn::Text::NBSP}"+"#{Prawn::Text::NBSP}"+'Nível de Conhecimento: Fluente', size: 12
        end
        
        linha  
    end                  
    linha
 end

def competencia_adicional
    if y < 160 
      start_new_page
    end      
    move_down 3
    linha3
    fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '000000', '149937'
    fill_rectangle [0, "#{cursor}".to_f], 270, 17
    fill_gradient [540, "#{cursor}".to_f+60], 0, [540, "#{cursor}".to_f+60], 540/2, '000000', '149937'
    fill_rectangle [270, "#{cursor}".to_f], 270, 17

    move_down 3
    text 'Competência Adicional' , :align => :center, color: 'ffffff'
    linha3
    move_down 5
    linha3
    move_down 15
    
    Compet.where(:egresso_id => @id).each do |compet|
      if y < 106 
        start_new_page
      end
        text compet.descricao, size: 13, style: :bold
        text "#{Prawn::Text::NBSP}"+'Nível de Conhecimento: '+compet.valor 
        linha     
    end                  
    linha
 end

def linha 
  stroke do
        move_down 5
        stroke_color "f0f0f0"
        line_width 1
        stroke_horizontal_rule
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

end