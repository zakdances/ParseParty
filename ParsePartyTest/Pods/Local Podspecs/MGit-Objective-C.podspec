Pod::Spec.new do |s|


  s.name         = "MGit-Objective-C"
  s.version      = "0.0.1"
  s.summary      = "A short description of MGit."

  s.description  = <<-DESC
                   A git-like system for in-memory objects. Objective-C edition.

                   * Ever wanted to version your objects? Well today is your day, my friend.
                   * Rejoice!
                   DESC

  s.homepage     = "https://github.com/zakdances/MGit-Objective-C"

  s.license      = 'MIT'

  s.author       = 'Zak'

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'

  s.source       = { :git => "https://github.com/zakdances/MGit-Objective-C.git", :tag => "#{s.version}" }

  s.source_files  = '*.{h,m}'

  s.ios.framework  = 'UIKit'
  s.osx.frameworks = 'Foundation'

  s.requires_arc = true

end
