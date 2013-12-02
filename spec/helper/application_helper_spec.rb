require 'spec_helper'

describe ApplicationHelper do

  describe "full_title_page" do
    it "should include the page title" do
      expect(full_title_page("romalopes")).to match(/romalopes/)
    end

    it "should include the base title" do
      expect(full_title_page("romalopes")).to match(/^Roma Money Rails/)
    end

    it "should not include a bar for the home page" do
      expect(full_title_page("")).not_to match(/\|/)
    end
  end

  #Does not work because it doesn't run the sample_data.rake
  # describe "categories_by_group" do
  #   it "should return income group_category" do
  #     expect(categories_by_group(1).count()).should equal(5)
  #   end
  #   it "should return expense group_category" do
  #     expect(categories_by_group(2).count()).should equal(11)
  #   end
  # end

end
