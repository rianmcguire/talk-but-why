#!/usr/bin/env ruby

require 'benchmark'

def do_work(size)
    array = Array.new(size, 0)
    1_000_000.times do
        array.unshift(0)
        array.pop
    end
end

Benchmark.bm do |x|
    x.report(60) do
        do_work(60)
    end

    x.report(70) do
        do_work(70)
    end
end

# Benchmark.bm do |x|
#     (60..70).each do |size|
#         x.report(size) do
#             do_work(size)
#         end
#     end
# end
