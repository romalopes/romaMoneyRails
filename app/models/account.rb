class Account < ActiveRecord::Base
  belongs_to :user
  has_many :user_accounts, dependent: :destroy
  has_many :users, through: :user_accounts

  has_many :transactions, dependent: :destroy
  
  validates :user_id, presence: true
  validates :name, presence: true, length: { minimum: 6, maximum: 50 }
  # before_create {self.balance = 0}
  
  def current_balance
    value = 0.0
    self.transactions.each {
      |t| 
      if t.is_income == true
        value += t.value  
      else
        value -= t.value  
      end
    }
    return value
  end

  def how_is_balance
    color = ""
    balance = current_balance
    if balance > 0
      color = "blue"
    else
      if balance < 0
        color = "red"
      end
    end
    return color
  end

  def user_manager?(user)
    if user.id == user_id
      return true
    end
    return false
  end
end