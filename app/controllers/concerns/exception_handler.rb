module ExceptionHandler
  extend ActiveSupport::Concern

  module ClassMethods; end

  # concerns/response_renderer
  include ResponseRenderer

  included do

    # Handle Rails exceptions with custom JSON response
    # rescue_from Exception do
    #   render_500_error
    # end

    # Handle Rails 404 Not Found error with custom JSON response
    rescue_from ActiveRecord::RecordNotFound do
      render_not_found
    end

    # Handle Rails Bad Request error with custom JSON response
    rescue_from ActionController::ParameterMissing do
      render_bad_request
    end

    # Handle Foreign key violation error with custom JSON response
    rescue_from ActiveRecord::InvalidForeignKey do
      render_not_found message: I18n.t("errors.e_fk")
    end

    # Handle Missing required params error with custom JSON response
    rescue_from CustomErrors::MissingParams do |e|
      render_bad_request message: I18n.t("params.missing") + e.names.join(", ")
    end

  end

end
