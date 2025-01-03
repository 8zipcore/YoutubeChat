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
![](https://img.notionusercontent.com/s3/prod-files-secure%2F1091fc86-e92a-4399-b516-6a4455563d80%2F58d1b6c2-8bc6-494a-9fdd-4d62fc4f7b2f%2FGroup_26.png/size/w=1420?exp=1735985104&sig=BaQp84Ucqx8Gzfp6n_gx1Km7hym7gDpTI3ooJZK74hk)
![](https://img.notionusercontent.com/s3/prod-files-secure%2F1091fc86-e92a-4399-b516-6a4455563d80%2Fedadb1fc-8698-40d7-85e8-99d12e2e58ff%2FGroup_27.png/size/w=1420?exp=1735985188&sig=c67JkeKQCI4LeyQDbV4NaBAfKObg3SkePEr1L_WXTH8)
- 첫 진입 시 프로필 이미지, 이름 설정 기능 구현
- **UIImagePickerController**를 활용해 갤러리에서 이미지 불러오기 구현  
- 
### 채팅방 만들기 및 참여하기
![](https://img.notionusercontent.com/s3/prod-files-secure%2F1091fc86-e92a-4399-b516-6a4455563d80%2Fefae3759-a338-400e-9ed8-94b7b7447315%2FGroup_26_(1).png/size/w=1420?exp=1735985241&sig=mYllkJPDPh3O3GZ0C_FDLWAlwmMI3Fcj5sXOjhn-twg)
- 채팅방 이미지, 이름, 설명, 옵션(동영상 추가, 검색), 비밀번호 설정 기능 구현
- 채팅방 설명 추가 시 해시태그 기능 구현
- 채팅방 참여 기능 구현

### 실시간 채팅 및 유튜브 동영상 추가, 삭제
![](https://img.notionusercontent.com/s3/prod-files-secure%2F1091fc86-e92a-4399-b516-6a4455563d80%2F66f5e902-9254-4c48-888c-f742006e813d%2FGroup_27_(2).png/size/w=1420?exp=1735985285&sig=qhA_m4Q6NOIhgFgyoEf2T1ym9_fXXXZDy6SqSqkE2Zo)
![](https://img.notionusercontent.com/s3/prod-files-secure%2F1091fc86-e92a-4399-b516-6a4455563d80%2F766f74d6-fa70-4df5-9d95-b634e789278c%2FGroup_28.png/size/w=1420?exp=1735985294&sig=J5zOFWMrj8o4hN_ZW55RnX9JMmf6Fkp--RN3EqOmn2g)
- 입장 및 퇴장 알림, 실시간 채팅 기능 구현
- **YouTubeiOSPlayerHelper**를 활용한 YouTube 동영상 플레이어 화면 구현
- **YouTube Data API**를 이용한 동영상 추가 및 삭제 기능 구현
- 유튜브 동영상 싱크 동기화 기능 구현

### 프로필 조회 및 채팅방 공유하기
![](https://img.notionusercontent.com/s3/prod-files-secure%2F1091fc86-e92a-4399-b516-6a4455563d80%2F142f583f-b6f4-43fa-a10e-697f205b383c%2FGroup_29.png/size/w=1420?exp=1735985320&sig=XtA-Ox2Q38d6hp6Gm82HVPOkafJND-nUJ4tpqgXjXK8)
- 프로필 조회 및 채팅방 편집 기능 구현
- **Deep Link**를 활용한 URL 채팅방 참여 기능 구현  

### 채팅방 검색 및 인기 해시태그 조회
![](https://img.notionusercontent.com/s3/prod-files-secure%2F1091fc86-e92a-4399-b516-6a4455563d80%2F6456f752-bfc4-4396-99d3-d9c18a06650c%2FGroup_30.png/size/w=1420?exp=1735985345&sig=BaJtdkPu-VsPz4_Ui7m_jB1RzrwJDbnS0ALxcWU542s)
- 인기 해시태그 조회 기능 구현
- 해시태그를 포함한 채팅방 조회 기능 구현
- 채팅방 이름, 설명을 기반으로 검색 기능 구현

### 프로필 편집
![](https://img.notionusercontent.com/s3/prod-files-secure%2F1091fc86-e92a-4399-b516-6a4455563d80%2F6b935a5c-d182-42e5-91cf-a413d97ca619%2FGroup_31_(2).png/size/w=1420?exp=1735985380&sig=imqz4Tn_Cn28T-NZe-aNsXgCMz5noIKagWoSiWo3wwg)
![](https://img.notionusercontent.com/s3/prod-files-secure%2F1091fc86-e92a-4399-b516-6a4455563d80%2F49c1b089-f6f6-4b8a-b616-9c7d48e31122%2FGroup_32.png/size/w=1420?exp=1735985392&sig=_cc66VrZK1Ckd5THgMDVVqlQUMfQiy_Mppk2pdoUxxk)
- 프로필 이미지, 배경 이미지, 상태메세지 설정 기능 구현
- **Supabase Storage**에 이미지 저장 후 반환된 URL 사용
