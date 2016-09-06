Pod::Spec.new do |s|

s.name     = 'ABSteppedProgressBar'

s.version  = '0.0.7'

s.summary  = 'Simple and customisable stepped progress bar for iOS written in Swift'

s.platform     = :ios

s.ios.deployment_target = '8.0'

s.license      = { :type => 'MIT', :file => 'LICENSE' }

s.source_files = 'Sources/*.swift'

s.source       = { :git => "https://github.com/antoninbiret/ABSteppedProgressBar.git", :tag => "#{s.version}" }

s.requires_arc = true

s.framework  = "Foundation"

s.author   = { 'Antonin Biret' => 'haprock@gmail.com' }

s.social_media_url   = "https://twitter.com/Antonin_brt"

s.homepage   = "https://github.com/antoninbiret/ABSteppedProgressBar"

end
