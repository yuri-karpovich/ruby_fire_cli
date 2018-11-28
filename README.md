# RubyCLI
[![Gem Version][GV img]][Gem Version]
[![Build Status][BS img]][Build Status]
[![Code Climate][CC img]][Code Climate]
[![Coverage Status][CS img]][Coverage Status]

This gem automatically generating command line interfaces (CLIs) from Ruby object. No special code modifications required!.
`ruby_fire_cli` is a smart mix of [YARD](http://yardoc.org/) and [Trollop](http://manageiq.github.io/trollop/) gems. 
It's an analog of [Python Fire](https://github.com/google/python-fire) in Ruby language.  
> 1. it parses [YARD](http://yardoc.org/) annotations of classes and methods to 'understand' your code
> 2. it generates friendly unix-like help menu for your tool (using [Trollop](http://manageiq.github.io/trollop/) gem)
> 3. it parses command-line input and run your Ruby code in a proper way 

Just 4 simple steps to make your code runnable from terminal:
1. Just add `@runnable` tag in 

One thing you need to do is to add an [YARD](http://yardoc.org/) tag annotation `@runnable`.

## Usage
`ruby_fire_cli` extends [YARD](http://yardoc.org/) with a new tag: `@runnable`. You need to set this tag in a Class and Method annotation. After that it will be possible to call this method from command-line.
Usage instructions are as simple as one, two, three:
1. Add `@runnable` tag
2. Now you can run your tool from terminal by `rcli /path/to/class.rb_file` command
3. PROFIT! 

### Example
1. Install `ruby_fire_cli` gem
2. Put some code to `/home/user/project/my_class.rb`
```ruby
# @runnable
class MyClass

    # @runnable
    def say_hello
      puts 'Hello!'
    end
    
end
```
3. Run terminal command to run `say_hello` method
```bash
rcli /home/user/project/my_class.rb say_hello

-> Hello!
```

Read FAQ for more examples.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_fire_cli'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_fire_cli

## FAQ
#### **Can I add documentation for my tool and customize help page content?**
Yes. Any text placed after `@runnable` tag will be displayed on the help page. You can add any additional information about how to use your tool there.
> **Tip**: You can use multi-line text as well

##### Example:
```ruby
# @runnable This tool can talk to you. Run it when you are lonely.
#   Written in Ruby.  
class MyClass

    def initialize
      @hello_msg = 'Hello!' 
      @bye_msg = 'Good Bye!' 
    end
    
    # @runnable Say 'Hello' to you.
    # @param [String] name Your name
    def say_hello(name)
      puts @hello_msg + ', ' + name
    end
    
    # @runnable Say 'Good Bye' to you.
    def say_bye
      puts @bye_msg
    end
    
end
```

```bash
 ~> rcli /projects/example/my_class.rb  --help
Options:
  --debug    Run in debug mode.

This tool can talk to you. Run it when you are lonely.
Written in Ruby.

Available actions:
        - say_hello
                Say 'Hello' to you.
        - say_bye
                Say 'Good Bye' to you.
```

```bash
 ~> rcli /projects/example/my_class.rb  say_hello -h
Options:
  -d, --debug    Run in debug mode.
  -h, --help     Show this message
  --name=<s>     (Ruby class: String) Your name

Say 'Hello' to you.

```
#### **Can I send parameters to my methods?**
Yes, `ruby_fire_cli` parses YARD annotation (`@param` and `@option` tags) and check the list of parameters for your method.

> *Restriction*: You can use Hash parameters as well (for storing options). But you cannot use the same name for parameter and for option. 
> 
> For example, `def limit(number, options = {number: 5})...` - `number` name is not allowed. You should use another parameter name.

##### Example:
```ruby
# @runnable This tool can talk to you. Run it when you are lonely.
#   Written in Ruby.  
class MyClass

    def initialize
      @hello_msg = 'Hello' 
      @bye_msg = 'Good Bye' 
    end
    
    # @runnable Say 'Hello' to you.
    # @param [String] name Your name
    # @param [Hash] options options
    # @option options [Boolean] :second_meet Have you met before?
    # @option options [String] :prefix Your custom prefix
    def say_hello(name, options = {})
      second_meet = nil
      second_meet = 'Nice to see you again!' if options['second_meet']
      prefix = options['prefix']
      message = @hello_msg + ', '
      message += "#{prefix} " if prefix
      message += "#{name}. "
      message += second_meet if second_meet
      puts message
    end
    
end
```
```bash
~> rcli /projects/example/my_class.rb  say_hello -h 
Options:
  -d, --debug      Run in debug mode.
  -h, --help       Show this message
  --name=<s>       (Ruby class: String) Your name
  --second-meet    (Ruby class: Boolean) Have you met before?
  --prefix=<s>     (Ruby class: String) Your custom prefix

Say 'Hello' to you.
```
```bash
~> rcli /projects/example/my_class.rb  say_hello -n John --second-meet --prefix Mr. 
Hello, Mr. John. Nice to see you again!
```

#### **Can I use optional parameters?**
Yes. All parameters with `@option` YARD tag are optional. 

`--second-meet` and `--prefix` parameters are optional in the following example:
```ruby
# @runnable Say 'Hello' to you.
    # @param [String] name Your name
    # @param [Hash] options options
    # @option options [Boolean] :second_meet Have you met before?
    # @option options [String] :prefix Your custom prefix
```
Another approach is to use *default values* for parameters. 
Parameter `--name` in the following example is optional because it has the default value `Chuck`.
```ruby
    # @runnable Say 'Hello' to you.
    # @param [String] name Your name
    # @param [Hash] options options
    # @option options [Boolean] :second_meet Have you met before?
    # @option options [String] :prefix Your custom prefix
    def say_hello(name = 'Chuck', options = {})
      second_meet = nil
      second_meet = 'Nice to see you again!' if options['second_meet']
      prefix = options['prefix']
      message = @hello_msg + ', '
      message += "#{prefix} " if prefix
      message += "#{name}. "
      message += second_meet if second_meet
      puts message
    end
```
```bash
-> rcli /projects/example/my_class.rb  say_hello  
Hello, Chuck. 
```
#### **Is it works only for class methods?**
`ruby_fire_cli` works with both methods - **class** and **instance** methods. It's clear how it works with **class** method - method is called without any preconditions.
**Instance** method will be called in accordance with following logic:
 1. call `:initialize` method 
 2. call specified action method

#### **My `require` code doesn't work well. How can I fix it?**
Use `require_relative ` method instead.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yuri-karpovich/ruby_fire_cli.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[Gem Version]: https://rubygems.org/gems/ruby_fire_cli
[Build Status]: https://travis-ci.org/yuri-karpovich/ruby_fire_cli
[travis pull requests]: https://travis-ci.org/yuri-karpovich/ruby_fire_cli/pull_requests
[Code Climate]: https://codeclimate.com/github/yuri-karpovich/ruby_fire_cli
[Coverage Status]: https://coveralls.io/github/yuri-karpovich/ruby_fire_cli

[GV img]: https://badge.fury.io/rb/ruby_fire_cli.svg
[BS img]: https://travis-ci.org/yuri-karpovich/ruby_fire_cli.svg?branch=master
[CC img]: https://codeclimate.com/github/yuri-karpovich/ruby_fire_cli.png
[CS img]: https://coveralls.io/repos/github/yuri-karpovich/ruby_fire_cli/badge.svg?branch=master
