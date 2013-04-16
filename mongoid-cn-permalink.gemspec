$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mongoid-cn-permalink/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mongoid-cn-permalink"
  s.version     = MongoidCnPermalink::VERSION
  s.authors     = ["Richie Min"]
  s.email       = ["minruiqi@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/mongoid-cn-permalink"
  s.summary     = "Generate Permalink on Mongoid."
  s.description = "Generate Permalink on Mongoid. Specially on stored chinese words."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.12"

  s.add_dependency "chinese_pinyin"
end
