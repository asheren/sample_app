require 'spec_helper'

describe ApplicationHelper do 

	describe "full_title" do
		it "should include the page title" do 
			expect(full_title("foo")).to match(/foo/)
		end

		it "should include the base title" do
			expect(full_title("foo")).to match(/^Ruby on Rails Tutorial Sample App/)
		end

		it "shoud not include a bar for the home page" do
			expect(full_title('')).not_to match(/\|/)
		end
	end
end

describe "Static Pages" do

	subject { page }

	shared_examples_for "all static pages" do
		it { should have_selector('h1', text: heading) }
		it { should have_title(full_title(page_title)) }
	end

  describe "Home page" do
  	before { visit root_path }
  	let(:heading) 		{ visit root_path }
  	let(:page_title)  { '' }

    it_should_behave_like "all static pages"
 		it { should_not have_title('| Home') }
 	
 		describe "for signed-in users" do
 			let(:user) { FactoryGirl.create(:user) }
 			before do
 				FactoryGirl.create(:micropost, user: user, content: "Lorem")
 				FactoryGirl.create(:micropost, user: user, content: "Ipsum")
 				sign_in user
 				visit root_path
 			end

 			it "should render the user's feed" do
 				user.feed.each do |item|
 					expect(page).to have_selector("li##{item.id}", text: item.content)
 				end
 			end

 			describe "follower/following counts" do
 				let(:other_user) { FactoryGirl.create(:user) }
 				before do
 					other_user.follow!(user)
 					visit root_path
 				end

 				it { should have_link("0 following", href: following_user_path(user)) }
 				it { should have_link("1 followers", href: followers_user_path(user)) }
 			end
 		end
 	end

	describe "Help page" do
		before { visit help_path }

		it { should have_content('Help') }
		it { should have_title(full_title('Help')) }
	end

	describe "About page" do
		before { visit about_path }

		it { should have_content('About') }
		it { should have_title(full_title('About Us')) } 
	end

	describe "Contact page" do 
		before { visit contact_path }

		it { should have_selector('h1', text: 'Contact') }
		it { should have_title(full_title('Contact')) } 
	end

	#	it "should have the right links on the layout" do
	#		visit root_path
	#		click_link "About"
	#		expect(page).to have_title(full_title('About Us'))
	#		click_link "Help"
	#		expect(page).to have_title(full_title('Help'))
	#		click_link "Contact"
	#		expect(page).to have_title(full_title('Contact'))
	#		click_link "Home"
	#		click_link "Sign up now!"
	#		expect(page).to have_title(full_title(''))
	#		click_link "sample app"
	#		expect(page).to have_title(full_title('Sample App'))
	#	end
end