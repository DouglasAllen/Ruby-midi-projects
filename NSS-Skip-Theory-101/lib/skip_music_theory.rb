#! /usr/bin/env ruby
puts

puts "Welcome to Skip Music Theory 101: your first step down the path to musical
enlightenment."

puts

puts "This program intends to give you an understanding of Western Music Theory
by teaching you about basic chords and scales. We will focus on the major and
minor chords as well as major and minor scales. "

puts

puts "There are two modes to this program: learning mode and quiz mode. In
learning mode, you can enter a chord or scale and receive its component notes.
In quiz mode, you will be asked to return the component notes to a given scale
or chord. As you answer questions correctly in quiz mode, you will move down the
path of enlightenment. Answer 48 questions correctly and you will have reached
the end of the first part of an infinite journey."

puts

puts"Important note: it is important to format your input correctly. Major and
minor are represented as 'maj' and 'min' respectively. For clarity they must go
directly next to the chords they describe: 'Fmaj' is good, 'F maj' is bad.
Sharps are '#' and flats are 'b' and they similarly must be adjacent to the note
they modify. Notes in chords and scales must have a space in between them for
clarity: cmaj is C E G -- not CEG. Lastly, all naturals use sharps and sharps
use sharps (e.g. cmin = c d# g). Flats use flats"

puts

puts "You can skip this message in the future by simply typing 'ruby
learning.rb' or 'ruby quiz.rb' into your console."

puts

puts "You can start your learning by typing learning or you can begin the quiz
section and the path to enlightenment by typing quiz."

puts

initial_answer = gets.downcase.chomp
if initial_answer =~ /learning/
  require_relative 'learning' if File.exist?("learning.rb")
  puts "something went terribly wrong with your learning.rb file."
elsif initial_answer =~ /quiz/
  require_relative 'quiz' if File.exist?("quiz.rb")
  puts "something went terribly wrong with your quiz.rb file."
else
  puts "I'm sorry, but that made no sense to me. Please run the program again."
end
