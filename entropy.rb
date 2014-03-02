#!/usr/bin/env ruby

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
end

puts password.join
