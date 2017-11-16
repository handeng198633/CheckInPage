App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
      $('#messages-table').prepend '<div class="box-comment">' + '<div class="comment-text">' + '<span class="username">' + data.username + '<span class="text-muted pull-right">' + data.created_at + '</span></span>' + data.content + '</div></div>'
      new Noty( type: 'info', layout: 'topLeft', text: data.username + ': Request have new update!').show()
      if data.status == 'Opened'
          boxstatus = 'success'
      else if data.status == 'Unavailable'
          boxstatus = 'danger'
      $('#request_result_' + data.checkinid).html '<div id="statusbox" class="box box-' + boxstatus + ' box-solid">' + '<div class="box-header box-' + boxstatus + ' with-border">' + '<h3 class="box-title">' + data.status + '</h3>' + '<div class="box-tools pull-right">' + '<button type="button" class="btn btn-box-tool" data-widget="collapse">' + '<i class="fa fa-minus">' + '</i></button></div></div>' + '<div class="box-body"><table class="table"><tbody><tr><td>Check-In ID</td><td>' + data.checkinid + '</td></tr><tr><td>Branch</td><td>' + data.version + '</td></tr><tr><td>Bugzilla ID</td><td>' + data.bugid + '</td></tr><tr><td>Files</td><td style ="word-break:break-all;" >' + data.filetext.replace('\n', '<br/>') + '</td></tr><tr><td>Reason & Impact to Results</td><td style ="word-break:break-all;" >' + data.comment.replace('\n', '<br/>') + '</td></tr><tr><td>Tests Done</td><td style ="word-break:break-all;" >' + data.testdone.replace('\n', '<br/>') + '</td></tr><tr><td>Group QA Coverage</td><td>' + data.group_qa_coverage + '</td></tr><tr><td>Window Range</td><td><table><tr><td><ul><li>' + data.time_range + '</li></ul></td></tr></table></td></tr></table></div></div></div>'
      if data.requestid?
          number = data.requestid.toString()
          if data.rd_or_not == 'y'
              $('#request-push').html '<div id="openbox-' + number + '" class="col-md-12"><div id="statusbox-' + number + '" class="box box-warning box-solid"><div class="box-header with-border"><h3 class="box-title">Waiting</h3><div class="box-tools pull-right"><button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button></div></div><div class="box-body"><table class="table"><tbody><tr><td>Check-In ID</td><td>' + data.checkinid + '</td></tr><tr><td>Branch</td><td>' + data.version + '</td></tr><tr><td>Bugzilla ID</td><td>' + data.bugid + '</td></tr><tr><td>Files</td><td style="word-break:break-all;">' + data.filetext.replace('\n', '<br/>') + '</td></tr><tr><td>Reason &amp; Impact to Results</td><td style="word-break:break-all;">' + data.comment.replace('\n', '<br/>') + '</td></tr><tr><td>Tests Done</td><td style="word-break:break-all;">' + data.testdone + '</td></tr><tr><td>Group QA Coverage</td><td>' + data.group_qa_coverage + '</td></tr><tr><td>Window Range</td><td><table><tbody><tr><td><ul><li>' + data.time_range + '</li></ul></td></tr></tbody></table></td></tr></tbody></table><div class="text-center"><button id="append-timerange-' + number + '"class="btn btn-sm btn-primary"> + </button><button id="remove-timerange-' + number + '" class="btn btn-sm btn-primary"> — </button></div><form accept-charset="UTF-8" action="/open" method="post" class="form-group" data-remote="true"><div id="form-timerange-' + number + '"><div class="input-group"><div class="input-group-addon"><i class="fa fa-clock-o"></i></div><input name="window_request[time_range_1]" class="form-control pull-right" id="reservationtime-confirm-' + number + '-1" type="text"></div></div><div class="row"><div class="col-md-1"><label></label><input class="btn btn-large btn-primary" name="commit" value="OPEN" type="submit"></div></div></form><form accept-charset="UTF-8" action="/hold" method="post" class="form-group" data-remote="true"><div class="row"><div class="col-md-1"><input class="btn btn-large btn-primary" name="id-' + number+ '" value="HOLD" type="submit"></div></div></form><div></div></div>'
          else if data.rd_or_not == 'n'
              $('#request-push').html '<div id="openbox-' + number + '" class="col-md-12"><div id="statusbox-' + number + '" class="box box-warning box-solid"><div class="box-header with-border"><h3 class="box-title">Waiting</h3><div class="box-tools pull-right"><button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button></div></div><div class="box-body"><table class="table"><tbody><tr><td>Check-In ID</td><td>' + data.checkinid + '</td></tr><tr><td>Branch</td><td>' + data.version + '</td></tr><tr><td>Bugzilla ID</td><td>' + data.bugid + '</td></tr><tr><td>Files</td><td style="word-break:break-all;">' + data.filetext.replace('\n', '<br/>') + '</td></tr><tr><td>Reason &amp; Impact to Results</td><td style="word-break:break-all;">' + data.comment.replace('\n', '<br/>') + '</td></tr><tr><td>Tests Done</td><td style="word-break:break-all;">' + data.testdone + '</td></tr><tr><td>AE Contact</td><td>' + data.ae_contact + '</td></tr><tr><td>Product Category</td><td>' + data.product_category + '</td></tr><tr><td>Justification for Back-porting</td><td style="word-break:break-all;">' + data.justification_back_porting.replace('\n', '<br/>') + '</td></tr><tr><td>Change_summary</td><td style="word-break:break-all;">' + data.change_summary.replace('\n', '<br/>') + '</td></tr><tr><td>Impact to DB</td><td style="word-break:break-all;">' + data.impact_to_db.replace('\n', '<br/>') + '</td></tr><tr><td>History</td><td style="word-break:break-all;">' + data.history.replace('\n', '<br/>') + '</td></tr><tr><td>Window Range</td><td><table><tbody><tr><td><ul><li>' + data.time_range + '</li></ul></td></tr></tbody></table></td></tr></tbody></table><div class="text-center"><button id="append-timerange-' + number + '"class="btn btn-sm btn-primary"> + </button><button id="remove-timerange-' + number + '" class="btn btn-sm btn-primary"> — </button></div><form accept-charset="UTF-8" action="/open" method="post" class="form-group" data-remote="true"><div id="form-timerange-' + number + '"><div class="input-group"><div class="input-group-addon"><i class="fa fa-clock-o"></i></div><input name="window_request[time_range_1]" class="form-control pull-right" id="reservationtime-confirm-' + number + '-1" type="text"></div></div><div class="row"><div class="col-md-1"><label></label><input class="btn btn-large btn-primary" name="commit" value="OPEN" type="submit"></div></div></form><form accept-charset="UTF-8" action="/hold" method="post" class="form-group" data-remote="true"><div class="row"><div class="col-md-1"><input class="btn btn-large btn-primary" name="id-' + number+ '" value="HOLD" type="submit"></div></div></form><div></div></div>'
          $('#reservationtime-confirm-'  + number + '-1').daterangepicker
             timePicker: true
             timePickerIncrement: 10
             timePicker24Hour: true
             locale: format: 'MM/DD/YYYY h:mm A'
          $(document).ready ->
             click_number = 2
             $('#append-timerange-' + number).click ->
                 $('#form-timerange-' + number).append '<div class="input-group"><div class="input-group-addon"><i class="fa fa-clock-o"></i></div><input id="reservationtime-confirm-append" type="text" name="window_request[time_range_' + click_number + ']" class="form-control pull-right"></div>'
                 click_number++
                 $('input[id=\'reservationtime-confirm-append\']').daterangepicker
                     timePicker: true
                     timePickerIncrement: 1
                     timePicker24Hour: true
                     locale: format: 'MM/DD/YYYY h:mm A'
             return
             $('#remove-timerange-' + number).click ->
                 select = document.getElementById('form-timerange-' + number)
                 select.removeChild select.lastChild
             return
          return
