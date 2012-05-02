Gem::Specification.new do |s|
  s.name        = 'sluggy'
  s.version     = '0.1.0'
  s.authors     = ['Ary Djmal']
  s.email       = ['arydjmal@gmail.com']
  s.summary     = 'Minimal slugging/permalink gem for ActiveRecord. Nothing fancy.'
  s.homepage    = 'http://github.com/arydjmal/sluggy'

  s.add_dependency 'activerecord', '>= 3.0.0'

  s.add_development_dependency 'rake'

  s.files = Dir["#{File.dirname(__FILE__)}/**/*"]
end
