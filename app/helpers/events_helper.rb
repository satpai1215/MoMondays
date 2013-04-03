
module EventsHelper

	def display_modifiers_event(event)
		html = ""
		if(current_user == event.user && event.stage != "Finished")
			html<< "(" + link_to('Edit', edit_event_path(event)) + " | "
        	html << link_to('Delete', event, method: :delete, data:{ confirm: 'Are you sure?' })
        	html << ")"
    	end
    	return html.html_safe
	end

	def display_countdowns_and_venue_button(event)
		html = ""
		html << '<h3>' + display_date_or_countdown(event) + '</h3>'
		html << display_prevoting_countdown(event)

		if(event.stage == "Pre-Voting")
			html << "#{link_to "Suggest a Venue -->", 
			new_venue_path(:event_id => @event.id, :user => current_user), :id => "suggestVenueLink"}"
		end

		return html.html_safe
	end

	def display_date_or_countdown(event)

		
		if event.stage == "Pre-Voting"
			return "Voting Begins On:</br>  \<span id = 'voteDate'>#{@vote_date.strftime("%B %d, %Y at %I:%M%p")}</span>\ "
		elsif event.stage == "Voting"
			return "Time Left to Vote:</br> \<span id = 'voteCountdown'></span>\ "
		else
			return "<span id = 'eventOverHeading'>EVENT OVER</span>"

		end
	end

	def display_prevoting_countdown(event)
		html = ""
		#only show Suggest Venue Form if Event is in 'pre-voting' stage
		if event.stage == "Pre-Voting"
			html << '<p>You have <span id = "venueSuggestCountdown"></span> to suggest a venue!</p>'
		end
		
		return html
	end

	def display_event_stage(stage)
		return (stage == "Pre-Voting" ? "Venue Suggestion" : stage)

	end

	def generate_venue_sticky(venue)
		html = ""
		html << "<b>#{venue.name}</b> </br>"
		html << "Address: #{venue.address} </br>"
		if venue.url != "" 
			html << "#{link_to "Yelp Page", venue.url, :target => '_blank'} </br>"
		end

		html << "Suggested By: #{venue.user.username} </br>"
		
		html << display_modifiers_venue(venue)

		return html.html_safe

	end

end