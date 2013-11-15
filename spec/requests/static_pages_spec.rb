require 'spec_helper'

describe "Static pages" do

  subject { page }
###############
	shared_examples_for "all static pages" do
	  	#header
		it { should have_link("Roma Money Rails", href: root_path) }
	#			it { should have_image('img', text: "home.png") }
		#footer
	  	it { should have_link("Github", href: "http://github.com/romalopes/romaMoneyRails") }
		it { should have_link("Facebook", href: "http://facebook.com/romalopes") }
		#copywrite 
		it { should have_content('2013 Anderson Araújo Lopes(RomaLopes)') }

	  	it { should have_selector('h1', text: heading) }
	    it { should have_title(full_title_page(page_title)) }
	end

  	describe "When go to any page" do
  		before { visit root_path }
  		
  		describe "should have header" do
			it { should have_link("Roma Money Rails", href: root_path) }
#			it { should have_image('img', text: "home.png") }
  		end
		describe "should have footer" do
	        it { should have_link("Github", href: "http://github.com/romalopes/romaMoneyRails") }
	        it { should have_link("Facebook", href: "http://facebook.com/romalopes") }
	    end
		describe "and should have copywrite" do
			it { should have_content('2013 Anderson Araújo Lopes(RomaLopes)') }
		end
	end

	describe "Home page" do
    	before { visit root_path }
    	let(:heading)    { 'Roma Money Rails' }
    	let(:page_title) { '' }

    	it_should_behave_like "all static pages"
    	it { should_not have_title('| Home') }
    	it { should have_title('Roma Money Rails') }
  	end
 
  	describe "Help page Avoiding duplication" do
    	before { visit help_path }
    	let(:heading)    { 'Help' }
    	let(:page_title) { 'Help' }

	    it_should_behave_like "all static pages"
	    it { should have_title('| Help') }
	    it { should have_content('Help') }
	  end
end