#!/usr/bin/env ruby

# Copyright (c) 2007, Philip Dillon-Thiselton
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#    * Neither the name of Arch Linux nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# define the various arrays we use
a = ('a'..'z').to_a
v = %w[a e i o u]
c = a - v
aU = ('A'..'Z').to_a

n = %w[1 2 3 4 5 6 7 8 9 0]
#non_number_array = %w[! " £ $ % ^ & * ( )]
na = %w[| \\ < , > . ? / : ; @ ' ~ # { [ } ] - _ + = \  ! " £ $ % ^ & * ( )]

# This starts as everything...and ends up as what's left
x = a + n + na + aU

class Bignum
  def log2
    Math::log(self)/Math::log(2)    
  end
end

class Fixnum
  def log2
    Math::log(self)/Math::log(2)    
  end
end

def get_char input_array, progress_array
  target = rand(input_array.length)
  progress_array.push input_array[target]
end

def arg_check? argv
  if argv[0..1] != '--'
    return 'integer'
  elsif argv[0..4] == '--no-'
    return 'negative'
  elsif argv[0..1] == '--'
    return 'positive'
  else
    puts "Invalid arguement: " + argv
  end
end

def shuffle start_array, shuffle_array
  if start_array == []
    return shuffle_array
  end
  unshuffle_array = []
  target = rand(start_array.length)
  shuffle_array.push start_array[target]
  start_array[target] = nil
  start_array.each do |item|
    if item != nil
      unshuffle_array.push item
    end
  end
  shuffle unshuffle_array, shuffle_array
end

#create some vars
password = []
pass_crib = []
pass_crib_guide = []
pass_length = 0
entropy = 0

# process args
if ARGV.length > 1
  ARGV.each do |arg|
    if arg == '--environ' then
      puts 'You can use other options with --environ'
      exit
    end
  end
end

# now the meat and potatoes
if ARGV[0] == '--environ'
  pass_crib = [c,v,c,c,v,c,n,n]
else
  ARGV.each_with_index do |arg,index|
    if arg_check?(arg) == 'positive' then
      if index+2 <= ARGV.length then
        if arg_check?(ARGV[index+1]) == 'integer' then
          if arg[2,arg.length] == 'caps' then
            ARGV[index+1].to_i.times do
              pass_crib_guide.push 'aU'
              x -= aU
            end
          elsif arg[2,arg.length] == 'non-alpha' then
            ARGV[index+1].to_i.times do
              pass_crib_guide.push 'na'
              x -= na
            end
          elsif arg[2,arg.length] == 'num' then
            ARGV[index+1].to_i.times do
              pass_crib_guide.push 'n'
              x -= n
            end
          elsif arg[2,arg.length] == 'alpha' then
            ARGV[index+1].to_i.times do
              pass_crib_guide.push 'a'
              x -= a
            end
          elsif arg[2,arg.length] == 'random' then
            ARGV[index+1].to_i.times do
              pass_crib_guide.push 'x'
            end
          end
        else
          puts 'No arg supplied for ' + arg + '!'
          exit
        end
      else
        puts 'No arg supplied for ' + arg + '!'
        exit
      end
    elsif arg_check?(arg) == 'negative' then
      if arg[5,arg.length] == 'caps' then
        x -= aU
      elsif arg[5,arg.length] == 'non-alpha' then
        x -= na
      elsif arg[5,arg.length] == 'num' then
        x -= n
      end
    elsif arg_check?(arg) == 'integer' then
      if index+1.to_i == ARGV.length then
        pass_length = arg.to_i
      end
    end
  end

  pass_crib_guide.each do |array|
    if array == 'x' then
      pass_crib.push x
    elsif array == 'c' then
      pass_crib.push c
    elsif array == 'v' then
      pass_crib.push v
    elsif array == 'a' then
      pass_crib.push a
    elsif array == 'aU' then
      pass_crib.push aU
    elsif array == 'na' then
      pass_crib.push na
    elsif array == 'n' then
      pass_crib.push n
    end
  end  
  
  if pass_crib.length != pass_length then
    (pass_length-pass_crib.length).times do
      pass_crib.push x
      #pass_crib_guide.push 'x'
    end
    pass_crib = shuffle(pass_crib,[])
  end 
  #puts x.join(',')
end

pass_crib.each do |array|
  get_char array, password
  entropy += array.length.log2
end

puts password.join
puts 'Entropy: ' + ("%5.2f" % (entropy.to_s))
