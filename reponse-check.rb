require 'net/http'

# set results file
SAVEFILE = "results.txt"
# set page list file name
FILENAME = "pages.txt"
# set domain string for replacement
REPLACE = "http://virginiabeachwebdevelopment.com/"
# set new domain string
NEWURL = "http://virginiabeachwebdevelopment.com/"

#clear output file
f = File.new(SAVEFILE, 'w')
f.truncate(0)
f.close

# init counters
redcnt = 0
ntfcnt = 0
okcnt = 0

# open results file for writing
fw = File.new(SAVEFILE,'w')
# open link list
f = File.new(FILENAME,'r')
# walk through link file
while line = f.gets

    newlink = URI(line.sub REPLACE, NEWURL)

    # get header response
    res = Net::HTTP.get_response(newlink)
    # gather response code
    response = res.code.to_i
    
    case response
    # record redirected pages
    when 301 then
    when 302 then
        newpage = '' # will be added shortly
        redcnt += 1
    # record missing pages
    when 404 then
        ntfcnt += 1
    # record found pages
    when 200 then
        okcnt += 1
    end
    
    # write to output file
    results = "#{response} \t #{newlink} \t #{newpage} \n"
    fw.write(results)
end

# close results file
fw.close
# close link list file
f.close

puts "Redirects: #{redcnt}"
puts "200 OK: #{okcnt}"
puts "404 not found: #{ntfcnt}"
puts "DONE!"
