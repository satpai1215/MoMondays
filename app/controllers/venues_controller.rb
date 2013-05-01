class VenuesController < ApplicationController
  before_filter :authenticate_user!

  # GET /venues/new
  # GET /venues/new.json
  def new
    @event_id = params[:event_id]
    @event_user = Event.find(@event_id).user
    @already_suggested_venue = Venue.exists?(:user_id => current_user.id, :event_id => @event_id)

    #only allow multiple venue suggestion if user is event owner
    if @already_suggested_venue and (current_user != @event_user)
      respond_to do |format|
        format.html { redirect_to event_path(@event_id),
                      notice: "You have already suggested a venue for this event. Try removing your existing venue."}
        format.js
      end
    else
      @venue = Venue.new
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @venue }
        format.js
      end
    end
  end

  # GET /venues/1/edit
  def edit
    @venue = Venue.find(params[:id])
    @event_id = @venue.event.id

    respond_to do |format|
      format.html # edit.html.erb
      format.json { render json: @venue }
      format.js {render action: 'new'}
    end

  end

  # POST /venues
  # POST /venues.json
  def create
    @venue = Venue.new(params[:venue])

    if(@venue.event != nil)
      @venue.user = current_user
      @venue.votecount = 0
      @update = Update.create!(:content => "#{current_user} just suggested a venue for \"#{@venue.event}\"")

      respond_to do |format|
        if @venue.save
          format.html { redirect_to @venue.event, notice: 'Venue added successfully.' }
          format.json { render json: @venue.event, status: :created, location: @venue.event }
          format.js
        else
          @event_id = @venue.event.id
          format.html { render action: "new"}
          format.json { render json: @venue.errors, status: :unprocessable_entity }
          format.js {render action: "new"}
        end
      end

    #checks that new venue is linked to an event, not just created via URL
    else
      redirect_to events_path, notice: 'You are not allowed to do this.'
    end
  end

  # PUT /venues/1
  # PUT /venues/1.json
  def update
    @venue = Venue.find(params[:id])

    respond_to do |format|

      if @venue.update_attributes(params[:venue])
        if(@venue.changed?)
          #reset votecount for venue if it is modified
          @venue.update_attributes(:votecount => 0)
          #remove voting records for venue if it is modified
          Voter.destroy_all(:venue_id => @venue.id)

          @update = Update.create!(:content => "#{current_user} just modified a venue for \"#{@venue.event}\"")
       end
        format.html { redirect_to @venue.event, notice: 'Venue was successfully updated.' }
        format.json { head :no_content }
        format.js { render :js => %(window.location = '#{event_path(@venue.event.id)}')}
      else
        @event_id = @venue.event.id
        format.html { render action: "edit" }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
        format.js { render action: "new" }
      end
    end
  end

  # DELETE /venues/1
  # DELETE /venues/1.json
  def destroy
    @venue = Venue.find(params[:id])
    @update = Update.create!(:content => "#{current_user} just deleted a venue for \"#{@venue.event}\"")


    respond_to do |format|
      format.html { redirect_to @venue.event, notice: "You have successfully removed your suggested venue" }
      format.js
      format.json { head :no_content }
    end
      @venue.destroy
  end

  def increment_vote

    if !user_signed_in?
      #redirect_to @venue.event, notice: "You must be signed in to vote."
    else

       @venue = Venue.find(params[:venue_id])
       @already_voted = Voter.exists?(:user_id => current_user.id, :event_id => params[:event_id ])


      if (@already_voted)
         respond_to do |format|
           format.html {redirect_to @venue.event, notice: "You have already voted for this event"}
           format.js
         end

      else
        num = @venue.votecount
        @venue.update_attributes(:votecount => num + 1 )

        Voter.create!(:user_id => current_user.id, :event_id => @venue.event.id, :venue_id => @venue.id)
        Update.create!(:content => "#{current_user} just voted for #{@venue} for the event: \"#{@venue.event}\"")

        respond_to do |format|
          format.html {redirect_to @venue.event, notice: "Your vote has been recorded."}
          format.js
        end
      end
    end

  end

end
