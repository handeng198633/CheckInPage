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
		i = 0 if i == 24
        else
                i = string.split(' ')[1].split(':')[0].to_i
        end
        return i.to_s + ':' + string.split(' ')[1].split(':')[1] + ':00'
   end

   def send_request_mail(window_request, mail_address)
      window_request.time_range.split(',').each do |s|
          time_range += '<li>' + s + '</li>'
      end
      if window_request.version == 'rd'
          body_content = '<table class="table"><tr><td>Check-In ID</td><td>' + window_request.username + '</td></tr><tr><td>Branch</td><td>' + window_request.version + '</td></tr><tr><td>Bugzilla ID</td><td>' + window_request.bugid + '</td></tr><tr><td>Files</td><td>' + window_request.filetext.gsub(/\n/, "<br/>") + '</td></tr><tr><td>Reason & Impact to Results</td><td>' + window_request.comment.gsub(/\n/, "<br/>").html_safe + '</td></tr><tr><td>Tests Done</td><td>' + window_request.textdone.gsub(/\n/, "<br/>").html_safe + '</td></tr><tr><td>Group QA Coverage</td><td>' + window_request.Group_qa_coverage + '</td></tr><tr><td>Preferred Time</td><td><table><tr><td><ul>' + time_range + '</ul></td></tr></table></td></tr>'
      else
          body_content = '<table class="table"><tr><td>Check-In ID</td><td>' + window_request.username + '</td></tr><tr><td>Branch</td><td>' + window_request.version + '</td></tr><tr><td>Bugzilla ID</td><td>' + window_request.bugid + '</td></tr><tr><td>Files</td><td>' + window_request.filetext.gsub(/\n/, '<br/>').html_safe + '</td></tr><tr><td>Reason & Impact to Results</td><td>' + window_request.comment.gsub(/\n/, '<br/>').html_safe + '</td></tr><tr><td>Tests Done</td><td>' + window_request.textdone.gsub(/\n/, '<br/>').html_safe + '<tr><td>AE Contact</td><td>' + window_request.ae_contact + '</td></tr><tr><td>Product Category</td><td>' + window_request.product_category + '</td></tr><tr><td>Justification for Back-porting</td><td>' + window_request.justification_back_porting.gsub(/\n/, '<br/>').html_safe + '<tr><td>Change Summary</td><td>' + window_request.change_summary.gsub(/\n/, '<br/>').html_safe + '<tr><td>Impact to DB</td><td>' + window_request.impact_to_db.gsub(/\n/, '<br/>').html_safe + '<tr><td>History</td><td>' + window_request.history.gsub(/\n/, '<br/>').html_safe + '</td></tr><tr><td>Preferred Time</td><td><table><tr><td><ul>' + time_range + '</ul></td></tr></table></td></tr>'
      end
      if window_request.send_copy_ornot == 'yes'
          rd_mail = ',' + mail_address
      else
          rd_mail = ""
      end
      if window_request.mail_cc_list.nil?
          mail_cc_address = ""
      else
          mail_cc_address = ' -c ' + window_request.mail_cc_list
      end
      Open3.popen3('echo ' + body_content + ' |  mail -a "Content-type: text/html" -s "Redhawk check-in request ' + window_request.version + ' (' + window_request.username + ', ' + window_request.bugid + ')"' + mail_cc_address  + ' han.deng@ansys.com' + rd_mail)
   end
end
