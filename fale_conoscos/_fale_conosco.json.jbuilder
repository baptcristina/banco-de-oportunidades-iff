json.extract! fale_conosco, :id, :email, :assunto, :mensagem, :created_at, :updated_at
json.url fale_conosco_url(fale_conosco, format: :json)