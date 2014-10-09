#!/usr/bin/ruby
# This Ruby script will trash your files or directories to the normal Trash Bin.
# You can use this to override the `rm` command just for your own safety.

# TODO:
# * support Chinese file/directory names
# * Never allow to run `rm -rf /` or similiar dangerous commands
# * detect same name in trash bin
# * raise permission errors
# * allow to trash Windows/Remote files/directories

class TrashBin

	VERSION=1.0

	def initialize(argv=$*)
		@argv = argv
	end

	def trash
		trash_args = []
		logname = `logname`.gsub(/\n/,"")

		@argv.each do |arg|
			unless arg.include?"-" then
				trash_args << arg
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

		trash_args.each do |trash_arg|
			require "fileutils"
			# Move the actual file or directory
			FileUtils.mv("#{trash_arg}","/home/#{logname}/.local/share/Trash/files/")

			file = trash_arg.gsub(/.*\//,'')

			@DeleteDate = Time.now().strftime("%Y-%m-%dT%H:%M:%S").to_s
			
			# Create the .trashinfo file
			info_file = File.open("/home/#{logname}/.local/share/Trash/info/#{file}.trashinfo","w+")
			info_file.puts("[Trash Info]")
			info_file.puts("Path=#{trash_arg}")
			info_file.puts("DeletionDate=#{@DeleteDate}")
			info_file.close
			
		end
	end

end

hash1=TrashBin.new()
hash1.trash
