class Empressa < ApplicationRecord
	  belongs_to :empresa, :class_name => 'Empresa'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	self.primary_key = :id


		validates :password_confirmation, presence: {message: "Os campos Nova Senha e Confirmação de Senha são diferentes."}, if: Proc.new { |a| not a.password == a.password_confirmation }
	validates :password, presence: {message: "Os campos Nova Senha e Confirmação de Senha são diferentes."}, if: Proc.new { |a| not a.password == a.password_confirmation }


	validates :email, uniqueness: {message: "O e-mail informado já encontra-se cadastrado no Sistema."}
	validates :email, format: { with: Devise.email_regexp, message: "E-mail com formato inválido."}


         
end
