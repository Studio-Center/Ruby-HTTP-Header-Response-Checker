require 'net/http'

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
        @redirects = Array.new()
        @responses = Array.new()
    end

    def reset
        # store redirects
        @redirects = Array.new()
        @responses = Array.new()
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

# set results file
SAVEFILE = "results.txt"
# set page list file name
FILENAME = "pages.txt"
# set domain string for replacement
REPLACE = "http://studiocenter.com/"
# set new domain string
NEWURL = "http://studiocenter.com/"

#clear output file
f = File.new(SAVEFILE, 'w')
f.truncate(0)
f.close

# open results file for writing
fw = File.new(SAVEFILE,'w')
# open link list
f = File.new(FILENAME,'r')
# init link check class
chklnk = LinkCheck.new();
# walk through link file
while line = f.gets

    newlink = line.sub REPLACE, NEWURL

    # reset instance variables
    chklnk::reset
    results = chklnk::fetch(newlink)
    
    redirects = ''
    if chklnk.redirects.count > 0
        redirects = chklnk.redirects.join(',')
        response = chklnk.responses.join(',')
    else
        redirects = ''
        response = results 
    end

    # write to output file
    results = "#{response} \t #{newlink} \t #{redirects} \n"
    fw.write(results)

end

# close results file
fw.close

# close link list file
f.close

puts "Redirects: #{chklnk.redcnt}"
puts "200 OK: #{chklnk.okcnt}"
puts "404 not found: #{chklnk.ntfcnt}"
puts "DONE!"
