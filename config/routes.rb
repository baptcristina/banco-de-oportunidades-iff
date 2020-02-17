Rails.application.routes.draw do
  
  resources :coords
  resources :lembrete_bdos do
    collection do
      get :lembrete_bdo
    end
  end

  resources :divulga_avulsas do
    collection do
      get :divulga_avulsa
    end
  end

  resources :titulacaos
  resources :primacessos do
    collection do
        get :filtro
        get :filtro2
        get :enviar
    end
  end

  resources :infos
  resources :feeds
  resources :divulgacaos do
    collection do
      get :clonar
    end
  end

  resources :questionario_egressos do
    collection do
      get :populate_field
      get :populate_field2
      get :populate_egresso
    end
  end
  
  resources :fale_conoscos
resources :idiomas do
  collection do
    get :edit_multiple
    put :update_multiple
  end
end

resources :roles do
  collection do
    get :edit_multiple
    put :update_multiple
  end
end

  resources :compets do
  collection do
    get :edit_multiple
    put :update_multiple
  end
end

  resources :configuracos do
    collection do
      post :novo
      post :trocar
      delete :deletar
    end
  end
  
  resources :cursos
  resources :pesquisa_empresas do
    collection do
      get :age
    end
  end

  resources :pesquisas
  resources :contatos

  resources :oportunidades do
    collection do
      get :mostrar
      get :enviar_email
      get :clonar
    end
  end
  
  resources :convenios
  resources :empresas do
    collection do
      get :contatar
      get :pesquisar
    end
  end


  resources :relatorio_logins
  resources :excluidos do
    collection do
      delete :deletar
    end
  end

  resources :relatorios do
    collection do
      delete :deletar
      post :deletar_registro
      post :importquestionario
    end
  end

  resources :ferramentas  do
    collection do
      post :import
      post :importempresa
     end
  end



  devise_scope :empressa do #notice "empressas" here, not "empressa"
    get "/sign_in" => "empressas/sessions#new" # custom path to login/sign_in
    get "/sign_up" => "empressas/registrations#new", as: "new_empressa_registration" # custom path to sign_up/registration
  end

  devise_for :empressas, controllers: {sessions: 'empressas/sessions', registrations:  "empressas/registrations" }




  devise_scope :admins do #notice "admins" here, not "admin"
    get "/sign_in" => "admins/sessions#new" # custom path to login/sign_in
    get "/sign_up" => "admins/registrations#new", as: "new_admin_registration" # custom path to sign_up/registration
  end

  devise_for :admins, :skip => [:registrations], controllers: {sessions: 'admins/sessions', registrations:  "admins/registrations" }

  as :admin do
    get 'admins/edit' => 'admins/registrations#edit', :as => 'edit_admin_registration'
    put 'admins' => 'admins/registrations#update', :as => 'admin_registration'
  end



  devise_scope :users do #notice "users" here, not "user"
    get "/sign_in" => "users/sessions#new" # custom path to login/sign_in
    get "/sign_up" => "users/registrations#new", as: "new_user_registration" # custom path to sign_up/registration
  end

  devise_for :users, :skip => [:registrations], controllers: {sessions: 'users/sessions', registrations:  "users/registrations" }

  as :user do
    get 'users/edit' => 'users/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'users/registrations#update', :as => 'user_registration'
  end



  resources :ativ_auts
  resources :ramo_ativs
  resources :exp_profs
  resources :form_compls
  resources :form_acads
  resources :egressos do
    collection do
      get  :listar
      post :reparar_user
      get :pesquisar
      get :mostrar
    end
  end

  resources :pages do 
    collection do
      get :pesquisar      
      get :show
    end
  end

  resources :resultados_parcial do 
    collection do
      get :pesquisar
      get :show
    end
  end

  resources :resultados_total do 
    collection do
      get :pesquisar
      get :show
    end
  end

    resources :resultados_indicadores do 
    collection do
      get :pesquisar
      get :pesquisarI1
      get :show
    end
  end

    resources :totais_egressos_import do 
    collection do
      get :show
      get :pesquisar
      get :pesquisar2
      get :pesquisar3
    end
  end

    resources :totais_egressos_respond do 
    collection do
      get :show
    end
  end

    resources :resultados_subjetivo do 
    collection do
      get :show
      get :pesquisar
    end
  end

      resources :pergunta_subjetiva do 
    collection do
      get :show
      get :pesquisar
    end
  end

  authenticate :admin, -> (admin) {admin.super?} do
    mount Blazer::Engine, at: "blazer"
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'pages/home' => 'high_voltage/pages#show', id: 'home'
  get 'pages/home' => 'high_voltage/pages#pesquisar', id: 'home'  
  get "/pages/resultados_parcial" => "high_voltage/pages#pesquisar", id: 'resultados_parcial'
  get "/pages/resultados_subjetivo" => "high_voltage/pages#pesquisar", id: 'resultados_subjetivo'
  get "/pages/resultados_total" => "high_voltage/pages#pesquisar", id: 'resultados_total'
  get "/pages/resultados_indicadores" => "high_voltage/pages#pesquisar", id: 'resultados_indicadores'
  get "/pages/totais_egressos_import" => "high_voltage/pages#show", id: 'totais_egressos_import'
  get "/pages/analytics" => "high_voltage/pages#show", id: 'analytics'


  get 'egressos/index'
  post 'egressos/new'
  post 'form_acads/new'
  post 'form_compls/new'
  post 'ativ_auts/new'
  post 'exp_profs/new'
  get 'egressos/show'  
  get 'ferramentas/index'
  post 'ferramentas/new'
  post 'empresas/new'
  post 'convenios/new'
  post 'oportunidades/new'
  get 'empresas/show'
  get 'empresas/index'
  post 'contatos/new'
  get 'contatos/index'
  get 'pesquisas/index'
  post 'configuracos/new'
  post 'ramo_ativs/new'
  post 'cursos/new'
  get 'oportunidades/show'
  post 'compets/new'
  post 'idiomas/new'
  post 'idiomas/edit'
  post 'questionario_egressos/new'
  post 'questionario_egressos/edit'
  post "divulgacaos/new"
  get '/pergunta_subjetiva/show'
  get 'cursos/index'
  get 'ramo_ativs/index'
  get 'titulacaos/index'
  post 'titulacaos/new' 

  match '*path', to: redirect('/'), via: :all

end
