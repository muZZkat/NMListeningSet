
Pod::Spec.new do |s|
  s.name     = 'NMListeningSet'
  s.platform = :ios, '6.0'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.homepage = 'http://www.nullmonkey.com'
  s.summary  = 'A way of providing one-to-many notifications using any @protocol'
  s.author   = { 'Murray hughes' => 'murray@nullmonkey.com' }
  s.source   = { :git => 'https://github.com/muZZkat/NMListeningSet.git', :tag => 'release/v1/v1.0.0' }
  s.description  = 'A way of providing one-to-many notifications using any @protocol. Think NSNotifcationCenter and @protocols combined with the benifit of automatic unregistering when the listener is deallocated'
  s.source_files = 'NMListeningSet/NMListeningSet.{h,m}'
  s.requires_arc = true
end