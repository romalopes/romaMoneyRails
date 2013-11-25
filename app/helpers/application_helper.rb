module ApplicationHelper

	  # Returns the full title on a per-page basis.
  def full_title_page(page_title)
    base_title = "Roma Money Rails"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def categories_by_group(group_category_id)
  	Category.where("group_category_id = ?", group_category_id)
  end
end
