class Settings
	attr_accessor :playmode
	def initialize
		@playmode = :normal	#play songs in order listed in the browser
		@dirs = []		#directories containing files
	end
end
