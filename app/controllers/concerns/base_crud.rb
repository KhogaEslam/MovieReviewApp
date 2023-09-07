module BaseCrud
  extend ActiveSupport::Concern

  included do
    before_action :set_resource, only: %i[show update destroy]
  end

  ## --------------------------- GET /{resource} ------------------------ ##
  def index
    data = {
      pagination: pagination(collection),
      index_key: collection.as_api_response(index_template, template_injector)
    }
    yield data if block_given?
    render_success(data: data, message: index_message)
  end

  ## ----------------------- GET /{resource}/:id ------------------------ ##
  def show
    data = {show_key => get_resource.as_api_response(show_template, template_injector)}
    yield data if block_given?
    render_success(data: data)
  end

  ## ----------------------- POST /{resource} --------------------------- ##
  def create
    resource = get_scope.new(resource_params)

    if resource.save
      data = {show_key => resource.as_api_response(show_template, template_injector)}
      yield data if block_given?
      render_created(data: data, message: created_message)
    else
      render_unprocessable_entity(message: resource.errors.full_messages.join(", "))
    end
  end

  ## ----------------------- PUT : /{resource}/:id----------------------- ##
  def update
    resource = get_resource

    if resource.update(resource_params)
      data = {show_key => resource.as_api_response(show_template, template_injector)}
      yield data if block_given?
      render_success(data: data, message: updated_message)
    else
      render_unprocessable_entity(message: resource.errors.full_messages.join(", "))
    end
  end

  ## ----------------------- # DELETE : /{resource}/:id ----------------- ##
  def destroy
    resource = get_resource

    if resource.destroy
      render_success(message: deleted_message, data: {resource_name.to_s => resource})
    else
      render_unprocessable_entity(message: resource.errors.full_messages.join(", "))
    end
  end

  private

  def resource_name
    @resource_name ||= controller_name.singularize
  end

  def resource_class
    @resource_class ||= resource_name.classify.constantize
  end

  def resource_params
    @resource_params ||= send("#{resource_name}_params")
  end

  def get_scope
    scope_name = "#{resource_name.pluralize}_scope"
    @scope ||= send(scope_name)
  end

  def set_resource(resource = nil)
    resource ||= get_scope.find(id_parameter)
    instance_variable_set("@#{resource_name}", resource)
  end

  def get_resource
    instance_variable_get("@#{resource_name}")
  end

  def collection
    @collection ||= build_collection
  end

  def build_collection(scope = nil)
    result = (scope || get_scope)
    result = apply_filter(result)
    result = apply_search(result)
    result = result.page(params[:page]).per(limit) if params[:page].present? && limit != "-1"
    result = result.order(order_params) if order_params.present?
    result
  end

  def limit
    params[:limit] || params[:rpp]
  end

  # override this methods in controller and return collection after filter
  def apply_search(result)
  end

  # Return order clause as string
  def order_params
    "#{controller_name}.id DESC"
  end

  # override this methods in controller and return collection after search
  def apply_filter(result)
  end

  def id_parameter
    params[:id]
  end

  def current_page
    # code here
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

  def template_injector
    {}
  end

  def index_key
    resource_name.to_s.pluralize.to_sym
  end

  def show_key
    resource_name.to_s.singularize.to_sym
  end

  def template_version
    params[:controller].split("/", 2).first
  end

  def show_template
    "#{template_version}_show".to_sym
  end

  def index_template
    "#{template_version}_index".to_sym
  end

  %W[created updated deleted].each do |attr|
    define_method "#{attr}_message" do
      I18n.t("resource.#{attr}", resource: human_resource_name)
    end
  end

  def human_resource_name
    resource_class.model_name.human
  end

  # Messages
  def index_message
  end
end
