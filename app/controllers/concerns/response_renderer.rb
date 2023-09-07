module ResponseRenderer

  extend ActiveSupport::Concern

  included {}

  module ClassMethods; end

  # Common method to render success response inside this module
  def render_succ(success: true, message: nil, data: nil, status_code: 200)
    render json: {success: success, message: message, data: data}, status: status_code
  end

  # Common method to render error response inside this module
  def render_error(message: I18n.t("errors.e_400"), status_code: 400)
    render json: {success: false, error: message, status_code: status_code}, status: status_code
  end

  # Handle Rails exceptions with custom JSON response
  def render_500_error(message: I18n.t("errors.e_500"))
    render_error message: message, status_code: 500
  end

  # Handle 400 errors with custom JSON response
  def render_bad_request(message: I18n.t("errors.e_400"))
    render_error message: message, status_code: 400
  end

  # Handle 422 errors with custom JSON response
  def render_unprocessable_entity(message: nil)
    render_error message: message, status_code: 422
  end

  # Handle 401 errors with custom JSON response
  def render_unauthorized(message: nil)
    render json: {success: false, error: message, status_code: 600}, status: 401
  end

  # Handle 404 errors with custom JSON response
  def render_not_found(message: I18n.t("errors.e_404"))
    render_error message: message, status_code: 404
  end

  # Handle 403 errors with custom JSON response
  def render_forbidden(message: nil)
    render_error message: message, status_code: 403
  end

  # Common method to render success response
  def render_success(message: nil, data: nil)
    render_succ success: true, message: message, data: data
  end

  # Common method to render empty response (no data available in db)
  def render_empty(root: "data", message: nil)
    data = {:count => 0, root.to_sym => []}
    render_succ success: true, message: message, data: data
  end

  # Common method to render create new resource
  def render_created(message: nil, data: nil)
    render_succ message: message, data: data, status_code: 201
  end

  # Render report from service/sheet classes with different formats
  def render_report(service_object: nil, sheet_class: nil, formats: [:json, :pdf, :xls],
    pdf_template: "reports/report_template", pdf_options: {})

    respond_to do |format|
      if formats.include? :json
        format.json {
          # render_success data: {report: service_object.marshal_dump}
        }
      end

      if formats.include? :pdf
        format.pdf do
          # render_pdf service_object: service_object, template: pdf_template
        end
      end

      if formats.include? :xls
        format.xls do
          # render_excel service_object: service_object, sheet_class: sheet_class
        end
      end
    end
  end

  # # Render reports pdf version
  # def render_pdf(service_object: nil, template: "v1/reports/report_template",
  #   pdf_options: {}, layout: "pdf.pdf.erb", assigns: {})
  #
  #   assigns[:report] = service_object
  #
  #   pdf_string = PdfBuilder.build(
  #     service_object,
  #     template,
  #     assigns,
  #     layout,
  #     pdf_options
  #   )
  #
  #   # send pdf report
  #   send_data pdf_string, filename: service_object.title + ".pdf", type: "application/pdf", disposition: "inline"
  # end
  #
  # # Render reports excel version
  # def render_excel service_object: nil, sheet_class: nil
  #   book_factory = ExcelWorkBookFactory.new
  #   sheet_class.new(book_factory, service_object).build.apply_format
  #   send_data book_factory.export, filename: service_object.title + ".xls",
  #     type: "application/xls", disposition: "inline"
  # end

end
