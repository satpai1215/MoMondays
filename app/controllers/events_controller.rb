class EventsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]

  # GET /events
  # GET /events.json
  def index
    #only display events that are not finished
    @events = Event.find(:all, :conditions => ["stage != ?", "Finished"])
    gon.numEvents = @events.count

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

      respond_to do |format|
        if @event.save
          #flash[:alert] = "#{@event.event_start}"
          #@event.event_email_job_id = @event.@event.delay({:run_at => @event.event_start}).event_finish(@event.id)
          write_jobs(@event.id)
          @update = Update.create!(:content => "#{current_user} just created a new event: \"#{@event}\"")
          
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

    respond_to do |format|
      if @event.update_attributes(params[:event])
        @update = Update.create!(:content => "#{current_user} just updated \"#{@event}\"")

        write_jobs(@event.id)

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
    destroy_jobs(@event.id)
    @event.destroy
    @update = Update.create!(:content => "#{current_user} just deleted \"#{@event}\"")

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

=begin

  def event_finish(event_id)
    @event = Event.find(event_id)
    event.update_attributes(:stage => "Finished")
    event.update_attributes(:winner => event.venues.order("votecount DESC").first.id)
    #Automailer.event_email(event_id).deliver
  end

  def voting_begin(event_id)
    @event = Event.find(event_id)
    event.update_attributes(:stage => "Voting")
    Automailer.vote_email(event_id).deliver
  end

=end  

private

  def write_jobs(event_id)
    @event = Event.find(event_id)

    #delete delayed_jobs if it exists
    destroy_jobs(event_id)

    #rewrite delayed_jobs for updated event
    event_job = Delayed::Job.enqueue(EventFinishJob.new(@event.id), 0, @event.event_start)
    vote_job = Delayed::Job.enqueue(VoteStartJob.new(@event.id), 0, @event.event_start - @event.vote_start.days)

    # save id of delayed job on Event record
    @event.update_attributes(:event_email_job_id => event_job.id)
    @event.update_attributes(:voting_email_job_id => vote_job.id)

  end

  def destroy_jobs(event_id)
    @event = Event.find(event_id)
    Delayed::Job.find(@event.event_email_job_id).destroy if @event.event_email_job_id
    Delayed::Job.find(@event.voting_email_job_id).destroy if @event.voting_email_job_id

  end




end