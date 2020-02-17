class Empressas::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
    include ApplicationHelper

    def new
   if $manutencao
     sair_todos
   else
     super
    end
   end

  # def new
  #   super
  # end

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
        ahoy.track "Empresa Login no Sistema", {language: "Ruby", email: current_empressa.email}
        '/'
    end


    def after_sign_out_path_for(resource)
        '/'
    end


end
