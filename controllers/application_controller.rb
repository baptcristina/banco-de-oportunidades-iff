class ApplicationController < ActionController::Base
protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }


 / Admin.create!(email: 'admin@iff.edu.br', password: 'admin1', password_confirmation: 'admin1')/
 / Admin.update(email: 'pesquisador@iff.edu.br', password: 'bdopesq19', password_confirmation: 'bdopesq19') /

$manutencao = false

$idioma = ["Básico", "Intermediário", "Avançado", "Fluente"]



end
