class Album
    def initialize(artist)
	#it is perfectally allowable for the album artist to differ from the track artists
	@artist = artist
	#songs will be jammed in the array based on track number.
	@songs = Array.new
    end
    
    def add(song)
	#for right now, ignore the fact that a song could already exist at the spot
	@songs[song.track] = song
    end
    
    def each(&block)
	@songs.each block
    end
    
    def remove(song)
	if @songs[song.track].fileName == song.fileName
	    @songs[song.track] = nil
	end
    end
    
    def <<(song)
	self.add(song)
    end
end

class Song
    attr_accessor :title, :artist, :album, :date, :genre, :track, :comment, :fileName
    def initialize(meta)
	@title = meta.metaData('TITLE').to_s
	if @title == ""
	    @title = meta.currentSource.fileName
	end
	@artist = meta.metaData('ARTIST').to_s
	@album = meta.metaData('ALBUM').to_s
	@date = meta.metaData('DATE').to_s
	@genre = meta.metaData('GENRE').to_s
	@track = meta.metaData('TRACKNUMBER').to_s
	@comment = meta.metaData('DESCRIPTION').to_s
	@fileName = meta.currentSource.fileName
    end
end