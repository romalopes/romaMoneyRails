class User < ActiveRecord::Base
	#has_many :accounts, dependent: :destroy 
	has_many :user_accounts, dependent: :destroy
	has_many :accounts, through: :user_accounts, dependent: :destroy

	before_save { self.email = email.downcase }
	before_create :create_remember_token
	
	######Validation
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
			uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 }
	######Validation
	
	has_secure_password

	def current_account
		@account = nil
		if current_account_id.present?
      		@account = Account.find(current_account_id)
      	end
    end

	def User.new_remember_token
    	SecureRandom.urlsafe_base64
  	end

  	def User.encrypt(token)
    	Digest::SHA1.hexdigest(token.to_s)
  	end

  	def accounts_size
  		UserAccount.where(user_id:self.id).count
  	end

  	def set_first_account_possible
        if self.accounts_size > 0
          self.update_attribute("current_account_id", self.accounts.first.id)
        else
          self.update_attribute("current_account_id", nil)
        end
    end
      

  	private

	    def create_remember_token
	      self.remember_token = User.encrypt(User.new_remember_token)
	    end
end
