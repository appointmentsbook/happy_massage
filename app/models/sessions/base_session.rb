module Sessions
  class BaseSession
    def initialize(session)
      @session = session
    end

    def login
      session[:cas_user]
    end

    def name
      extra_attributes[:cn]
    end

    def email
      extra_attributes[:email]
    end

    private

    attr_reader :session

    def extra_attributes
      @extra_attributes ||= session[:cas_extra_attributes]
    end
  end
end
