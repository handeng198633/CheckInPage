class WindowRequestsController < ApplicationController
  def index
        @window_request = current_user.window_requests.last
        @messages = Message.order(:created_at).reverse_order.limit(6)
        @window_requests = WindowRequest.paginate(page: params[:page],:per_page => 3 ).order('id DESC')
  end

  def new
     
  end

  def create
#	window_request = WindowRequest.new
#	window_request = current_user.window_requests.build(window_request_params)
#	window_request.status = "Waiting"
#	if window_request.save!
#		@window_request_js = current_user.window_requests.last
#		respond_to do |format|
#			format.html { redirect_to @window_request_js }
#                        format.js  
#		end
#	else
#		redirect_to '/window_requests'
#	end
  end

  def apply
        window_request = WindowRequest.new
        window_request = current_user.window_requests.build(window_request_params)
        window_request.status = "Waiting"

        if window_request.save!
		message = Message.new
		message.user_id = current_user.id
		message.content = 'New Check-In Window Request: ' + window_request.username + ', ' + window_request.version + ', ' + window_request.time_range
		if message.save!
			ActionCable.server.broadcast 'room_channel', content:  message.content, username: User.where("id = ?", message.user_id).first.email, created_at: message.created_at
		end

                @window_request_js = current_user.window_requests.last
                respond_to do |format|
                        format.html { redirect_to '/window_requests' }
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
	window_request.time_range = params[:time_range]
        window_request.status = "Opened"
	if window_request.save!
	#open operation, broadcast and active job(command, job_finish_time)
		message = Message.new
		message.user_id = current_user.id
		message.content = 'Opened Check-In Window Request: ' + window_request.username + ', ' + window_request.version + ', ' + window_request.time_range
		if message.save!
			ActionCable.server.broadcast 'room_channel', content:  message.content, username: User.where("id = ?", message.user_id).first.email, created_at: message.created_at
		end
	@window_request_open_js = WindowRequest.new && @window_request_open_js = window_request
		respond_to do |format|
			format.html { redirect_to '/window_requests' }
			format.js  {}
		end
	end
#	mail_to_rd('qa@ansys.com', User.where("id = ?", message.user_id).first.email, message.content)
	window_request.open!(window_request)

  end

  def destroy
  end

  private
  	def window_request_params
		 params.require(:window_request).permit(:username, :version, :time_range, :comment)
	end
end
