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
end
