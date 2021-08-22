////
////  Auth-Extension.swift
////  BallRoomMP
////
////  Created by 清水正明 on 2021/03/09.
////
//
//import Foundation
//import UIKit
//import FirebaseAuth
//import FirebaseFirestore
//import FirebaseStorage
//
//
//extension Firestore {
//    
//    //MARK:自分のデータをFetchする
//    static func fetchMyUserDataFromFirestore(completion: @escaping (UserData)->()){
//        guard let myUid = Auth.auth().currentUser?.uid else { return }
//        Firestore.firestore().collection("User").document(myUid).getDocument { (snapshot, error) in
//            
//            if let error = error {
//                print("error : ",error)
//                print("会員登録が完了していません")
//                return
//            }
//            guard let dic = snapshot?.data() else { print("会員登録が完了していません"); return }
//            let userData = UserData(dic: dic)
//            completion(userData)
//        }
//    }
//    //MARK:UIDのデータをFetchする
//    static func fetchUserDataFromFirestoreByUid(Uid:String,completion: @escaping (UserData)->()){
//        Firestore.firestore().collection("User").document(Uid).getDocument { (snapshot, error) in
//            
//            if let error = error {
//                print("error : ",error)
//                print("会員登録が完了していません")
//                let userData = UserData(dic: ["_":"_"])
//                completion(userData)
//                return
//            }
//            guard let dic = snapshot?.data() else { print("会員登録が完了していません"); return }
//            let userData = UserData(dic: dic)
//            completion(userData)
//        }
//    }
//    //MARK:UIDのステータスをFetchする
//    static func fetchStatusFromFirestore(userUid:String,completion: @escaping (UserStatus)->()){
//        
//         let Ref = Firestore.firestore().collection("Status").document(userUid)
//
//        Ref.getDocument { (snapshot, error) in
//            
//            if let error = error {
//                print("error : ",error)
//                print("会員登録が完了していません")
//                let userStatus = UserStatus(dic:["-":"-"])
//                completion(userStatus)
//                return
//            }else{
//                guard let dic = snapshot?.data() else {
//                    print("会員登録が完了していません")
//                    let userStatus = UserStatus(dic:["-":"-"])
//                    completion(userStatus)
//                    return
//                }
//                let userStatus = UserStatus(dic: dic)
//                completion(userStatus)
//            }
//           
//        }
//        
//    }
//    //MARK:自分の年齢確認をFetchする
//    static func fetchAgeConfFromFirestore(completion: @escaping (UserAgeConf)->()){
//        guard let myUid = Auth.auth().currentUser?.uid else { return }
//        Firestore.firestore().collection("RequestAgeConfirmation").document(myUid).getDocument { (snapshot, error) in
//            
//            if let error = error {
//                print("error : ",error)
//                print("会員登録が完了していません")
//                return
//            }
//            guard let dic = snapshot?.data() else { print("会員登録が完了していません"); return }
//            let userAgeConf = UserAgeConf(dic: dic)
//            completion(userAgeConf)
//        }
//    }
//    //マッチングしているかどうか
//    static func matchedList(To_user_id:String,from_user_id:String,QuerySnapshot: @escaping (QuerySnapshot?,Error?)->()){
//        
//        Firestore.firestore().collection("MatchedList").whereField("To_user_id", isEqualTo: To_user_id).whereField("from_user_id", isEqualTo: from_user_id).getDocuments { (snapshot, error) in
//            if let error = error {
//                print("MatchedList Error :",error)
//                QuerySnapshot(snapshot, error)
//                return
//            }
//            QuerySnapshot(snapshot, error)
//        }
//    }
//    //リクエストしているかどうか
//    static func matchingRequest(To_user_id:String,from_user_id:String,QuerySnapshot: @escaping (QuerySnapshot?,Error?)->()){
//        
//        Firestore.firestore().collection("MatchingRequest").whereField("To_user_id", isEqualTo: To_user_id).whereField("from_user_id", isEqualTo: from_user_id).getDocuments { (snapshot, error) in
//            if let error = error {
//                print("MatchedList Error :",error)
//                QuerySnapshot(snapshot, error)
//                return
//            }
//            QuerySnapshot(snapshot, error)
//        }
//    }
//    static func findMatchingRequest(partnerUid:String,matchingCount:Int){
//        
//        guard let myUid = Auth.auth().currentUser?.uid else {return}
//        //マッチングリクエストがあるか確認
//        Firestore.firestore().collection("MatchingRequest").whereField("To_user_id", isEqualTo: partnerUid).whereField("from_user_id", isEqualTo: myUid).getDocuments { (snapshot, err) in
//            if let err = err {
//                print("err:",err)
//                return
//            }
//            Firestore.firestore().collection("MatchingRequest").whereField("To_user_id", isEqualTo: myUid).whereField("from_user_id", isEqualTo: partnerUid).getDocuments { (snapshot1, err) in
//                if let err = err {
//                    print("err:",err)
//                    return
//                }
//                //MARK:一段目 -> MatchingRequestに相手からのリクエストがあるかどうか
//                if  snapshot?.documents.count == 0 && snapshot1?.documents.count == 0 {
//                    print("リクエストがないので投げます")
//                    //MARK:二段目 -> MatchingRequestに相手からのリクエストがないため、新規にリクエストを投げる
//                    self.postRequest(myUid: myUid, partnerUid: partnerUid, matchingCount: matchingCount) { success in
//                        print("addMatchedList is ",success)
//                    }
//                    
//                }else if snapshot?.documents.count != 0 {
//                    //MARK:二段目 -> MatchingRequestに相手からのリクエストではなく自分のため、return
//                    print("即に自分がリクエストを投げています")
//                }else if snapshot1?.documents.count != 0 {
//                    print("マッチングしましたstatusをマッチング中に申請します。")
//                    //MARK:二段目 -> MatchingRequestに相手からのリクエストがあるため、相手の matchingCount　と自分の　matchingCount　を合わせて相性を診断
//                    
//                    snapshot1?.documents.forEach({ (QueryDocumentSnapshot) in
//                        let dic = MatchRequest(dic: (snapshot1?.documents.first?.data())!)
//                        let  sumCount = matchingCount + dic.matchingCount //MARK:8_MAX
//                        //MARK:三段目 -> MatchedListを作成
//                        self.addMatchedList(documentID: QueryDocumentSnapshot.documentID, myUid: myUid, partnerUid: partnerUid, sumMatchingCount: sumCount) { success in
//                            print("addMatchedList is ",success)
//                        }
//                    })
//                }
//            }
//            //クエリがあるときしか反応しない。
//            //クエリがない
//        }
//    }
//    //MARK:マッチングリストを新しく追加する@MatchedList
//    static func addMatchedList(documentID:String,myUid:String,partnerUid:String,sumMatchingCount:Int,completion: @escaping (Bool)->()){
//        
//        let randomString = CalculateFromInt().randomStringId(length: 20)
//        
//        let members = [myUid,partnerUid]
//        //MatchedListに追加する
//        let doc :[String:Any] = [
//            "from_user_id": myUid,
//            "To_user_id":partnerUid,
//            "members":members,
//            "createdAt":Timestamp(),
//            "roomId":randomString,
//            "SumMathingCount":sumMatchingCount
//        ]
//        self.matchedList(To_user_id: members[0], from_user_id: members[1]) { snapshot0, error0 in
//            if let err = error0 {
//                print("err:",err)
//                completion(false)
//                return
//            }
//            self.matchedList(To_user_id: members[1], from_user_id: members[0]) { snapshot1, error1 in
//                if let err = error1 {
//                    print("err:",err)
//                    completion(false)
//                    return
//                }
//                //マッチングしてないときMLに追加
//                if (snapshot0?.isEmpty == true) && (snapshot1?.isEmpty == true) {
//                    //マッチングを開始する
//                    Firestore.firestore().collection("MatchingRequest").document(documentID).updateData(["status":1]) { (err) in
//                        if let err = err {
//                            print(err)
//                            completion(false)
//                            return
//                        }
//                        Firestore.firestore().collection("MatchedList").document(randomString).setData(doc){ (err) in
//                            if let err = err {
//                                print(err)
//                                completion(false)
//                                return
//                            }
//                            print("マッチングが開始されました！")
//                            completion(true)
//                        }
//                    }
//                }else{
//                    print("もうマッチングしています : ",snapshot0?.count ?? 0,"_:_",snapshot1?.count ?? 0)
//                    completion(false)
//                }
//            }
//        }
//    }
//    //MARK:Requestを投げる
//    static func postRequest(myUid:String,partnerUid:String,matchingCount:Int,completion: @escaping (Bool)->()){
//        
//        let member = [myUid,partnerUid]
//        let fileName = NSUUID().uuidString
//        //マッチングリクエストを投げる。
//        let doc :[String:Any] = [
//            "id":fileName,
//            "from_user_id": myUid,
//            "To_user_id":partnerUid,
//            "members":member,
//            "status":0,
//            "From_Matching_Count":matchingCount,
//            "createdAt":Timestamp()
//        ]
//        Firestore.firestore().collection("MatchingRequest").document(fileName).setData(doc){ (err) in
//            if let err = err {
//                print(err)
//                completion(false)
//                return
//            }else {
//                print("requestを投げました")
//                completion(true)
//            }
//        }
//    }
//  
//    
//    //MARK:運営に報告をする。
//    static func reportUserToFirebase(ToUserUid:String?,myUid:String?,contentText:String?,completion: @escaping (Bool)->()){
//        
//        guard let ToUserUid = ToUserUid else {return}
//        guard let myUid = myUid else {return}
//        guard let contentText = contentText else{ return }
//        
//        let dic = [
//            "Created_At":Timestamp(),
//            "ToUid":ToUserUid,
//            "FromUid":myUid,
//            "content":contentText
//        ] as [String : Any]
//        
//        
//        Firestore.firestore().collection("UserReport").document().setData(dic) { (err) in
//            
//            if let err = err {
//                print("報告err:",err)
//                completion(false)
//                return
//            }
//            
//            print("運営に送信が完了しました。")
//            completion(true)
//            
//            
//        }
//    }
//    //MARK:SuperLikeを送る。
//    static func sendSuperLikeToFirebase(ToUserUid:String?,myUid:String?,Message:String?,completion: @escaping (Bool)->()){
//        
////        print("ToUserUid:",ToUserUid)
////        print("myUid:",myUid)
////        print("Message:",Message)
//        
//        guard let myUid = myUid else { return }
//        guard let ToUserUid = ToUserUid else {return}
//        guard let Message = Message else { return }
//        let NewUid = UUID().uuidString
//        
//        let dic:[String:Any] = [
//            "id":NewUid,
//            "FromUid":myUid,
//            "ToUid":ToUserUid,
//            "Message":Message,
//            "CreateAt":Timestamp()
//        ]
//        
//        Firestore.firestore().collection("SuperLike").document(NewUid).setData(dic) { (err) in
//            
//            if let err = err {
//                print("SuperLikeCountErr:",err)
//                completion(false)
//                return
//            }
//            print("SuperLikeが送られました")
//            completion(true)
//        }
//    }
//    //MARK:画像のURLをFirestore保存する。
//    static func registImageToFirestore(profileURLArray:[String],completion: @escaping (Bool)->()){
//        
//        let dic :[String:Any] = [
//            "UserImageURL":profileURLArray
//        ]
//        guard let myUid = Auth.auth().currentUser?.uid else {return}
//        
//        Firestore.firestore().collection("User").document(myUid).updateData(dic) { (err) in
//            if let err = err {
//                print("err:",err)
//                completion(false)
//                return
//            }
//            print("Userに画像の保存に成功しました。")
//            completion(true)
//        }
//    }
//    //MARK:Login初期画像を保存する.
//    static func registFirstImageToFirestore(profileURLArray:[String],completion: @escaping (Bool)->()) {
//        let randomInt = Int.random(in: 0..<10000000)
//        guard let myUid = Auth.auth().currentUser?.uid else {return}
//        let dic :[String:Any] = [
//            "UserImageURL":profileURLArray,
//            "RegisterComplite":3,
//            "FirstTag":"Shadow",
//            "LikeCount":0,
//            "Random":randomInt
//        ]
//        Firestore.firestore().collection("User").document(myUid).updateData(dic) { (err) in
//            if let err = err {
//                    print("FireBaseへの情報保存に失敗しました\(err)")
//                completion(false)
//                return
//            }
//            UserDefaults.standard.setValue(3, forKey: "RegisterComplite")
//            completion(true)
//        }
//    }
//    //MARK:RegisterCompliteのカウント
//    static func fetchRegisterComplite(myUid:String,completion: @escaping (Int,Int)->()){
//        
//        
//        firestore().collection("User").document(myUid).getDocument { (snapshot, err) in
//            if let err = err  {
//                print("err",err)
//                completion(0,0)
//                return
//            }
//            guard let dic = snapshot?.data()  else { return }
//            let data = UserData(dic: dic)
//            
//            //テストが必
//            if let buyCount = data.specialBuyCountUP {
//                if buyCount == 1 {
//                    let limitDate =  data.specialBuyLimitDate.dateValue()
//                    if limitDate > Date() {
//                        UserDefaults.standard.set(1, forKey: "buy")
//                    }else{
//                        print("期限切れです")
//                        UserDefaults.standard.set(nil, forKey: "buy")
//                    }
//                }
//            }
//            print("RegisterComplite in Firestore : ",data.RegisterComplite," BanExperience : ",data.banExperience)
//            
//            completion(data.RegisterComplite,data.banExperience)
//        }
//        
//    }
//    //MARK:相手をBlockする
//    static func blockUserToFirestore(chatRooms:String?,completion: @escaping (Bool)->()){
//        
//        guard let chatRooms = chatRooms else { return }
//        
//        let dic :[String:Any] = [
//            "blockPartner":true
//        ]
//        
//        firestore().collection("ChatRooms").document(chatRooms).updateData(dic) { (err) in
//            if let err = err {
//                print("err:",err)
//                completion(false)
//                return
//            }
//            print("Userをブロックしました。")
//            completion(true)
//        }
//    }
//    //MARK:相手を解除する
//    static func releaseblockToFirestore(chatRoom:String?,completion: @escaping (Bool)->()){
//        
//        guard let chatRoom = chatRoom else { return }
//        
//        let dic :[String:Any] = [
//            "blockPartner":false
//        ]
//        
//        firestore().collection("ChatRooms").document(chatRoom).updateData(dic) { (err) in
//            if let err = err {
//                print("err:",err)
//                completion(false)
//                return
//            }
//            print("Userをブロックしました。")
//            completion(true)
//        }
//    }
//    //MARK:既読する。
//    static func readMessageTofirestore(ChatRoomID:String,MessageID:String,myUid:String,completion:@escaping (Bool)->()){
//        
//        firestore().collection("ChatRooms").document( ChatRoomID).collection("messages").document(MessageID).updateData(["isReadUser":myUid]) { Error in
//            if let Error = Error {
//                print("Error(IsRead) : ",Error)
//                completion(false)
//                return
//            }
//            completion(true)
//        }
//    }
//    //MARK:CRの検索
//    static func searchCR(members:[String],completion:@escaping (QuerySnapshot?)->()){
//        
//       firestore().collection("ChatRooms").whereField("memebars",isEqualTo: members).getDocuments { (snapShop, err) in
//            if let err = err {
//                print("err:",err)
//                completion(snapShop)
//                return
//            }
//        completion(snapShop)
//       }
//    }
//    //MARK:CRの新規作成
//    static func createCRandSegue(partnerUid:String,myUid:String,completion:@escaping (Bool)->()){
//        
//        let makeId = UUID().uuidString
//        let memebars = [myUid,partnerUid]
//        let memebarsX = [partnerUid,myUid]
//        let docData :[String:Any] = [
//            "memebars": memebars,
//            "latestMessage":"チャットを開始しました！",
//            "documentId":makeId,
//            "blockPartner":false,
//            "CreatedAt" :Timestamp(),
//            "UpdateAt":Timestamp()
//        ]
//        
//        Firestore.searchCR(members: memebars) { snapShot in
//            Firestore.searchCR(members: memebarsX) { snapShotX in
//                if  snapShot?.documents.count == 0 && snapShotX?.documents.count == 0 {
//                    
//                   
//                    Firestore.firestore().collection("ChatRooms").document(makeId).setData(docData) { (err) in
//                        if let err = err {
//                            print("エラーです遷移しません",err)
//                            completion(false)
//                            return
//                        }
//                        print("ルームを作リました遷移します")
//                        completion(true)
//                    }
//                    
//                }else{
//                    print("既に作成されています")
//                    completion(false)
//                }
//            }
//        }
//    }
//    //MARK:Userの任意のFieldのDataをUpdateする
//    static func updateUserDataToFirestore(dic:[String:Any],completion: @escaping (Bool)->()){
//    
//        guard let myUid = Auth.auth().currentUser?.uid else {return}
//        
//        Firestore.firestore().collection("User").document(myUid).updateData(dic) { (err) in
//            if let err = err {
//                print("err:",err)
//                completion(false)
//                return
//            }
//            print("UserDataをUpdate -> \(dic)")
//            completion(true)
//        }
//    }
//    //MARK:年齢確認の申請
//    static func newRequestAgeConfirm(downLoadURL:String,completion: @escaping (Bool)->()){
//        guard let myUid = Auth.auth().currentUser?.uid else {return}
//        
//        let dic :[String:Any] = [
//            "From_Uid":myUid,
//            "ImageURL":downLoadURL,
//            "Status":0,
//            "Read":0,
//            "Message":"申請中",
//            "Create_At":Timestamp(),
//            "Update_At":Timestamp(),
//        ]
//        Firestore.firestore().collection("RequestAgeConfirmation").document(myUid).setData(dic){ (err) in
//            if let err = err {
//                print("err:",err)
//                completion(false)
//                return
//            }
//            completion(true)
//            print("年齢確認の申請を完了しました。")
//        }
//    }
//    //MARK:年齢確認の再申請
//    static func oneMorerequestAgeConfirm(downLoadURL:String,completion: @escaping (Bool)->()){
//        guard let myUid = Auth.auth().currentUser?.uid else {return}
//        let dic :[String:Any] = [
//            "ImageURL":downLoadURL,
//            "Read":0,
//            "Message":"再申請中",
//            "Update_At":Timestamp(),
//        ]
//        Firestore.firestore().collection("RequestAgeConfirmation").document(myUid).updateData(dic){ (err) in
//            if let err = err {
//                print("err:",err)
//                completion(false)
//                return
//            }
//            completion(true)
//            print("年齢確認の再申請を完了しました。")
//        }
//    }
//    //MARK:年齢確認の再申請
//    static func fetchSuperLikeCount(completion: @escaping (Int)->()) {
//        guard let myUid = Auth.auth().currentUser?.uid else {return completion(0)}
//        var count = 0
//        Firestore.firestore().collection("SuperLike").whereField("ToUid", isEqualTo: myUid).getDocuments { (QuerySnapshot, error) in
//            if let error = error {
//                print("err:",error)
//                return completion(count)
//            }
//            count = QuerySnapshot?.count ?? 0
//            print(#function)
//            return completion(count)
//        }
//    }
//    static func fetchLikeCount(completion: @escaping (Int)->()) {
//        guard let myUid = Auth.auth().currentUser?.uid else {return completion(0)}
//        var count = 0
//        Firestore.firestore().collection("MatchingRequest").whereField("To_user_id", isEqualTo: myUid).getDocuments { (QuerySnapshot, error) in
//            if let error = error {
//                print("err:",error)
//                return completion(count)
//            }
//            count = QuerySnapshot?.count ?? 0
//            print(#function)
//            return completion(count)
//        }
//    }
//    //MARK:画像を送信する
//    static func sendImageMessage(chatRoomId:String,myName:String,myImageURL:String,downloadURL:String,completion: @escaping (Bool)->()){
//        guard let myUid = Auth.auth().currentUser?.uid else {
//            completion(false)
//            return }
//        let makeId = UUID().uuidString
//        
//        let docData = [
//            
//            "Text":"ThisMessageIsImage",
//            "MessageId":makeId,
//            "SenderId":myUid,
//            "SenderName":myName,
//            "SendAt":Timestamp(),
//            "imageURL":myImageURL,
//            "MessageImageURL":downloadURL,
//            "isReadUser":""
//            
//        ] as [String : Any]
//        
//        let update  = [
//            "UpdateAt":Timestamp(),
//            "latestMessage":"画像が送信されました"
//        ] as [String : Any]
//        
//        Firestore.firestore().collection("ChatRooms").document(chatRoomId).collection("messages").document(makeId).setData(docData) { (err) in
//            if let err = err{
//                print("err:",err)
//                completion(false)
//                return
//            }
//            
//            Firestore.firestore().collection("ChatRooms").document(chatRoomId).updateData(update) { (err) in
//                if let err = err {
//                    print("err:",err)
//                    completion(false)
//                    return
//                }
//            }
//            print("画像の送信に成功しました")
//            completion(true)
//        }
//    }
//    //MARK:メッセージを送信する
//    static func sendMessageButton(chatRoomId:String,myName:String,myImageURL:String,text:String,completion: @escaping (Bool)->()){
//        guard let myUid = Auth.auth().currentUser?.uid else {
//            completion(false)
//            return
//        }
//        let makeId = UUID().uuidString
//        let docData = [
//            
//            "Text":text,
//            "MessageId":makeId,
//            "SenderId":myUid,
//            "SenderName":myName,
//            "SendAt":Timestamp(),
//            "imageURL":myImageURL,
//            "isReadUser":""
//            
//        ] as [String : Any]
//        
//        let update  = [
//            "UpdateAt":Timestamp(),
//            "latestMessage":text
//        ] as [String : Any]
//        
//        Firestore.firestore().collection("ChatRooms").document(chatRoomId).collection("messages").document(makeId).setData(docData) { (err) in
//            if let err = err{
//                print("err:",err)
//                completion(false)
//                return
//            }
//            
//            Firestore.firestore().collection("ChatRooms").document(chatRoomId).updateData(update) { (err) in
//                if let err = err {
//                    print("err:",err)
//                    completion(false)
//                    return
//                }
//            }
//            print("messageの送信に成功しました")
//            completion(true)
//        }
//    }
//    //MARK:初めてのログイン購入履歴
//    static func setReceipt(completion: @escaping (Bool)->()){
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        
//        let dicData = [
//         "Uid":uid,
//         "Expired":Date(),
//         "Rank":0,
//         "Updated_At":Timestamp(),
//         "Created_At":Timestamp()
//         ] as [String : Any]
//        
//        Firestore.firestore().collection("Receipt").document(uid).setData(dicData) { (Error) in
//            if let Error = Error {
//                print("Error",Error)
//                completion(false)
//                return
//            }
//            completion(true)
//        }
//        
//    }
//    
//    //MARK:プレミアム会員に申し込んだ時
//    static func PremiumSubscription(ProductID:String,Expired:Date,items:String,completion: @escaping (Bool)->()){
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        
////        print("items : ",items)
//        let updateReceipt = [
//            "Uid":uid,
//            "Expired":Expired,
//            "Rank":1,
//            "Updated_At":Timestamp()
//        ] as [String : Any]
//        
//        let setHistory = [
//            "Uid":uid,
//            "Receipt":items,
//            "ProductID":ProductID,
//            "Created_At":Timestamp()
//        ]  as [String : Any]
//        
//        Firestore.firestore().collection("Receipt").document(uid).updateData(updateReceipt) { (Error) in
//            if let Error = Error {
//                print("Error",Error)
//                completion(false)
//                return
//            }
//            Firestore.firestore().collection("Receipt").document(uid).collection("History").document().setData(setHistory) { (Error) in
//                if let Error = Error {
//                    print("Error",Error)
//                    completion(false)
//                    return
//                }
//                completion(true)
//            }
//        }
//    }
//    //MARK:プレミアム会員が期限切れの時
//    static func PremiumExpired(ProductID:String,Expired:Date,completion: @escaping (Bool)->()){
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        
//       
//        let updateReceipt = [
//            "Uid":uid,
//            "Rank":0,
//            "Updated_At":Timestamp()
//        ] as [String : Any]
//        
//        Firestore.firestore().collection("Receipt").document(uid).updateData(updateReceipt) { (Error) in
//            if let Error = Error {
//                print("Error",Error)
//                completion(false)
//                return
//            }
//            completion(true)
//        }
//    }
//    //MARK:STAR購入した時
//    static func PurchaseStar(ProductID:String,PurchaseCount:Int,completion: @escaping (Bool)->()){
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let setHistory = [
//            "Uid":uid,
//            "ProductID":ProductID,
//            "PurchaseCount":PurchaseCount,
//            "Created_At":Timestamp()
//        ]  as [String : Any]
//        Firestore.firestore().collection("Receipt").document(uid).updateData([ "Uid":uid,"Updated_At":Timestamp()]) { (Error) in
//            if let Error = Error {
//                print("Error",Error)
//                completion(false)
//                return
//            }
//            Firestore.firestore().collection("Receipt").document(uid).collection("History").document().setData(setHistory) { (Error) in
//                if let Error = Error {
//                    print("Error",Error)
//                    completion(false)
//                    return
//                }
//                completion(true)
//            }
//        }
//    }
//    static func getSLfromFB(completion: @escaping ([Item])->()){
//        let semaphore = DispatchSemaphore(value: 0)
//        var data = [Item]()
//        let realmData = RealmModel()
//        var blocklist = [String]()
//        
//        for  data  in realmData.readBlockList() {
//            blocklist.append(data.UserUid)
//        }
//        guard let uid = Auth.auth().currentUser?.uid else {return}
//        //後でwhere文で検索
//        Firestore.firestore().collection("SuperLike").whereField("ToUid", isEqualTo: uid ).getDocuments { (snapshot, err) in
//            if let err = err {
//                print("UserListの取得に失敗しました。:",err)
//                completion([])
//            }
////            snapshot?.documents.forEach({ (snapshot1) in
//            guard let  documents = snapshot?.documents else { return }
//            for snapshot1 in  documents {
//                let  dic0 = snapshot1.data()
//                let matchCupleData = SuperLikeUser.init(dic: dic0)
//                
//                print("matchCupleData.FromUid : ",matchCupleData.FromUid)
//                
////                if realmData.searchBlock(uid: matchCupleData.FromUid) {
//                if !blocklist.contains(matchCupleData.FromUid) {
//                    Firestore.firestore().collection("User").document(matchCupleData.FromUid).getDocument { (snapshot2, err) in
//                        
//                        if let err = err {
//                            print("err:",err)
//                            return
//                        }
//                        
//                        let dic1 = snapshot2?.data()
//                        let user = UserData.init(dic: dic1 ?? ["null":0000])
//                        data.append(Item(image: UIImage(url: user.imageURL[0]),
//                                              rating: user.height,
//                                              title: user.name + " " + dateFormatter().judgeFormatter(date:matchCupleData.CreateAt.dateValue()),
//                                              subtitle: user.firtsTag + " " + user.activeArea,
//                                              description: matchCupleData.Message
//                        ))
//                        print("user から　Star GET")
//            
//                    }
//                }
//                semaphore.signal()
////            })
//            }
//            
//            semaphore.wait()
//            completion(data)
//        
//        }
//    }
//    
//    //MARK:Mailを持ってくる
//    static func getMailFromFB(QuerySnapshot:  @escaping (QuerySnapshot?,Error?)->()){
//        
//        
//        Firestore.firestore().collection("Mail").order(by: "CreatedAt", descending: true).getDocuments { snapShots, Error in
//            if let Error = Error {
//                print("Error:",Error)
//                QuerySnapshot(snapShots,Error)
//                return
//            }
//            QuerySnapshot(snapShots,Error)
//        }
//    }
//}
//extension Storage {
//    //MARK:Storageに変更後の画像を保存する。
//    static func registerImageToStorageAndGetURL(childName:String,userImage:UIImageView,completion:@escaping (String)->()){
//        
//        let image = userImage.image ?? UIImage(named: "good")
//        guard let uploadImage = image?.jpegData(compressionQuality: 0.7) else {return}
//        let fileName = NSUUID().uuidString
//        let storageRef = Storage.storage().reference().child(childName).child(fileName)
//        
//        storageRef.putData(uploadImage, metadata: nil) { (metadata, err) in
//            if let err = err {
//                print("err:",err)
//                completion("")
//                return
//            }
//            storageRef.downloadURL { (url, err) in
//                if let err = err {
//                    print("err:",err)
//                    completion("")
//                    return
//                }
//                guard let urlString = url?.absoluteString else {
//                    completion("")
//                    return
//                }
//                print("Storageに画像URLの取得に成功しました。")
//                completion(urlString)
//            }
//        }
//    }
//    //MARK:Storageに変更後の画像を保存する。
//    static func registerImageViewToStorageAndGetURL(childName:String,userImage:UIImage,completion:@escaping (String)->()){
//        
//        let image = userImage
//        guard let uploadImage = image.jpegData(compressionQuality: 0.7) else {return}
//        let fileName = NSUUID().uuidString
//        let storageRef = Storage.storage().reference().child(childName).child(fileName)
//        
//        storageRef.putData(uploadImage, metadata: nil) { (metadata, err) in
//            if let err = err {
//                print("err:",err)
//                completion("")
//                return
//            }
//            storageRef.downloadURL { (url, err) in
//                if let err = err {
//                    print("err:",err)
//                    completion("")
//                    return
//                }
//                guard let urlString = url?.absoluteString else {
//                    completion("")
//                    return
//                }
//                print("Storageに画像URLの取得に成功しました。")
//                completion(urlString)
//            }
//        }
//    }
//    //MARK:動画を保存する
//    static func registerMovieToStorageAndGetURL(childName:String,fileUrl: URL,completion:@escaping (String,String)->()) {
//
//        // Create file name
//     
//        let uid = NSUUID().uuidString
//        let fileExtension = fileUrl.pathExtension
//        let fileName = uid+".\(String(describing: fileExtension))"
//
//        let storageReference = Storage.storage().reference().child(childName).child(fileName)
//        storageReference.putFile(from: fileUrl , metadata: nil) { (storageMetaData, error) in
//          if let error = error {
//            print("Upload error: \(error.localizedDescription)")
//            completion("",Storage.errorMessage(of: error))
//            return
//          }
//                                                                                    
//          // Show UIAlertController here
//          print("Image file: \(fileName) is uploaded! View it at Firebase console!")
//                                                                                    
//          storageReference.downloadURL { (url, error) in
//            if let error = error {
//                print("error:",error.localizedDescription)
//                completion("",Storage.errorMessage(of: error))
//                return
//            }
//            guard let urlString = url?.absoluteString else {
//                completion("","Download_URL is faild")
//                return
//            }
//            print("Successful video upload")
//            completion(urlString,"success")
//          }
//        }
//    }
//    //MARK:Storageから変更前の画像(or動画)を削除する
//    static func deleteImageOrMovieFromStorageByURL(imageURL:String,completion:@escaping (Bool)->()){
//    
//        Storage.storage().reference(forURL: imageURL).delete { (err) in
//            if let err = err {
//                print("Storageの画像削除に失敗しました:",err)
//                completion(false)
//                return
//            }
//            completion(true)
//        }
//    }
//    //MARK:Storageから変更前の動画とサムネイル画像を削除する
//    static func deleteThumnailAndMovieFromStorage(thumnailURL:String,movieURL:String,completion:@escaping (Bool)->()){
//        Storage.deleteImageOrMovieFromStorageByURL(imageURL: thumnailURL) { thumnailResult in
//            if thumnailResult {
//                print("サムネの削除完了")
//                Storage.deleteImageOrMovieFromStorageByURL(imageURL: movieURL) { MovieResult in
//                    if MovieResult {
//                        print("動画の削除完了")
//                        completion(true)
//                    }else{
//                        print("動画の削除失敗")
//                        completion(false)
//                    }
//                }
//                
//            }else{
//                print("サムネの削除失敗")
//                completion(false)
//            }
//        }
//    }
//}
//
//
