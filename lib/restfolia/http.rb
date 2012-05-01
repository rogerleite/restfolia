module Restfolia

  # Public: Anything related to HTTP protocol, should go below this module.
  # Responsible to autoload the following modules:
  #  Behaviour - module responsable to handle HTTP response.
  #  Configuration - module to incorporate attributes like headers, cookies
  # ... etc.
  module HTTP
    autoload :Behaviour,     "restfolia/http/behaviour"
    autoload :Configuration, "restfolia/http/configuration"
    autoload :Request,       "restfolia/http/request"

    extend Behaviour
  end

end
