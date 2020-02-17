json.extract! relatorio, :id, :tipo, :quantidade_total, :quantidade_erros, :created_at, :updated_at
json.url relatorio_url(relatorio, format: :json)