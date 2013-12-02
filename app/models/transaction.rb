class Transaction < ActiveRecord::Base
  belongs_to :category
  belongs_to :account

  validates :account, presence: true
  validates :category, presence: true
  validates :date, presence: true
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :value, :numericality => true
  validate :greater_than_or_equal_to_zero

  default_scope -> { order('date DESC') }

  def is_income
      category = Category.find(self.category_id)
      return category.group_category_id == 1 
  end

  def how_is_value
    if self.value == 0
      return ""
    end
  	color = ""
  	if is_income
  		color = "blue"
  	else
 			color = "red"
  	end
  	return color
  end

  def greater_than_or_equal_to_zero
    if value < 0
      errors.add(:value, "can't should be greater or equal to 0")
    end
  end
end
