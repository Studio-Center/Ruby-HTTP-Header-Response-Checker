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
            results = "#{response}\t#{newlink}\t#{redirects}\n"
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
