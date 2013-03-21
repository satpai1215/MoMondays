class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    @events = Event.all
    gon.numEvents = Event.count

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    @venue = Venue.new({:event_id => @event.id})
    @vote_date = @event.event_start - @event.vote_start.days
    if @vote_date.past?
      @event.update_attributes(:stage => "Voting")
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])
   
      @event.user = current_user
      @event.stage = "Pre-Voting"

      @update = Update.create!(:content => "#{current_user} just created a new event: #{@event}")

      respond_to do |format|
        if @event.save
          format.html { redirect_to @event, notice: 'Event was successfully created.' }
          format.json { render json: @event, status: :created, location: @event }
        else
          format.html { render action: "new" }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end

  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    @update = Update.create!(:content => "#{current_user} just updated #{@event}")

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    @update = Update.create!(:content => "#{current_user} just deleted #{@event}")

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

end