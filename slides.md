---
title: But why does it work?
author: Rian McGuire
institute: Melbourne Ruby 2023-08-30
aspectratio: 169
---

# Benefits

<!--
Ruby has a reputation for being magic. Popular gems like Rails use Ruby's powerful dynamic language features
to build abstractions that feel magical, but it can be difficult it understand how they work.

This is talk about some of the strategies I use for unwrapping some of the Ruby magic, and diving into unfamilar code
to understand how it works.
-->

<!-- next slide -->

<!-- So what are the benefits of unwrapping the magic and diving in? -->

* Better understand your system, so it won't surprise you later
<!-- If there's something weird happening, it might a sign of a deeper problem that could bite you in the future -->
* Build confidence in dealing with unfamiliar problems
* Broaden your skills and learn about other parts of the stack
* Write better software
<!-- when you understand what you are building on, you can design to its strengths -->

--------

# What's in this talk?
* Two live demos
  * Questions and interruptions encouraged
* Tips for exploring unfamilar code

--------

# Demo 1 - Magic Methods

<!--

Imagine you've just started working on an existing codebase for the first time. It's Rails, but you open a controller
and you're greeted with some unfamiliar language. You search for some method names on Google, but you can't find any
documentation. You look in the Gemfile and there are 50 gems installed. Where do you start?

Looking at this code - what's schema and safe_params? Definitely not normal Rails features. So how can we find out
what they are?

* Something important to know about Ruby is loading ruby files is procedural, not declarative. Ruby is executing
files as they are loaded. These "domain specific language"-type extensions (like schema here), are methods that are
called as the file is loaded, not special syntax.

* So how can we find what defined the schema method?
* Fortunately there's a Ruby feature that lets us inspect where a method was defined.
* Let's open the rails console
* We can ask DemoController about its "schema" method
* From the path, we can see that it was defined by a gem called dry-rails
* Now we can find the documentation

* This technique works well when it's clear what `self` object is, like in the DemoController class.
* But sometimes you can't tell from reading the file.
 -->

```ruby
class DemoController < ApplicationController
  schema :create do
    required(:name).value(:string)
  end

  def create
    if safe_params.failure?
      render status: 400, json: safe_params.errors
    else
      demo = Demo.create!(safe_params.to_h)
      render status: 201, json: demo
    end
  end
end
```

--------

# Demo 1 - Magic Methods

<!--
* Here's the Rails routes.rb file
* It's not obvious what object is providing the `resources` method
* One technique for digging into this is to set a break point

* If we want to dig a bit futher - and find out how it works or maybe investigate a bug that could be related to the gem
* We can see where the gem is installed from the source location before, but there's a convenient bundler feature for locating any installed gem
 -->

```ruby
Rails.application.routes.draw do
  # Define your application routes per the DSL in
  # https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :demo
end
```

--------

# Demo 1 - Magic Methods

* Use `method(:foo).source_location` to find the code that defined a method
* A debugging tool like `binding.break` can help
* Use `bundle open <gem>` to locate gem code that's installed in your project

--------

# Demo 2 - The Ruby VM

<!-- I want to show you how I go about digging into unfamilar codebases like the Ruby VM, because -->
<!-- Sometimes the documentation is not enough. Even on projects with great documentation like PostgreSQL,
I've found that sometimes you need more information about exactly how something behaves, for example in Postgres, some
of the subtleties around what locks are taken at what time, for particular modification to tables. -->
<!-- One of the massive benefit of open source software, is the source code is available to help answer your questions -->

<!-- A bit of a disclaimer on this one. It's a bit of a contrived example. I want to show that it's not that scary
to dive into the ruby C code and start understanding how it works, even if you don't know C.
-->

* Sometimes the documentation is not enough

--------

# Demo 2 - The Ruby VM

```ruby
def do_work(size)
    array = Array.new(size, 0)
    1_000_000.times do
        array.unshift(0)
        array.pop
    end
end
```

<!-- here's the example -->
<!-- if you squint, maybe it's processing a queue of something -->
<!-- run benchmark -->
<!-- TODO: put the latency table on screen? -->
<!-- start with a question you want to answer - why does the behaviour change at size 64? -->
<!-- suspend your disbelief at little bit, and pretend this 10ms of latency is very important to this application -->

<!-- the first thing our code does is unshift, so we can start with that -->
<!-- let's open the Ruby source code -->
<!-- for the method "unshift" to exist in Ruby, the source code for Ruby must have that string somewhere -->
<!-- let's search for it -->

<!-- can I get a show of hands for people who have read or written C before? -->
<!-- That's fine - we're just skimming through, looking for something that might explain the change in behaviour at size 64.
C has many familar concepts - variables, if statements, functions. Even if you don't understand much, you can get a
rough idea of what it's doing. -->

<!-- So this is it! We've found out that the behaviour of the array implementation
in Ruby can change depending on the length of an array. It has some special cases to make particular uses of arrays faster.

If this was a less contrived example, we could dig in futher and understand how the different cases work, or we could start looking at ways to change our application code.

If people are curious, I'm happy to dig further into how arrays work at the end of the talk.
 -->

--------

# Demo 2 - The Ruby VM

* Search is your friend - use known strings like function names or error messages to find code
<!-- If you're seeing an error message, some code, somewhere is generating it -->
* If you're reading an unfamilar language or codebase, you don't have to understand everything at once
<!-- Skip over things you don't understand, try to get a feel for the high-level logic, dig into the details where you need to -->

--------

# Conclusion

* The layers below are software, too
<!-- you can apply the same logical thinking and debugging skills that you use when working with your Ruby application -->
* Look for opportunities to improve your understanding
<!-- of the technologies you use, and the systems you work on -->
* Be curious
<!-- Always be asking, "but why does it work?" -->

--------

# Thank you!
