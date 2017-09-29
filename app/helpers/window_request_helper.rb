require 'open3'
module WindowRequestHelper
   def mail_to_qa(from_address, to_address, content)
      Open3.popen3('echo ' + content + ' |  mail -s "New Check-In window request" ' + to_address)
   end

   def mail_to_rd(from_address, to_address, content)
      Open3.popen3('echo ' + content + ' |  mail -s "Your Check-iN window opened" ' + to_address)
   end

   def time_range(string)
        return time_change(string.split(' - ')[0]) + ' ' + time_change(string.split(' - ')[1]) + ' ' + string.split(' - ')[0].split(' ')[0]
   end

   def time_change(string)
        if string.split(' ')[2] == 'PM'
                i = string.split(' ')[1].split(':')[0].to_i + 12
        else
                i = string.split(' ')[1].split(':')[0].to_i
        end
        return i.to_s + ':' + string.split(' ')[1].split(':')[1] + ':00'
   end
end
