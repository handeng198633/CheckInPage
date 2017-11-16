require 'open3'
class WindowRequest < ApplicationRecord
   belongs_to :user, optional: true

   validates :username, presence: true

   def run!(window_request)
       OpenWindowRequestJob.set(wait: 1440.minutes).perform_later(window_request)
   end
   def update_window_status(string)
       update_attribute(:status, string)
   end

   def open!(window_request)
      open('/projs00/qa/RUBY241/CheckInPage/public/window.txt', 'a') do |file|
         window_request.time_range.split(',').each do |time|
            file.puts window_request.version + '  ' + window_request.username + '  ' + change2timerule(time)
         end
      end
   end

   def mail_to_qa(from_address, to_address, content)
      Open3.popen3('echo ' + content + ' |  mail -s "New Check-In window request" ' + to_address)
   end

   def mail_to_rd(from_address, to_address, content)
      Open3.popen3('echo ' + content + ' |  mail -s "Your Check-iN window opened" ' + to_address)
   end

   def change2timerule(time_string)
        time = time_string
        return time_change(time.split(' - ')[0]) + ' ' + time_change(time.split(' - ')[1]) + ' ' + time.split(' - ')[0].split(' ')[0]
   end

   def time_change(change_string)
        if change_string.split(' ')[2] == 'PM'
                i = change_string.split(' ')[1].split(':')[0].to_i + 12
		i = 0 if i == 24
        else
                i = change_string.split(' ')[1].split(':')[0].to_i
        end
        return i.to_s + ':' + change_string.split(' ')[1].split(':')[1] + ':00'
   end
   
end
