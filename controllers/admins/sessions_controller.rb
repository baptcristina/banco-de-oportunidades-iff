class Admins::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
    include ApplicationHelper

   # def new
   #if $manutencao
   #  sair_todos
   #else
   #  super
   # end
   #end

  def new
    puts request.env["HTTP_X_FORWARDED_FOR"]
     super
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
        puts request.env["HTTP_X_FORWARDED_FOR"]
        '/'
    end


    def after_sign_out_path_for(resource)
        '/'
    end



end
