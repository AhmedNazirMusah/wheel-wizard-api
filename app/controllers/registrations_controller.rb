class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)

    if resource.save
      render json: { message: 'Sign up successful' }, status: :created
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::StatementInvalid => e
    Rails.logger.error("Registration failed: #{e.message}")
    render json: { error: 'Registration failed due to a server configuration issue' }, status: :internal_server_error
  rescue StandardError => e
    Rails.logger.error("Unexpected registration failure: #{e.class} - #{e.message}")
    render json: { error: 'Registration failed' }, status: :internal_server_error
  end
end
