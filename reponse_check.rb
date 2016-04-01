require 'net/http'
require_relative 'link_check'
require_relative 'parse_file'

proc_file = ParseFile.new
proc_file::parse_list
