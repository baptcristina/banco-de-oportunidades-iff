class OportunidadePdf < Prawn::Document


def initialize(oportunidade)
    super()
    @oportunidade = oportunidade

   repeat :all, :dynamic => :true do

    stroke_color "f0f0f0"

    stroke do
    # just lower the current y position
        move_down 50
        horizontal_rule
        vertical_line  25, 720, :at => 0
        vertical_line  25, 720, :at => 540
    end
    # header
    bounding_box [bounds.left, bounds.top], :width  => bounds.width do
        cabecalho 
        stroke_color "f0f0f0"
        stroke_bounds 

    end
   # footer
    bounding_box [bounds.left, bounds.bottom + 25], :width  => bounds.width do
       rodape
       stroke_bounds
    end
  end

   
end

def cabecalho
 # header
    bounding_box [bounds.left, bounds.top], :width  => bounds.width do
        
    move_down 23

      logo = "#{Rails::root}/app/assets/img/centro1.jpg"
      image  logo, width: 50, heght: 50

    move_down 3

    text 'OFERTA  DE  EMPREGO' , :align => :center, color: 'ffffff', size: 40
    move_down 5

    text 'Silverado Hermes - Comércio e Serviços EIRELI' , :align => :center, color: 'ffffff', size: 24
    move_down 10
    linha3
    move_down 5

    	linha
		formatted_text [ 
             { text: "#{Prawn::Text::NBSP}" +"CNPJ:  ", size: 14 , font: 'Times-Roman', color: '2F4F4F'},
             { text: "#{Prawn::Text::NBSP}" +"#{Prawn::Text::NBSP}" +"432423.14324/0001-11", size: 12 , font: 'Times-Roman', color: '2F4F4F'}
        ]
        text "#{Prawn::Text::NBSP}" +"#{Prawn::Text::NBSP}" +"Rua Edésio Guimarães, 62 - Vila Manhães - Penha" , size: 10 , font: 'Times-Roman', color: '2F4F4F'
        text "#{Prawn::Text::NBSP}" +"#{Prawn::Text::NBSP}" +"Campos dos Goytacazes - RJ Brasil", size: 10 , font: 'Times-Roman', color: '2F4F4F'
	end
	linha
end


def rodape
bounding_box [bounds.left, bounds.bottom + 25], :width  => bounds.width do
text 'Contato: Eduardo da Silva Hermes', size: 7, align: :center
text 'E-mail: silverado.eduardo@gmail.com', size: 7, align: :center
text 'Telefone: (22) 99831-8171', size: 7, align: :center
end
	bounding_box [bounds.left, bounds.bottom + 0], :width  => bounds.width do
        font "Helvetica"
        stroke_horizontal_rule
        stroke_bounds
        move_down(5)
  
    end
    number_pages "<page> / <total>", { :start_count_at => 0, :page_filter => :all, :at => [bounds.right - 50, -25], :align => :right, :size => 10 }
end


def corpo
bounding_box [bounds.left, bounds.top], :width  => bounds.width do
move_down 125

	text "#{Prawn::Text::NBSP}" +"Orçamento", size: 20;
	formatted_text [ 
             { text: "#{Prawn::Text::NBSP}" +"#{Prawn::Text::NBSP}" +" Empresa:    ", size: 10, font: 'Times-Roman', color: '000000', style: :bold}]

  	formatted_text [ 
             { text: "#{Prawn::Text::NBSP}" +"#{Prawn::Text::NBSP * 3}" + "Contato:", size: 10, font: 'Times-Roman', color: '000000', style: :bold}]
          
    linha
    formatted_text [ 
             { text: "#{Prawn::Text::NBSP}" +"Descrição:", size: 10, font: 'Times-Roman', color: '000000', style: :bold}
            
        ]
    

end
end

def titulo
   data = [["Nº do Orçamento","Data do Orçamento","Prazo de Entrega","Prazo de Validade"]]

   table(data, position: :center, :cell_style => { border_width: 0.2, :font => "Times-Roman", size: 10, align: :center }
) do

    row(0).background_color = "f0f0f0"
  end
end

def servico
  move_down 7
    linha
  linha3

fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '000000', '0000ff'
fill_rectangle [0, "#{cursor}".to_f], 270, 17
fill_gradient [540, "#{cursor}".to_f+60], 0, [540, "#{cursor}".to_f+60], 540/2, '000000', '0000ff'
fill_rectangle [270, "#{cursor}".to_f], 270, 17
move_down 3
text 'Descrição de Serviços' , :align => :center, color: 'ffffff'
linha3
move_down 5
linha3
move_down 5

i = 0

end


def material 
    linha3
  move_down 5
    linha3

fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '000000', '0000ff'
fill_rectangle [0, "#{cursor}".to_f], 270, 17
fill_gradient [540, "#{cursor}".to_f+60], 0, [540, "#{cursor}".to_f+60], 540/2, '000000', '0000ff'
fill_rectangle [270, "#{cursor}".to_f], 270, 17

    move_down 3
    text 'Descrição de Materiais' , :align => :center, color: 'ffffff'
    linha3
    move_down 5
    linha3
move_down 5
i = 0
end

def homem
linha3
move_down 5
linha3

fill_gradient [0, "#{cursor}".to_f+60], 0, [0, "#{cursor}".to_f+60], 540/2, '000000', '0000ff'
fill_rectangle [0, "#{cursor}".to_f], 270, 17
fill_gradient [540, "#{cursor}".to_f+60], 0, [540, "#{cursor}".to_f+60], 540/2, '000000', '0000ff'
fill_rectangle [270, "#{cursor}".to_f], 270, 17

move_down 3
text 'Descrição de Serviços Homem-Hora' , :align => :center, color: 'ffffff'
linha3
move_down 5
linha3
move_down 5
i = 0
valor = 0
end

def total_orcamento
    valor = 0
  
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

def linha2
	stroke do
  			move_down 5
  			stroke_color "f0f0f0"
  			line_width 2
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

def ajeitarValor(elem)
    elem = elem.gsub(/[.,R$]/, ',' => '.', '.' => ',', 'R' => '', '$' => '')
end
def ajeitarValor4(elem)
    elem = elem.gsub(/[.,]/, ',' => '.')
end

end



