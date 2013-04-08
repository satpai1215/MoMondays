class Venue < ActiveRecord::Base
  attr_accessible :address, :event_id, :name, :user_id, :votecount, :user, :event, :url
  belongs_to :user
  belongs_to :event

  has_many :voters, dependent: :destroy

  def to_s
    self.name
  end
end
