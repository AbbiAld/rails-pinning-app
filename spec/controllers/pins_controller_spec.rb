require 'spec_helper'
RSpec.describe PinsController do
	describe "GET index" do
		it 'renders the index template' do
			get :index
			expect(response).to render_template("index")
		end

		it 'populates @pins with all pins' do
			get :index
			expect(assigns[:pins]).to eq(Pin.all)
		end

	end

	describe "GET new" do
		it 'responds successfully' do
			get :new
			expect(response.success?).to be(true)
		end

		it 'renders the new view' do
			get :new
			expect(response).to render_template(:new)
		end

		it 'assigns an instance variable to a new pin' do
			get :new
			expect(assigns(:pin)).to be_a_new(Pin)
		end
	end

	describe "POST create" do
		before(:each) do
			@pin_hash = {
				title: "Rails Wizard",
				url: "http://railswizard.org",
				slug: "rails-wizard",
				text: "A fun and helpful Rails Resource",
				category_id: 1
			}
		end

		after(:each) do
			pin = Pin.find_by_slug("rails-wizard")
			if !pin.nil?
				pin.destroy
			end
		end

		it 'responds with a redirect' do 
			post :create, pin: @pin_hash
			expect(response.redirect?).to be(true)
		end

		it 'creates a pin' do
			post :create, pin: @pin_hash
			expect(Pin.find_by_slug("rails-wizard").present?).to be(true)
		end

		it 'redirect to the show view' do
			post :create, pin: @pin_hash
			expect(response).to redirect_to(pin_url(assigns(:pin)))
		end

		it 'redisplays new form on error' do
			# The title is required in the Pin model, so we'll
      # delete the title from the @pin_hash in order
			# to test what happens with invalid parameters
			@pin_hash.delete(:title)
			post :create, pin: @pin_hash
			expect(response).to render_template(:new)
		end

		it 'assigns the @errors instance variable on error' do
			# The title is required in the Pin model, so we'll
      # delete the title from the @pin_hash in order
			# to test what happens with invalid parameters
			@pin_hash.delete(:title)
			post :create, pin: @pin_hash
			expect(assigns[:errors].present?).to be(true)
		end
	end

	describe "GET edit" do
		before(:each) do
			@pin = Pin.first
			get :edit, id: @pin.id
		end
		#responds successfully
		it 'responds successfully' do
			expect(response.success?).to be(true)
		end
		#renders the edit template
		it 'renders the edit template' do
			expect(response).to render_template(:edit)
		end

		#assigns an instance variable call @pin to the PIn with the appropriate id
		it 'assigns an instance variable called @pin to the Pin with the appropriate id' do
			expect(assigns(:pin)).to eq(Pin.first)
		end
	end

	describe "PUT update" do
		before(:each) do
			@pin = Pin.first
			@new_title = {title: "New Rails Title"}
			@bad_title = {title: ""}
		end
		#responds with a redirect
		it 'responds with a redirect' do
			put :update, pin: @new_title, id: @pin.id
			@pin.reload
			expect(response.redirect?).to be(true)
		end

    #updates a pin
    it 'updates a pin' do
    	put :update, pin: @new_title, id: @pin.id
    	expect(Pin.find_by_title("New Rails Title").present?).to be(true)
    end

    #redirects to the show view
    it 'redirects to the show view' do
    	put :update, pin: @new_title, id: @pin.id
    	expect(response).to redirect_to(pin_url(@pin.id))
    end

    #assigns an @errors instance variable
    it 'assigns an @errors instance variable' do
    	put :update, pin: @bad_title, id: @pin.id
    	expect(assigns[:errors].present?).to be(true)
    end
    #renders the edit view
    it 'renders the edit view with an error' do
    	put :update, pin: @bad_title, id: @pin.id
    	expect(response).to render_template(:edit)
    end

	end

end