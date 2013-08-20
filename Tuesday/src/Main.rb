#!/usr/bin/env ruby
$:.unshift File.dirname($0)

require 'korundum4'
require 'MainWindow.rb'
require 'Settings.rb'

about = KDE::AboutData.new("Tuesday", nil, KDE::ki18n("Tuesday"), "0.1", KDE::ki18n("It's awesome yo"),
                           KDE::AboutData::License_LGPL, KDE::ki18n("(c) 2010 Wyatt Gosling"),
                           KDE::LocalizedString.new, nil, "yatt12@gmail.com")
about.addAuthor(KDE::ki18n("Wyatt Gosling"), KDE::LocalizedString.new, "yatt12@gmail.com")
about.setProgramIconName('oxygen')
KDE::CmdLineArgs.init(ARGV, about)

app = KDE::Application.new
#app.setApplicationName("Tuesday")
#load main window here
settings = Settings.new
window = MainWindow.new(settings)
window.show
app.exec()