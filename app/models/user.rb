class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :username, :password_confirmation, :remember_me, :access_code, :notification_emails, :firstname, :lastname
  has_many :events, through: :guests
  has_many :guests, dependent: :destroy
  has_many :venues,  dependent: :destroy
  has_many :voters, dependent: :destroy
  has_many :guests, dependent: :destroy

  validates :username, :email, :firstname, :lastname, presence: true
  validates :username, :email, uniqueness: true
  validates :password, presence: true, :on => :create
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_format_of :username, with: /^[a-zA-Z0-9]+[a-zA-Z0-9_\-]*$/
  validates_length_of :username, :minimum => 4, :maximum => 20
  validates_length_of :firstname, :lastname, :minimum => 2, :maximum => 20

  validate :access_code_match, :on => :create

  scope :ordered_by_username, order('username ASC')

  def to_s
    if self.nil?
      "Invalid User"
    else
      self.username
    end
  end

  def access_code_match

    if self.access_code != "smoothitout"
      errors.add(:access_code, "does not match.  Ask Satyan for the correct code" )
    end
  end


  def invited?(event)
      !self.guests.where(:event_id => event.id).empty?
  end

end
