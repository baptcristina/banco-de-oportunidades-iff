class Users::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]
    include ApplicationHelper

    def new
   if $manutencao
     sair_todos
   else
     super
    end
   end


  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

    protected  

    def after_sign_in_path_for(resource)
        @egresso = Egresso.where(id: current_user.egresso_id).first
        if @egresso.primacesso == false
          @egresso.primacesso = true
          @egresso.save
        end
        ahoy.track "Egresso Login no Sistema", {language: "Ruby", email: current_user.email}
        @visita = Ahoy::Visit.last
         coord =  Geocoder.search(@visita.ip)
        FormAcad.where(egresso_id: current_user.egresso_id).where(habilitado: false).each do |form|
          Local.create(ahoy_visit_id: @visita.id, lat: coord.first.coordinates[0], lon: coord.first.coordinates[1],nome_curso: form.nome_curso, hora: Time.now)
        end  
        '/'
    end


    def after_sign_out_path_for(resource)
        '/'
    end



end
