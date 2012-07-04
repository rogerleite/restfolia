module Restfolia::MediaTypes
  class Bypass

    def encode(value)
      value
    end

    def decode(value)
      value
    end

  end
end
