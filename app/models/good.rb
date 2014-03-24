class Good < ActiveRecord::Base
  belongs_to :user
  belongs_to :playlist

  scope :mine, ->(user) { where( goods: { user_id: user.id } ) }
end
