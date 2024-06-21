Pod::Spec.new do |s|
  s.name = "ImageXModule"
  s.version = "1.0.0"
  s.summary = "ImageXDemo Module"
  s.description = "ImageXDemo Module"
  s.homepage = "https://www.volcengine.com"
  s.license = 'MIT'
  s.author = { "zhaoxiaoyu" => "zhaoxiaoyu.realxx@bytedance.com" }
  s.source = { :path => './Classes' }
  s.platform = :ios, '9.0'
  s.default_subspecs = 'Settings', 'Images'
  
  s.subspec 'Settings' do |set|
    set.requires_arc = true
    set.source_files = 'Classes/Settings/**/*'
    set.public_header_files = 'Classes/Settings/**/*.h'
    set.dependency 'TTSDK/Image', '1.41.3.201-imagex'
    set.dependency 'Masonry'
  end
  
  s.subspec 'Images' do |i|
    i.requires_arc = true
    i.source_files = 'Classes/Images/**/*'
    i.public_header_files = 'Classes/Images/**/*.h'
    i.dependency 'TTSDK/Image', '1.41.3.201-imagex'
    i.dependency 'Masonry'
  end
end
