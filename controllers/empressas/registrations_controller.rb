  class Empressas::RegistrationsController < Devise::RegistrationsController

#before_action :configure_sign_up_params, only: [:create]
#before_action :configure_account_update_params, only: [:update]



 # def configure_sign_up_params
  #  devise_parameter_sanitizer.for(:sign_up)<<[:first_name,:last_name,:profile_image,:graduation_year,
   #    :email,:password,:password_confirmation, :cnpj]
  #end

  #def configure_account_update_params
   # devise_parameter_sanitizer.for(:account_update)<<[:first_name,:last_name,:profile_image,:graduation_year,
    #   :email,:password,:password_confirmation, :cnpj]
 # end


  # GET /resource/sign_up
  # def new
  #   super
  # end
  before_action :configure_permitted_parameters, if: :devise_controller?

  include ApplicationHelper

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :empresa, :razao_social, :email, :password, :password_confirmation])
  end

def new

  if current_admin.try(:super?) || (current_admin.try(:email)  == 'agencia@iff.edu.br' )
    resource = build_resource({})
    respond_with resource 
  else
    sair_todos
  end
end



def create
  begin
  resource = build_resource({})
  cnpj = params[:empressa][:empresa]
  email = params[:empressa][:email]
  email  = email.downcase
  razao_social = params[:empressa][:razao_social]
  password = params[:empressa][:password]
  password_confirmation = params[:empressa][:password_confirmation]
  if Empresa.where(email: email).present? && Empressa.where(email: email).present?
    redirect_to :back, alert: "CNPJ inválido ou duplicado, ou email já consta no Banco de Oportunidades!"
  else
    @empresa = Empresa.new(cnpj: cnpj, razao_social: razao_social, email: email)
    @empresa.skip_fields_validation = true
    @empresa.save
    Empressa.create!( email: email, razao_social: razao_social, password: password, password_confirmation: password_confirmation , empresa_id: @empresa.id)
    redirect_to new_registration_path(resource_name) , notice: 'Empresa cadastrada com sucesso!'
   end
  rescue ActiveRecord::RecordInvalid => invalid
   puts invalid.record.errors
   @empresa.delete
   redirect_to :back, alert: "CNPJ inválido ou duplicado, ou email já consta no Banco de Oportunidades!"
  end
 end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      @empresa = Empresa.where(id: resource.empresa_id).first
      @empresa.email = resource.email
      @empresa.save!(:validate => false)
      bypass_sign_in resource, scope: resource_name
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end


  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  protected

    def after_update_path_for(resource)
      '/'
    end



  private :resource_params

  def sign_up_params
    params.require(:empressa).permit(:empresa, :email, :razao_social, :password, :password_confirmation,:empresa_id)
  end

  def account_update_params
    params.require(:empressa).permit(:empresa,:email, :razao_social, :password, :password_confirmation, :current_password, :empresa_id)
  end

end
