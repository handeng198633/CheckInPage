require 'open3'
class BugidValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
                unless value =~ /^\d{5}$/i
                        record.errors[attribute] << (options[:message] || 'The ID only required 5 digits')
                end
        end
end
class WindowRequest < ApplicationRecord
   belongs_to :user, optional: true

   validates :username, presence: true
   validates :bugid, presence: true, bugid: true

   def run!(window_request)
       OpenWindowRequestJob.set(wait: 1440.minutes).perform_later(window_request)
   end
   def update_window_status(string)
       update_attribute(:status, string)
   end

   def open!(window_request)
      if window_request.product_line == "PA"
         open('/projs00/qa/RUBY241/CheckInPage/public/pa_window.txt', 'a') do |file|
            window_request.time_range.split(',').each do |time|
               file.puts window_request.version + '  ' + window_request.username + '  ' + change2timerule(time)
            end
         end
      else
         open('/projs00/qa/RUBY241/CheckInPage/public/window.txt', 'a') do |file|
            window_request.time_range.split(',').each do |time|
               file.puts window_request.version + '  ' + window_request.username + '  ' + change2timerule(time)
            end
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

   def send_request_mail(window_request, mail_address)
      time_range = ""
      window_request.time_range.split(',').each do |s|
          if not s.nil?
              time_range += '<li>' + s + '</li>'
          end
      end
      #mail_from_address = User.where("id = ?", window_request.user_id).first.email
      if window_request.version == 'rd'
          body_content = '<table class="table"><tr><td>Check-In ID:</td><td>' + window_request.username + '</td><td>  Branch:</td><td>' + window_request.version + '</td><td>Bugzilla ID:</td><td>' + window_request.bugid + '</td></tr></table><table class="table"><tr><td>Files</td><td>' + window_request.filetext.gsub(/\n/, "<br/>") + '</td></tr><tr><td>Change Summary</td><td>' + window_request.reason.gsub(/\n/, "<br/>").html_safe + '</td></tr><tr><td>Impact to Results</td><td>' + window_request.comment.gsub(/\n/, "<br/>").html_safe + '</td></tr><tr><td>Tests Done</td><td>' + window_request.textdone.gsub(/\n/, "<br/>").html_safe + '</td></tr><tr><td>Group QA Coverage</td><td>' + window_request.Group_qa_coverage + '</td></tr><tr><td>Preferred Time</td><td><table><tr><td><ul>' + time_range + '</ul></td></tr></table></td></tr></table>'
      else
          body_content = '<table class="table"><tr><td>Check-In ID:</td><td>' + window_request.username + '</td><td>  Branch:</td><td>' + window_request.version + '</td><td>  Bugzilla ID:</td><td>' + window_request.bugid + '</td></tr></table><table class="table"><tr><td>Files</td><td>' + window_request.filetext.gsub(/\n/, '<br/>').html_safe + '</td></tr><tr><td>Justification for Back-porting</td><td>' + window_request.justification_back_porting.gsub(/\n/, '<br/>').html_safe + '</td></tr><tr><td>Change Summary</td><td>' + window_request.reason.gsub(/\n/, '<br/>').html_safe + '</td></tr><tr><td>Impact to Results</td><td>' + window_request.comment.gsub(/\n/, '<br/>').html_safe + '</td></tr><tr><td>Tests Done</td><td>' + window_request.textdone.gsub(/\n/, '<br/>').html_safe + '<tr><td>AE Contact</td><td>' + window_request.ae_contact + '</td></tr><tr><td>Product Category</td><td>' + window_request.product_category + '</td></tr><tr><td>Justification for Back-porting</td><td>' + window_request.justification_back_porting.gsub(/\n/, '<br/>').html_safe + '<tr><td>Impact to DB</td><td>' + window_request.impact_to_db.gsub(/\n/, '<br/>').html_safe + '<tr><td>Check-In History</td><td>' + window_request.history.gsub(/\n/, '<br/>').html_safe + '</td></tr><tr><td>Preferred Time</td><td><table><tr><td><ul>' + time_range + '</ul></td></tr></table></td></tr></table>'
      end
      if window_request.send_copy_ornot == 'yes'
          rd_mail = ',' + mail_address
      else
          rd_mail = ""
      end
      if window_request.mail_cc_list == ""
          mail_cc_address = ""
      else
          mail_cc_address = ' -c ' + window_request.mail_cc_list
      end
      version = String.new
      product_name = String.new
      if window_request.product_line == 'RH'
          mail_to_address = "redhawk_qa@ansys.com"
          if window_request.version == 'rd'
              version = 'rd'
          else
              version = '"' + window_request.version.sub!("RH", "").sub!("v", ".") + '"'
          end
          product_name = "RedHawk"
      elsif window_request.product_line == 'PA'
          mail_to_address = "powerartist_qa@ansys.com "
          if window_request.version == 'rd'
              version = 'rd'
          else
              version = '"' + window_request.version.sub!("v20", "").sub!("_b","").sub!("_", ".") + '"'
          end
          product_name = "PowerArtist"
      end
      #Open3.popen3('echo ' + body_content + ' |  mail -s "$(echo -e "Redhawk check-in request ' + window_request.version + ' (' + window_request.username + ', ' + window_request.bugid + ')\nContent-Type: text/html")"' + mail_cc_address  + ' han.deng@ansys.com' + rd_mail)
      `echo '#{body_content}' | mail -s "$(echo -e "#{product_name} check-in request #{version} (#{window_request.username}, #{window_request.bugid})\nContent-Type: text/html")" #{mail_cc_address} #{mail_to_address}#{rd_mail} -- -f #{mail_address}` 
   end 
end
