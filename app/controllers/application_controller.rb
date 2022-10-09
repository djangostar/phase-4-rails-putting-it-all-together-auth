class ApplicationController < ActionController::API
  include ActionController::Cookies

  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record
  
  before_action :authorize

  private

  def authorize
    @current_user = User.find_by(id: session[:user_id])
    return render json: { errors: ["Not logged in"] }, status: :unauthorized unless @current_user
  end
  
  def invalid_record(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end

end
