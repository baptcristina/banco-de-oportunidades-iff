json.extract! info, :id, :assunto, :conteudo, :link, :anexos, :divulgacao, :created_at, :updated_at
json.url info_url(info, format: :json)