module Kaltura
  class Session < DelegateClass(Hashie::Mash)
    extend ClientResource

    SESSION_TYPE = 2 # don't default to Admin API, fer cryin' out loud!
    # SESSION_TYPE = 0
    EXPIRES = 3600 * 24 * 365 # one year

    @@kaltura_session ||= nil

    def self.start
      _clear_kaltura_session

      fetched_response = fetch('session', 'start', _session_request_options).first

      _assign_kaltura_session(fetched_response)

      fetched_response
    end

    def self.kaltura_session
      @@kaltura_session
    end

    protected

    def self._session_request_options
      { :partnerId => Kaltura.config.partner_id, :secret => Kaltura.config.administrator_secret,
        :type => SESSION_TYPE, :expiry => EXPIRES }
    end

    def self._clear_kaltura_session
      @@kaltura_session = nil
    end

    def self._assign_kaltura_session(response)
      unless response.result.respond_to? :error
        @@kaltura_session = response.result
      end
    end
  end
end
