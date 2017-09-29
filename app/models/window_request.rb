require 'open3'
class WindowRequest < ApplicationRecord
   belongs_to :user, optional: true

   validates :username, presence: true
   validates :time_range, presence: true

   def run!(window_request)
       OpenWindowRequestJob.set(wait: 10.minutes).perform_later(window_request)
   end
   def update_window_status(string)
       update_attribute(:status, string)
   end

   def open!(window_request)
      open('/projs00/qa/RUBY241/CheckInPage/public/window.txt', 'a') do |f|
         f << window_request.version + '  ' + window_request.username + '  ' + window_request.time_range.split('-')[0] + '  ' + window_request.time_range.split('-')[1]
      end
   end

   def mail_to_qa(from_address, to_address, content)
      Open3.popen3('echo ' + content + ' |  mail -s "New Check-In window request" ' + to_address)
   end

   def mail_to_rd(from_address, to_address, content)
      Open3.popen3('echo ' + content + ' |  mail -s "Your Check-iN window opened" ' + to_address)
   end

   
end
