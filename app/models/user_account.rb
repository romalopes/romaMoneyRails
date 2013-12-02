class UserAccount < ActiveRecord::Base
	belongs_to :account, class_name: "Account"
	belongs_to :user, class_name: "User"
  	validates :user_id, presence: true
  	validates :account_id, presence: true
end
