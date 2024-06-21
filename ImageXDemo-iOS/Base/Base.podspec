Pod::Spec.new do |s|
  s.name = "Base"
  s.version = "1.0.0"
  s.summary = "ImageXDemo登陆相关"
  s.description = "ImageXDemo登陆相关"
  s.homepage = "https://www.volcengine.com"
  s.license = 'MIT'
  s.author = { "zhaoxiaoyu" => "zhaoxiaoyu.realxx@bytedance.com" }
  s.source = { :path => './Classes' }

  s.platform = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'

  s.dependency 'TTSDK/Image', '1.41.3.201-imagex'
  s.dependency 'Masonry'
  
end
