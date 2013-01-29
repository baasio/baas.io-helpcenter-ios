baas.io-helpcenter-ios
======================

Help Center UI Templete for iOS

## Introduce
baas.io의 고객센터 API를 구현한 샘플 앱이다. 

이 프로젝트를 이용하여 만들고자 하는 앱에 바로 적용하거나, 추가로 customizing 하면 된다.


##How To Get Started

###Step 1 : 프로젝트에 적용
XCode 프로젝트에 이 프로젝트를 Sub-Project로 import 하거나, 파일을 복사하여 적용하면 된다.

###Step 2 : 실행
로그인 된 상태에서 아래 코드를 실행하면 모바일 고객센터가 실행된다.
```objc

	MainViewController *mainVC = [[MainViewController alloc] init];
	[self.navigationController pushViewController:mainVC animated:YES]; 

```
