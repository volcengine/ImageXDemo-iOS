## ImageXDemo 介绍
ImageXDemo 基于 TTSDK 的图片 SDK 开发，目前完成了多种图片格式解码、渐进式加载、动图播放控制等基础能力展示，提供了一些示例使用方式，后续会持续迭代。帮助业务侧更快完成图片业务的快速搭建，减少接入过程中遇到的困难。

## 目录结构说明

```
├─ ImageXDemo-iOS
└── ImageXDemo-iOS
     ├── AppDelegate.m
              ... // AppDelegate 等 App 基本文件
└── Pods
    ├── TTSDK   // 火山引擎SDK（图片 SDK 载体）
└── Developments Pods
    ├── Base // 火山引擎图片初始化
    ├── ImageXModule
        ├── Images // 火山引擎图片功能模块
        ├── Settings // 火山引擎图片配置模块
```

## ImageXDemo 运行
1. 进入 ImageXDemo/ImageXDemo-iOS 文件夹
2. 执行 bundle install
2. 执行 bundle exec pod install
3. 打开 ImageXDemo-iOS.xcworkspace 编译运行

## TTSDK 图片 SDK 集成方式
1. 添加 pod 依赖
```
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/volcengine/volcengine-specs.git'

platform :ios, '9.0'

target 'ImageXDemo-iOS' do
  
  # 这里需要明确指定使用 subspecs => Image
  # 可在 ChangeLog 获取版本号，推荐使用最新版本
  pod 'TTSDK', 'x.x.x.x-premium', :subspecs => ['Image']

end
```

2. 执行 pod install

### 更多集成相关文档链接
- [集成准备](https://www.volcengine.com/docs/508/147802)
- [快速开始](https://www.volcengine.com/docs/508/174577)
- [功能接入](https://www.volcengine.com/docs/508/174578)
- [SDWebImage 接口适配说明](https://www.volcengine.com/docs/508/79163)
- [HTTPDNS 接入文档](https://www.volcengine.com/docs/508/78563)

## ChangeLog
链接：https://www.volcengine.com/docs/508/65963


