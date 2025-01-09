# BeChat
유튜브 컨텐츠를 함께 실시간으로 감상하며, 채팅으로 소통할 수 있는 앱.


## 🛠️ 개발 환경
- Xcode 15.2
- Swift 5

## ✨ 주요 기능
- 실시간 채팅
- 실시간 유튜브 시청
- 프로필 생성 / 조회 / 수정
- 채팅방 생성 / 조회 / 수정

## 💡 화면 세부 사항  

### 프로필 설정 
![](https://velog.velcdn.com/images/findjayu/post/b15ea50c-3574-45a9-89b7-cd09a2a13e5a/image.png)
![](https://velog.velcdn.com/images/findjayu/post/d637c96e-b7c4-4c69-9c5e-3338ddbd1392/image.png)
- 첫 진입 시 프로필 이미지, 이름 설정 기능 구현
- **UIImagePickerController**를 활용해 갤러리에서 이미지 불러오기 구현  
<br>

### 채팅방 만들기 및 참여하기
![](https://velog.velcdn.com/images/findjayu/post/111469b9-9868-403c-9fa0-348d07e6ab46/image.png)
- 채팅방 이미지, 이름, 설명, 옵션(동영상 추가, 검색), 비밀번호 설정 기능 구현
- 채팅방 설명 추가 시 해시태그 기능 구현
- 채팅방 참여 기능 구현
<br>

### 실시간 채팅 및 유튜브 동영상 추가, 삭제
![](https://velog.velcdn.com/images/findjayu/post/0abe4072-ab9e-41e6-bfc6-b24dc82aac9e/image.png)
![](https://velog.velcdn.com/images/findjayu/post/ebb4aac9-b9e7-418f-98e4-d6d4f44bd023/image.png)
- 입장 및 퇴장 알림, 실시간 채팅 기능 구현
- **YouTubeiOSPlayerHelper**를 활용한 YouTube 동영상 플레이어 화면 구현
- **YouTube Data API**를 이용한 동영상 추가 및 삭제 기능 구현
- 유튜브 동영상 싱크 동기화 기능 구현
<br>

### 프로필 조회 및 채팅방 공유하기
![](https://velog.velcdn.com/images/findjayu/post/8df3e7b3-db89-4cb6-a2f2-f5eefba68edf/image.png)
- 프로필 조회 및 채팅방 편집 기능 구현
- **Deep Link**를 활용한 URL 채팅방 참여 기능 구현  
<br>

### 채팅방 검색 및 인기 해시태그 조회
![](https://velog.velcdn.com/images/findjayu/post/c0ef7cc8-6fea-435a-befa-c6b6e07ad1b7/image.png)
- 인기 해시태그 조회 기능 구현
- 해시태그를 포함한 채팅방 조회 기능 구현
- 채팅방 이름, 설명을 기반으로 검색 기능 구현
<br>

### 프로필 편집
![](https://velog.velcdn.com/images/findjayu/post/303f493e-1044-4a3b-aaa0-cb982875dca9/image.png)
![](https://velog.velcdn.com/images/findjayu/post/6ee6a809-6d6a-440c-9634-a191298ed54f/image.png)
- 프로필 이미지, 배경 이미지, 상태메세지 설정 기능 구현
- **Supabase Storage**에 이미지 저장 후 반환된 URL 사용
