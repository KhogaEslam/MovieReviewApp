class CustomErrors::MissingParams < StandardError
  attr_reader :names

  def initialize(missing_param_names)
    @names = missing_param_names
  end
end
