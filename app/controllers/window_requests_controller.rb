class WindowRequestsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
        @window_request = current_user.window_requests.last
        @messages = Message.order(:created_at).reverse_order.limit(6)
        @window_requests = WindowRequest.paginate(page: params[:page],:per_page => 1 ).order('id DESC')
	@record_requests = current_user.window_requests.last(5)
        @user = current_user
        @user_requests = WindowRequest.where("created_at >= ?", Time.zone.now.beginning_of_day).reverse_order.all
  end

  def new
     
  end

  def create
  end

  def self_requests
 	@user_requests = current_user.window_requests.reverse_order.all
  end

  def select
	@request_record = WindowRequest.new
	@request_record = WindowRequest.find(params[:checkin_request_id])
	respond_to do |format|
		format.html {}
		format.js  {}
	end
  end

  def choose
        @user = current_user
        @request_detail = WindowRequest.new
        @request_detail = WindowRequest.find(params[:checkin_request_id])
        respond_to do |format|
                format.html {}
                format.js  {}
        end
  end

  def apply
        window_request = WindowRequest.new
        window_request = current_user.window_requests.build(window_request_params)
        window_request.status = "Waiting"
        window_request.reason = window_request.reason + window_request.reason_not_rd
        window_request.product_line = current_user.product_line

        if window_request.save!
		message = Message.new
		message.user_id = current_user.id
		message.content = 'New Check-In Window Request: ' + window_request.username + ', ' + window_request.version + ', ' + window_request.time_range
		if window_request.version == 'rd'
			rd_or_not = 'y'
		else
			rd_or_not = 'n'
		end
		if message.save!
			ActionCable.server.broadcast 'room_channel', content:  message.content, username: User.where("id = ?", message.user_id).first.email, created_at: message.created_at.strftime("%Y-%m-%d %H:%M:%S %Z"), requestid: window_request.id, time_range: window_request.time_range, checkinid: window_request.username, version: window_request.version, reason: window_request.reason, comment: window_request.comment, bugid: window_request.bugid, filetext: window_request.filetext, testdone: window_request.textdone, group_qa_coverage: window_request.Group_qa_coverage, rd_or_not: rd_or_not, ae_contact: window_request.ae_contact, product_category: window_request.product_category, justification_back_porting: window_request.justification_back_porting, impact_to_db: window_request.impact_to_db, history: window_request.history, product_line: window_request.product_line
		end
		@record_requests_updated = current_user.window_requests.last(5)
                @window_request_js = current_user.window_requests.last
                respond_to do |format|
                        format.html {}
                        format.js  {}
                end
		window_request.send_request_mail(window_request, current_user.email)
        else
		respond_to do |format|
                        format.js  { flash[:notice] = "Check-In ID and Preferred Time Can not be blank!" }
		end
        end
#	mail_to_qa(User.where("id = ?", message.user_id).first.email, 'qa@ansys.com', message.content)
        window_request.run!(window_request)
  end

  def open
        window_request = WindowRequest.find_by(id: params.keys[1].split('-')[1])
	      #window_request.time_range = params[:window_request][:time_range]
        window_request.time_range = params[:window_request].values.join(',')
        window_request.status = "Opened"
	if window_request.save!
	#open operation, broadcast and active job(command, job_finish_time)
		message = Message.new
		message.user_id = current_user.id
		message.content = 'Opened Check-In Window Request: ' + window_request.username + ', ' + window_request.version + ', ' + window_request.time_range
		if message.save!
			ActionCable.server.broadcast 'room_channel', content:  message.content, username: User.where("id = ?", message.user_id).first.email, created_at: message.created_at.strftime("%Y-%m-%d %H:%M:%S %Z"), status: window_request.status, checkinid: window_request.username, version: window_request.version, time_range: window_request.time_range, reason: window_request.reason, comment: window_request.comment, bugid: window_request.bugid, filetext: window_request.filetext, testdone: window_request.textdone, group_qa_coverage: window_request.Group_qa_coverage
                        #ActionCable.server.broadcast 'room_channel', username: window_request.username, version: window_request.version, time_range: window_request.time_range, comment: window_request.comment
		end
	@window_request_open_js = WindowRequest.new
        @window_request_open_js = window_request
		 respond_to do |format|
			 format.html {}
			 format.js  {}
		 end
	end
  #mail_to_rd('qa@ansys.com', User.where("id = ?", message.user_id).first.email, message.content)
	window_request.open!(@window_request_open_js)

  end

  def hold
        window_request = WindowRequest.find_by(id: params.keys[0].split('-')[1])
        window_request.status = "Unavailable"
        if window_request.save!
                message = Message.new
                message.user_id = current_user.id
		message.content = 'Hold Check-In Window Request: ' + window_request.username + ', ' + window_request.version + ', ' + window_request.time_range
		if message.save!
			ActionCable.server.broadcast 'room_channel', content:  message.content, username: User.where("id = ?", message.user_id).first.email, created_at: message.created_at.strftime("%Y-%m-%d %H:%M:%S %Z"), checkinid: window_request.username, version: window_request.version, time_range: window_request.time_range, comment: window_request.comment, reason: window_request.resaon, status: window_request.status, bugid: window_request.bugid, filetext: window_request.filetext, testdone: window_request.textdone, group_qa_coverage: window_request.Group_qa_coverage
		end
	end
	@window_request_hold_js = WindowRequest.new
	@window_request_hold_js = window_request
		respond_to do |format|
                         format.html {}
                         format.js  {}
                 end
  end

  def destroy
  end
    
  private
  	def window_request_params
		 params.require(:window_request).permit(:username, :version, :time_range, :reason, :reason_not_rd, :comment, :bugid, :filetext, :textdone, :Group_qa_coverage, :justification_back_porting, :impact_to_db, :history, :ae_contact, :product_category, :mail_cc_list, :send_copy_ornot)
	end
end
