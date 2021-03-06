require 'blinkr/error'

module Blinkr
  module Extensions
    class Resources
      def initialize(config)
        @config = config
      end

      def collect(page)
        page.resource_errors.each do |error|
          start = error['errorString'].rindex('server replied: ')
          message = error['errorString'].slice(start.nil? ? 0 : start + 16, error['errorString'].length) unless error['errorString'].nil?
          code = error['errorCode'].nil? ? nil : error['errorCode'].to_i
          page.errors << Blinkr::Error.new(severity: 'danger', category: 'Resources missing',
                                           type: 'Resource loading error', title: error['url'],
                                           code: code, message: message, icon: 'fa-file-image-o') if @config.warn_resource_errors
        end
      end
    end
  end
end
