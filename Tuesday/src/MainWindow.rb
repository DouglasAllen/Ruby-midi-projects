require 'phonon'
require 'LibraryWidget.rb'

class MainWindow < Qt::Widget
    slots  "aboutToFinish()", "config()", "metaStateChanged(Phonon::State, Phonon::State)", "nextClicked()", "openFiles()",
	    "playClicked()", "prevClicked()", "stateChanged(Phonon::State, Phonon::State)", "tableDoubleClicked(int, int)"
	    
    def initialize(settings)
	super()
	
	@settings = settings
	
	@audioOutput = Phonon::AudioOutput.new(Phonon::MusicCategory, self)
	@mediaObject = Phonon::MediaObject.new(self)
	@metaResolver = Phonon::MediaObject.new(self)
	
	@mediaObject.setTickInterval(1000)
	Phonon::createPath(@mediaObject, @audioOutput)
	connect(@mediaObject, SIGNAL('stateChanged(Phonon::State, Phonon::State)'),
	        self, SLOT('stateChanged(Phonon::State, Phonon::State)'))
	connect(@mediaObject, SIGNAL('aboutToFinish()'), self, SLOT('aboutToFinish()'))
	connect(@metaResolver, SIGNAL('stateChanged(Phonon::State, Phonon::State)'),
	        self, SLOT('metaStateChanged(Phonon::State, Phonon::State)'))
	
	setupUI()
    end #initialize
    
    def aboutToFinish()
	@mediaObject.enqueue(Phonon::MediaSource.new(@musicTable.getNext(@settings.playmode).fileName))
    end #aboutToFinish
    
    def config()
	if @config == true
		@playWidgets.each { |widget| widget.show }
		@configWidgets.each { |widget| widget.hide }
		@config = false
	elsif @config == false
		@playWidgets.each { |widget| widget.hide }
		@configWidgets.each { |widget| widget.show }
		@config = true
	end
    end
    
    def metaStateChanged(newState, oldState)
	if newState == Phonon::ErrorState
	    #Qt::MessageBox.warning(self, tr("Error opening files"), @metaResolver.errorString)
	    return
	end
	
	if newState != Phonon::StoppedState && newState != Phonon::PausedState
	    return
	end
		
	@musicTable.append(@metaResolver)
    end #metaStateChanged
    
    def nextClicked()
	@mediaObject.stop
	@mediaObject.setCurrentSource(Phonon::MediaSource.new(@musicTable.getNext(@settings.playmode).fileName))
	@mediaObject.play
    end #nextClicked
    
    def openFiles()
	dir = Qt::FileDialog.getExistingDirectory(self, tr("Select a Music Folder"),
                    Qt::DesktopServices.storageLocation(Qt::DesktopServices.MusicLocation))
	#if fileNames == ""
	#    return
	#end
	qdir = Qt::Dir.new(dir)
	puts qdir.entryList.inspect
	qdir.entryList.each { |fileName|
		puts fileName
		@metaResolver.setCurrentSource(Phonon::MediaSource.new(fileName)) }
    end #openFiles
    
    def playClicked()
	if @mediaObject.state == Phonon::StoppedState
	    @mediaObject.play
	elsif @mediaObject.state == Phonon::LoadingState
	    @mediaObject.currentSource = Phonon::MediaSource.new(@musicTable.getNext(@settings.playmode).fileName)
	    @mediaObject.play
	elsif @mediaObject.state == Phonon::PausedState
	    @mediaObject.play
	elsif @mediaObject.state == Phonon::PlayingState
	    @mediaObject.pause
	end
    end #playClicked
    
    def prevClicked()
	if @musicTable.prev? == true
	    @mediaObject.stop
	    @mediaObject.setCurrentSource(Phonon::MediaSource.new(@musicTable.getPrev.fileName))
	    @mediaObject.play
	end
    end #prevClicked
    
    def setupUI
	   
	############ Playback Widgets #############
	
	@musicTable = LibraryWidget.new
	connect(@musicTable, SIGNAL('cellDoubleClicked(int, int)'), self, SLOT('tableDoubleClicked(int, int)'))
	prevButton = Qt::PushButton.new
	prevButton.setIcon(Qt::Icon.fromTheme("media-skip-backward"))
	prevButton.setFlat(true)
	prevButton.setIconSize(Qt::Size.new(22, 22))
	prevButton.setMaximumSize(28, 28)
	connect(prevButton, SIGNAL('clicked()'), self, SLOT('prevClicked()'))
	#playButton also doubles as the pause button
	@playButton = Qt::PushButton.new
	@playButton.setIcon(Qt::Icon.fromTheme("media-playback-start"))
	@playButton.setFlat(true)
	@playButton.setIconSize(Qt::Size.new(32, 32))
	@playButton.setMaximumSize(38, 38)
	connect(@playButton, SIGNAL('clicked()'), self, SLOT('playClicked()'))
	nextButton = Qt::PushButton.new
	nextButton.setIcon(Qt::Icon.fromTheme("media-skip-forward"))
	nextButton.setFlat(true)
	nextButton.setIconSize(Qt::Size.new(22, 22))
	nextButton.setMaximumSize(28, 28)
	connect(nextButton, SIGNAL('clicked()'), self, SLOT('nextClicked()'))
	
	slider = Phonon::SeekSlider.new	
	slider.setMediaObject(@mediaObject)
	volume = Phonon::VolumeSlider.new
	volume.setAudioOutput(@audioOutput)
	
	@playWidgets = [@musicTable]
	
	############### Config Widgets ################
	
	# dis/enables random playback mode
	randomTick = Qt::CheckBox.new("Random")
	if @settings.playmode == :normal
		randomTick.setCheckState(Qt::Unchecked)
	else @settings.playmode == :randomTick
		randomTick.setCheckState(Qt::Checked)
	end
	
	# folder selection dialog
	dirLabel = Qt::Label.new("Directories to import music files from:")
	addButton = Qt::PushButton.new("Add...")
	connect(addButton, SIGNAL('clicked()'), self, SLOT('openFiles()'));
	removeButton = Qt::PushButton.new("Remove")
	dirList = Qt::ListView.new
	filesLayout = Qt::GridLayout.new
	filesLayout.addWidget(dirLabel, 0, 0)
	filesLayout.addWidget(dirList, 1, 0, 3, 1)
	filesLayout.addWidget(addButton, 1, 1)
	filesLayout.addWidget(removeButton, 2, 1)
	
	@configWidgets = [randomTick, dirLabel, addButton, removeButton, dirList]
	
	############### Layout ##############
	configButton = Qt::PushButton.new
	configButton.setIcon(Qt::Icon.fromTheme("preferences-other"))
	configButton.setIconSize(Qt::Size.new(22, 22))
	configButton.setMaximumSize(28, 28)
	connect(configButton, SIGNAL('clicked()'), self, SLOT('config()'))
	
	hlayout = Qt::HBoxLayout.new
	hlayout.addWidget(prevButton)
	hlayout.addWidget(@playButton)
	hlayout.addWidget(nextButton)
	hlayout.addWidget(slider)
	hlayout.addWidget(volume)
	hlayout.addWidget(configButton)
	hlayout.setStretchFactor(slider, 1)
	hlayout.setStretchFactor(volume, 0)
	vlayout = Qt::VBoxLayout.new
	vlayout.addWidget(@musicTable)
	vlayout.addLayout(filesLayout)
	vlayout.addWidget(randomTick)
	vlayout.addLayout(hlayout)
	vlayout.setStretchFactor(@musicTable, 1)
	vlayout.setStretchFactor(hlayout, 0)
	self.setLayout(vlayout)
	self.resize(500, 300)
	self.setWindowTitle("Tuesday")
	
	@configWidgets.each { |widget| widget.hide }
	@config = false
    end #setupUI
    
    def stateChanged(newState, oldState)
	if newState == Phonon::PlayingState
	    @playButton.setIcon(Qt::Icon.fromTheme("media-playback-pause"))
	elsif newState == Phonon::PausedState
	    @playButton.setIcon(Qt::Icon.fromTheme("media-playback-start"))
	elsif newState == Phonon::StoppedState
	    @playButton.setIcon(Qt::Icon.fromTheme("media-playback-start"))
	end
    end #stateChanged
    
    def tableDoubleClicked(row, column)
	@mediaObject.stop
	@mediaObject.setCurrentSource(Phonon::MediaSource.new(@musicTable[row]))
	@mediaObject.play
    end #tableDoubleClicked(row, column)
end
