class Category < ActiveRecord::Base
	belongs_to :group_category

	validates :name, presence: true, length: { minimum: 2, maximum: 50 }
	validates :group_category_id, presence: true
end
