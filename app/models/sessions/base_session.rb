module Sessions
  class BaseSession
    attr_reader :session

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

    def extra_attributes
      @extra_attributes ||= begin
        if session[:cas_extra_attributes].present?
          session[:cas_extra_attributes].symbolize_keys
        end
      end
    end
  end
end
