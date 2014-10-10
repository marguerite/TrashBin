#!/usr/bin/ruby
# This Ruby script will trash your files or directories to the normal Trash Bin.
# You can use this to override the `rm` command just for your own safety.

# TODO:
# * Never allow to run `rm -rf /` or similiar dangerous commands
# * detect same name in trash bin
# * raise permission errors
# * allow to trash Windows/Remote files/directories
# * support "*" in names 
# * can delete file without prefix path

VERSION = 1.0
$trash_candidates = []
$trash_args = []

$*.each do |arg|
	unless arg[0] == "-" then
		$trash_candidates << arg
	end
	
	if arg[0] == "-" then
		$trash_args << arg
	end

	case arg
	when "-v","--version" then
		puts VERSION
	when "-h","--help" then
		puts  "This is a Trashbin Program written in Ruby.\n"\
			"Options:\n"\
			"-v, --version\tPrint version number and quit.\n"\
			"-h, --help\tPrint this help.\n"\
			"-f, --force, --i-know-what-i-am-doing\t"\
			"Really destroy the named FILE or DIRECTORY without regret, same as `rm`.\n"
			## I should make backups and don't let those idiots know,
			## Silently destroy those needless files after a hard-to-find interval
		puts  "-d, --disable-protection, --i-am-not-a-child, --i-am-an-adult\t"\
			"Allow to destroy well known system directories.\n"
			## Of course w/ backups
		puts  "-o, --override-rm\t"\
			"Promote me as the new `rm`.\n"
	when "--eastern-egg" then
		puts "TrashBin aims to be the 3rd kernel!"
	end
end

class TrashBin

	def initialize(arg=$trash_candidates)
		@trashes = arg
	end

	def trash
		logname = `logname`.gsub(/\n/,"")

		@trashes.each do |trash|
			require "fileutils"
			require "uri"

			# Move the actual file or directory
			FileUtils.mv(trash,"/home/#{logname}/.local/share/Trash/files/")

			file = trash.gsub(/.*\//,'')
			encoded_path = URI.escape(trash)
			@DeleteDate = Time.now().strftime("%Y-%m-%dT%H:%M:%S").to_s
			
			# Create the .trashinfo file
			info_file = File.open("/home/#{logname}/.local/share/Trash/info/#{file}.trashinfo","w+")
			info_file.puts("[Trash Info]")
			info_file.puts("Path=#{encoded_path}")
			info_file.puts("DeletionDate=#{@DeleteDate}")
			info_file.close
			
		end
	end

end

TrashBin.new().trash
