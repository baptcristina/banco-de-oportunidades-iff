json.extract! empresa, :id, :cnpj, :razao_social, :nome_fantasia, :ramo_ativ_id, :site, :email, :endereco, :cep, :cidade, :estado, :created_at, :updated_at
json.url empresa_url(empresa, format: :json)