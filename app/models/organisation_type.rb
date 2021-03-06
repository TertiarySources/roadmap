class OrganisationType < ActiveRecord::Base
  attr_accessible :description, :organisations, :name, :as => [:default, :admin]

  has_many :organisations

  validates :name, presence: true, uniqueness: true
end
