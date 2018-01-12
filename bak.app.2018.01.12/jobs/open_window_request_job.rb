class OpenWindowRequestJob < ApplicationJob
  queue_as :default

  def perform(window_request)
    @window_request = window_request
    if @window_request.status == "Waiting"
       @window_request.update_window_status("Unavailable")
       @window_request.save!
    end
  end
end
