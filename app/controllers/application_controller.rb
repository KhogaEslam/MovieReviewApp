class ApplicationController < ActionController::API
  # Concerns/response_renderer
  include ResponseRenderer
  include ExceptionHandler
  include ActionController::MimeResponds
  include ActionController::ImplicitRender
  include AuthenticateUser

  include BaseCrud

  attr_accessor :current_user

  before_action :set_locale, :set_paper_trail_whodunnit #, :assert_privilege

  protected

  def assert_privilege

  end

  def assert_permission(permissions)

  end

  def has_permission(permissions)
    if current_user # ...
      true
    else
      false
    end
  end

  # This method to inform user if there were missing required parameters
  def check_required_params(params, required_params)
    missing_params = []
    required_params.each do |p|
      missing_params << p if params[p].blank?
    end

    raise CustomErrors::MissingParams.new(missing_params) if missing_params.any?
  end

  # This method will set the locale to the one passed in the querystring to 'locale' param
  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale] || request.headers["locale"]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  def current_page
    params[:page] || 1
  end

  def record_per_page
    params[:rpp] || params[:limit] || 20
  end

  def apply_search(arl_collection)
    params[:search].present? ? arl_collection.search(params[:search]) : arl_collection
  end

  def pagination(arl_collection)

    # request to return entire records without pagination
    return {} if params[:page] == "0"

    arl_collection = arl_collection.page(current_page).per(record_per_page)

    {
      current_page: arl_collection&.current_page || 1,
      next_page: arl_collection&.next_page,
      previous_page: arl_collection&.prev_page,
      total_pages: arl_collection&.total_pages || 1,
      per_page: arl_collection&.limit_value,
      total_entries: arl_collection&.total_count
    }
  end

  def apply_pagination(arl_collection)
    arl_collection.page(params[:page]).per(params[:rpp])
  end

  def limit
    params[:limit] || params[:rpp]
  end
end
