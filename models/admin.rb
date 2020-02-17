class Admin < ApplicationRecord
	self.primary_key = :id
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :configuracos ,  :dependent => :destroy , :foreign_key => "admin_id"

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
