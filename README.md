# gem_hello_world

A trivial repository to experiment with a Ruby GEM used as a Vagrant Plugin.

---

Context about this tutorial:

1. For our situation, it would be best if Vagrant could install
plugins from private GitHub repositories. But this hasn't been 
implemented yet. See [ISSUE 1829] (https://github.com/mitchellh/vagrant/issues/1829).

2. In newer versions of Vagrant, it isolates itself from system
installed GEM's. This impacts how GEM's are made available
to Vagrant.

3. It is not appropriate in our situation to make GEM's available
to the public, so we need to run our own server. GEM in a Box
is supposedly the defacto solution. It is not protected by default.
See [GEM in a Box] (https://github.com/geminabox/geminabox).


## Cut and Paste Style Tutorial
Fetch this GitHub repository
```
cd ~/
git clone git@github.com:zoglmannk/gem_hello_world.git
```

Run tests
```
cd gem_hello_world
rake test
```

Build the GEM and install it system-wide
```
gem build zoglmannk_hello_world.gemspec
sudo gem install ./zoglmannk_hello_world-0.0.1.gem
```

Use the GEM with the interactive Ruby shell
```
% irb
irb(main):001:0> require 'zoglmannk_hello_world'
=> true
irb(main):002:0> Hello.hi
Hello World!
=> nil
```

Uninstall the GEM system-wide
```
sudo gem uninstall zoglmannk_hello_world
```

Setup GEM in a Box
```
sudo gem install geminabox
cd ~/
mkdir -p geminabox/data
cd geminabox
```

```
vi config.ru
```
Add the following lines
```
require "rubygems"
require "geminabox"

Geminabox.data = "./data"
run Geminabox::Server
```

Startup GEM in a Box
```
rackup
```

Publish our GEM 
```
cd ~/gem_hello_world
gem build zoglmannk_hello_world.gemspec
gem inabox ./zoglmannk_hello_world-0.0.1.gem
```

The first time you publish, it will prompt for a GEM in a Box instance
use `http://localhost:9292`. If you need to reconfigure it later, use 
`gem inabox -c`.


Create temporary vagrant configuration
```
cd ~/
mkdir test-vagrant
cd test-vagrant
vagrant init
```

Install zoglmannk_hello_world as a vagrant plugin
```
vagrant plugin install zoglmannk_hello_world --plugin-source http://localhost:9292
```

See that the zoglmannk_hello_world plugin is installed
```
vagrant plugin list
```

Modify Vagrantfile so that the hello world functionality is called
```
vi Vagrantfile
```
Add the following line to the top of the file
```
Hello.hi
```

Verify the functionality by running the following command. Look for
`Hello world!` in the output.
```
vagrant status
```

## Round trip quickly during Vagrant Plugin Development
If you are developing something new, you may want to round trip quickly. The following
demonstrates how to do that.

Uninstall the plugin
```
vagrant plugin uninstall zoglmannk_hello_world
```

###Install Bundler
Under OS X I had to do the following steps before installing Bundler

Install homebrew
```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Install libxml2 which is needed by nokogiri which is needed by bundler
```
brew install libxml2
brew install libxslt
```

Install OS X command line developer tools
```
xcode-select --install
```

Install specific version of nokogiri
```
sudo gem install nokogiri -v '1.5.11' -- --use-system-libraries --with-xml2-lib=/usr/lib --with-xml2-include=/usr/include/libxml2 --with-xslt-lib=/usr/lib --with-xslt-include=/usr/include/libxslt
```

Install bundler
```
sudo gem install bundler
```

---

Create Gemfile in vagrant dir
```
cd ~/test-vagrant
vi Gemfile
```
Add the following
```
source "https://rubygems.org"
source "http://localhost:9292"

group :development do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  gem "vagrant", :git => "https://github.com/mitchellh/vagrant.git"
end

group :plugins do
  gem 'zoglmannk_hello_world', path: "~/gem_hello_world"
end
```

Install gems for Bundle
```
sudo bundle install
```

Run vagrant
```
bundle exec vagrant status
```

Change something visible in output from our GEM
```
cd ~/gem_hello_world
vi lib/zoglmannk_hello_world.rb
```
Change the file content to the following
```
class Hello
  def self.hi(to_who = "world")
    msg = "Hello #{to_who}!"
    puts msg
    puts msg
    msg
  end
end
```

Rerun vagrant status
```
cd ~/test-vagrant
bundle exec vagrant status
```

## Useful Links

* [GEM in a Box] (https://github.com/geminabox/geminabox)
* [Bundler] (http://bundler.io/v1.3/gemfile.html)
* [Bundler on GitHub] (https://github.com/bundler/bundler)
* [Ruby GEM Tutorial] (http://guides.rubygems.org/rubygems-basics/)
* [Rake GitHub] (https://github.com/ruby/rake)
* [Running a Private Gem Server Blog Entry] (http://johnpwood.net/2013/11/08/running-a-private-gem-server/)
