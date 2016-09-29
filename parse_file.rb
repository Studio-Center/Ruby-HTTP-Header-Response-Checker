# process urls list
class ParseFile

    def initialize

        # set save file location
        puts "Where would you like to save your results? (Default location: #{SAVEFILE})"
        @savefile = gets.chomp

        puts "What file stores your list of links? (Default location: #{FILENAME})"
        @filename = gets.chomp

        puts "Which URL do you want to replace within your URL list? (Default: #{REPLACE})"
        @replace = gets.chomp

        puts "What replacement URL would you like to use? (Default: #{NEWURL})"
        @newurl = gets.chomp

        # assign defult overrides if empty values were assigned
        @savefile = SAVEFILE if @savefile == ''
        @filename = FILENAME if @filename == ''
        @replace = REPLACE if @replace == ''
        @newurl = NEWURL if @newurl == ''

    end

    def clear_file
        #clear output file
        f = File.new(@savefile, 'w')
        f.truncate(0)
        f.close
    end

    def parse_list

        clear_file

        # open results file for writing
        fw = File.new(@savefile,'w')
        # open link list
        f = File.new(@filename,'r')
        # init link check class
        chklnk = LinkCheck.new;
        # walk through link file
        while line = f.gets

            newlink = line.sub @replace, @newurl
            newlink.strip!

            # reset instance variables
            chklnk::reset

            # clean up URL before submission
            if newlink !=~ /^htt(p|ps):/
              if newlink[0,1] == "/"
                newlink = 'http:/' + newlink
              elsif newlink[0,2] == "//"
                newlink = 'http:' + newlink
              else
                newlink = 'http://' + newlink
              end
            end

            # store link results
            results = chklnk::fetch(newlink)

            # format results for presentation
            resTime = results[:resTime]
            results = results[:res]

            redirects = ''
            if chklnk.redirects.count > 0
                redirects = chklnk.redirects.join(',')
                response = chklnk.responses.join(',')
            else
                redirects = ''
                response = results
            end

            # write to output file
            results = "#{response}\t#{newlink}\t#{redirects}\t#{resTime}\n"
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

    end
end
