#!/usr/bin/env ruby

options = {
  count: 10
}

lines = `ps -eo pid --no-headers`.split("\n")
pid2swap = {}

puts "Swap space\tPID\tProcess"
puts "==========\t=====\t======="

lines.each do |line|
  swap_use = `grep VmSwap /proc/#{line}/status 2>/dev/null`
  swap_only = swap_use.split("\t")
  # if !line.match(//proc/(\d\+)/smaps:Swap:\s*(\d\+) kB/)
  #   next
  # end
  # pid, kb = $1, $2
  pid2swap = {:procid => line, :swap_mem => swap_only[1]}
  print (pid2swap[:swap_mem].to_s + "\t" + pid2swap[:procid].to_s + "\n")
end

pid2swap.sort_by {|a,b| -a[1] <=> -b[1] }.slice(0...options[:count]).each do |pid, kb|

pid2swap.sort_by {|a,b| -a[1] <=> -b[1] }.slice(0...options[:count]).each do |pid, kb|
  psout = `ps -p #{pid} -o args=`.strip
  if psout.empty?
    printf "%s kB (no longer running)\n", kb
  else
    printf "%s kB %s %s\n", kb, pid, psout
  end
end
