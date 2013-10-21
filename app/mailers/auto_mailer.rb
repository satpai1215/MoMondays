 class AutoMailer < ActionMailer::Base
  default from: "MoMondaysMailer@gmail.com", to: "MoMondaysMailer@gmail.com"


  def event_create_email(event_id)
    @event = Event.find(event_id)
    @owner = @event.owner
    @url = event_url(@event)
    @vote_end = @event.event_start - @event.vote_end.hours
    mail(:bcc => email_list(event_id), :subject => "#{@owner} Has Created '#{@event.name}' on the MoMondaysApp!")
  end

  def event_update_email(event_id)
    @event = Event.find(event_id)
    @owner = @event.owner
    @url = event_url(@event)
    @vote_end = @event.event_start - @event.vote_end.hours
    mail(:bcc => email_list(event_id), :subject => "#{@owner} Has Updated '#{@event.name}' on the MoMondaysApp!")
  end

  def send_invite_email(event_id, user_id)
    @event = Event.find(event_id)
    @vote_end = @event.event_start - @event.vote_end.hours
    @owner = @event.owner
    @invited_user = User.find(user_id)
    @url = event_url(@event)
    mail(:bcc => @invited_user.email, :subject => "You have been invited to an event on the Mo' Mondays App!")
  end

  def venue_suggested_email(event_id, venue_id)
    @event = Event.find(event_id)
    @owner = @event.owner
    @venue_owner = Venue.find(venue_id).user.username
    @url = event_url(@event)
    mail(:bcc => @owner.email, :subject => "ALERT: A venue has been suggested for your event, '#{@event.name}'")
  end

  def event_finish_email(event_id)
  	@event = Event.find(event_id)
    @owner = @event.owner
    @winner = Venue.find(@event.winner)
    @winner.address = @winner.address.gsub("<br>", "\n")
  	@url = event_url(@event)
    mail(:bcc => email_list(event_id), :subject => "Voting for '#{@event.name}' Has Finished")

  end

  def voting_reminder_email(event_id)
    @event = Event.find(event_id)
    @owner = @event.owner
    @url = event_url(@event)
    @vote_end = @event.event_start - @event.vote_end.hours
    mail(:bcc => email_list(event_id), :subject => "REMINDER: '#{@event.name}' is on the clock on the MoMondaysApp!")
  end

  def finished_reminder_email(event_id)
    @event = Event.find(event_id)
    @owner = @event.owner
    @winner = Venue.find(@event.winner)
    @winner.address = @winner.address.gsub("<br>", "\n")
    @url = event_url(@event)
    mail(:bcc => email_list(event_id), :subject => "REMINDER: '#{@event.name}' has been scheduled on the MoMondaysApp!")

  end

  def vote_email(event_id)
  	@event = Event.find(event_id)
    @owner = @event.owner
    @url = event_url(@event)
    @vote_end = @event.event_start - 8.hours
    mail(:bcc => email_list(event_id), :subject => "ALERT: Voting for '#{@event.name}' Has Started")
  end

  def no_venue_email(event_id)
    @event = Event.find(event_id)
    @owner = @event.owner
    @url = event_url(@event)
    mail(:to => @owner.email, :subject => "WARNING: No Venues Suggested for '#{@event.name}'")
  end

  def no_venue_email_final(event_id)
    @event = Event.find(event_id)
    @owner = @event.owner
    @url = event_url(@event)
    mail(:to => @owner.email, :subject => "Your Event '#{@event.name}' Has Been Removed (No Venues Suggested)")
  end

  private

  #generates array of user emails for passed event
  def email_list(event_id)
    list = Array.new
    @event = Event.includes(:users).find(event_id)

    @event.users.where(:notification_emails => true).each do |user|
      list.push(user.email)
    end

    return list
  end

end
