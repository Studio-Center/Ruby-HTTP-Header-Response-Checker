# default constants
# set results file
SAVEFILE = "results.txt"
# set page list file name
FILENAME = "pages.txt"
# set domain string for replacement
REPLACE = "http://studiocenter.com/"
# set new domain string
NEWURL = "http://studiocenter.com/"

#link check class
class LinkCheck
    # accessors
    attr_reader :redirects
    attr_reader :responses

    # init counters
    def initialize
        @@redcnt = 0
        @@ntfcnt = 0
        @@okcnt = 0

        # store redirects
        @redirects = Array.new
        @responses = Array.new
    end

    def reset
        # store redirects
        @redirects = Array.new
        @responses = Array.new
    end

    # set class variable accessors
    def redcnt
        @@redcnt
    end

    def ntfcnt
        @@ntfcnt
    end

    def okcnt
        @@okcnt
    end

    # check link for results
    def fetch(uri, limit = 10)

        uri = URI(uri)

        response = Net::HTTP.get_response(uri)

        case response
        when Net::HTTPSuccess then
            @@okcnt += 1
            response.code
        when Net::HTTPRedirection then
            @@redcnt += 1
            location = response['location']
            warn "#{uri} redirected to #{location}"
            @redirects << location
            @responses << response.code
            fetch(location, limit - 1)
        else
            @@ntfcnt += 1
            response.code
        end

    end
end
