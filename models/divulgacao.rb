class Divulgacao < ApplicationRecord
	mount_uploader :foto1, Foto1Uploader
	mount_uploader :foto2, Foto2Uploader
	mount_uploader :foto3, Foto3Uploader
	mount_uploader :foto4, Foto4Uploader

	has_many :feeds, foreign_key: 'divulgacao_id', dependent: :destroy
	has_many :infos, foreign_key: 'divulgacao_id', dependent: :destroy

	accepts_nested_attributes_for :feeds, reject_if: proc { |attributes| attributes['assunto'].blank?}, allow_destroy: true
	accepts_nested_attributes_for :infos, reject_if: proc { |attributes| attributes['assunto'].blank?}, allow_destroy: true
	self.primary_key = :id

end
