class Message < ApplicationRecord
   belongs_to :user, optional: true 
   scope :for_display, -> { order(:created_at).last(10) }
end
