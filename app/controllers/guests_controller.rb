class GuestsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :get_event, :only => [:new, :edit, :destroy]
	before_filter :auth_owner, :only => [:new, :edit, :destroy]

#before_filter methods
	def get_event
		@event = Event.find(params[:event_id])
	end

	def auth_owner
		if(current_user.id != @event.owner_id)
			redirect_to events_path, :notice => "You are not authorized to do that."
		end

	end
#end before_filter methods

	def new
	    respond_to do |format|
        	format.html { render :partial => "guest_form" }
        	#format.js
	    end
	end

	def new
		@guest = Guest.new
	    respond_to do |format|
        	format.html { render :partial => "guest_form" }
        	#format.js
	    end
	end

	def update_guestlist
		respond_to do |format|
			format.html {redirect_to Event.find(params[:event_id]), :notice => params.to_s}
			#format.js
		end
	end


	def destroy

	end


end