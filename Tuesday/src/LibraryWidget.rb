require 'MusicClasses.rb'

class LibraryWidget < Qt::TableWidget
    def initialize(parent = 0)
	super(0, 4)
	@current = -1
	@albums = Array.new
	@songs = Array.new
	hheaders = Array.new
	hheaders << "#" << "Track" << "Artist" << "Album"
	setHorizontalHeaderLabels(hheaders)
	@vheaders = Array.new
	@prev = Array.new
	setVerticalHeaderLabels(@vheaders)
	setShowGrid(false)
    end #initialize
    
    def append(metaData)
	song = Song.new(metaData)
	setRowCount(rowCount + 1)
	track = Qt::TableWidgetItem.new(song.track)
	setItem(rowCount-1, 0, track)
	title = Qt::TableWidgetItem.new(song.title)
	setItem(rowCount-1, 1, title)
	artist = Qt::TableWidgetItem.new(song.artist)
	setItem(rowCount-1, 2, artist)
	album = Qt::TableWidgetItem.new(song.album)
	setItem(rowCount-1, 3, album)
	@songs << song
	@vheaders << ""
	setVerticalHeaderLabels(@vheaders)
    end #append(metaData)
        
    def getNext(playmode)
	if playmode == :normal #play tracks in normal order
	    unless @current < 0
		@prev << [@current, @songs[@current]]
	    end
	
	    if @current < 0
		@current = 0
	    elsif @current >= (@songs.size() -1)
		@current = 0
	    else
		@current = @current + 1
	    end
	elsif playmode == :album #play an album to completion, then skip to a random album
		#implement this shit later
	elsif playmode == :random #play tracks in a completely random order
	    roll = rand(@songs.size())
	    unless @songs.size() == 1
		#avoid repeating the same track,
		#unless there is only one track,
		#then we have to repeat
		while roll == @current
		    roll = rand(@songs.size())
		end
	    end
	    @current = roll
	end
	return @songs[@current]
    end #getNext
    
    def getPrev()	
	@current = @prev.last[0]
	return @prev.pop[1]
    end #getPrev
    
    def prev?()
	return (!@prev.empty?)
    end #prev?
    
    def [] (index)
	@prev << [@current, @songs[@current]]
	@current = index
	return @songs[index]
    end #[]
end