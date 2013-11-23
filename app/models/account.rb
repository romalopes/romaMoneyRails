class Account < ActiveRecord::Base
  belongs_to :user
  has_many :transactions, dependent: :destroy
  
  validates :user_id, presence: true
  validates :name, presence: true, length: { minimum: 6, maximum: 50 }
  validates :balance, :numericality => true
  # before_create {self.balance = 0}
  

  def current_balance
    value = 0.0
    self.transactions.each {
      |t| 
      value += t.value  
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

end