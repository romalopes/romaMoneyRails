class GroupCategory < ActiveRecord::Base
	has_many :categories, dependent: :destroy

	validates :name, presence: true, length: { minimum: 2, maximum: 50 }
	validates :group_type, presence: true, length: { minimum: 2, maximum: 50 }
end
