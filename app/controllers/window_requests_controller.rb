class WindowRequestsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
        @window_request = current_user.window_requests.last
        @messages = Message.order(:created_at).reverse_order.limit(6)
        @window_requests = WindowRequest.paginate(page: params[:page],:per_page => 1 ).order('id DESC')
  end

  def new
     
  end

  def create
  end

  def apply
        window_request = WindowRequest.new
        window_request = current_user.window_requests.build(window_request_params)
        window_request.status = "Waiting"

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
			ActionCable.server.broadcast 'room_channel', content:  message.content, username: User.where("id = ?", message.user_id).first.email, created_at: message.created_at.strftime("%Y-%m-%d %H:%M:%S %Z"), requestid: window_request.id, time_range: window_request.time_range, checkinid: window_request.username, version: window_request.version, comment: window_request.comment, bugid: window_request.bugid, filetext: window_request.filetext, testdone: window_request.textdone, group_qa_coverage: window_request.Group_qa_coverage, rd_or_not: rd_or_not, ae_contact: window_request.ae_contact, product_category: window_request.product_category, justification_back_porting: window_request.justification_back_porting, change_summary: window_request.change_summary, impact_to_db: window_request.impact_to_db, history: window_request.history 
		end
                @window_request_js = current_user.window_requests.last
                respond_to do |format|
                        format.html {}
                        format.js  {}
                end
        else
                redirect_to '/window_requests'
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
			ActionCable.server.broadcast 'room_channel', content:  message.content, username: User.where("id = ?", message.user_id).first.email, created_at: message.created_at.strftime("%Y-%m-%d %H:%M:%S %Z"), status: window_request.status, checkinid: window_request.username, version: window_request.version, time_range: window_request.time_range, comment: window_request.comment, bugid: window_request.bugid, filetext: window_request.filetext, testdone: window_request.textdone, group_qa_coverage: window_request.Group_qa_coverage
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
			ActionCable.server.broadcast 'room_channel', content:  message.content, username: User.where("id = ?", message.user_id).first.email, created_at: message.created_at.strftime("%Y-%m-%d %H:%M:%S %Z"), checkinid: window_request.username, version: window_request.version, time_range: window_request.time_range, comment: window_request.comment, status: window_request.status, bugid: window_request.bugid, filetext: window_request.filetext, testdone: window_request.textdone, group_qa_coverage: window_request.Group_qa_coverage
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
		 params.require(:window_request).permit(:username, :version, :time_range, :comment, :bugid, :filetext, :textdone, :Group_qa_coverage, :justification_back_porting, :change_summary, :impact_to_db, :history, :ae_contact, :product_category)
	end
end
