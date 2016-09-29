# default constants
# set results file
SAVEFILE = "results.tsv"
# set page list file name
FILENAME = "pages.csv"
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

        begin
          uri = URI(uri)

          t1 = Time.now
          response = Net::HTTP.get_response(uri)
          t2 = Time.now
          delta = t2 - t1

          case response
          when Net::HTTPSuccess then
              @@okcnt += 1
              {res: response.code, resTime: delta}
          when Net::HTTPRedirection then
              @@redcnt += 1
              location = response['location']
              warn "#{uri} redirected to #{location}"
              @redirects << location
              @responses << response.code
              fetch(location, limit - 1)
          else
              @@ntfcnt += 1
              {res: response.code, resTime: delta}
          end
        rescue
          {res: 408, resTime: 0}
        end

    end
end
