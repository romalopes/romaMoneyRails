class Transaction < ActiveRecord::Base
  belongs_to :category
  belongs_to :account

  validates :account, presence: true
  #validates :category, presence: true
  validates :date, presence: true
  validates :name, presence: true, length: { minimum: 6, maximum: 50 }
  validates :value, :numericality => true

  default_scope -> { order('date DESC') }

  def how_is_value
  	color = ""
  	if self.value > 0
  		color = "blue"
  	else
  		if self.value < 0
  			color = "red"
  		end
  	end
  	return color
  end

end
