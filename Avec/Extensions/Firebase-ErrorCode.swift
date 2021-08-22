////
////  Firebase-ErrorCode.swift
////  BallRoomMP
////
////  Created by 清水正明 on 2021/05/03.
////
//
//
//import FirebaseAuth
//import FirebaseFirestore
//import FirebaseStorage
//
////      case .: message = ""
//
//extension Auth {
//    
//    static func errorMessage(of error: Error) -> String {
//       var message = " エラーが起きました。 \nしばらくしてから再度お試しください。"
//       guard let errcd = AuthErrorCode(rawValue: (error as NSError).code) else {
//           return message
//       }
//
//       switch errcd {
//       //全部共通
//       case .networkError: message = "ネットワークに接続できません"
//       case .userNotFound: message = "ユーザが見つかりません"
//       case .tooManyRequests: message = " サーバーに異常な数のリクエストが行われました。\nしばらくしてから再度お試しください。"
//
//
//       case .invalidEmail: message = "不正なメールアドレスです"
//       case .invalidPhoneNumber:message = "無効な電話番号です"
//       case .userDisabled: message = "このアカウントは凍結されました"
//       case .wrongPassword: message = "入力した認証情報でサインインできません"
//       case .missingPhoneNumber: message = "電話番号が正しくありません"
//       case .emailAlreadyInUse: message = "このメールアドレスは既に使われています"
//
//
//       case .weakPassword: message = "パスワードが脆弱すぎます"
//       case .appNotVerified: message = "電話認証を許可していません"
//       case .invalidVerificationID: message = "確認コードが違います"
//       case .invalidVerificationCode: message = "確認コードが違います"
//       case .missingVerificationID: message = "空の確認コードが生成されました"
//       case .missingVerificationCode: message = "空の確認コードが生成されました"
//
//       // これは一例です。必要に応じて増減させてください
//       default: break
//       }
//       return message
//   }
//
//}
//extension Firestore {
//    static func errorMessage(of error: Error) -> String {
//        var message = " エラーが起きました。 \nしばらくしてから再度お試しください。"
//        guard let errcd = FirestoreErrorCode(rawValue: (error as NSError).code) else {
//            return message
//        }
//        switch errcd {
//        //全部共通
//        case .OK :message = "The Firestore operation completed successfully"
//        case .cancelled: message = "読み込みをキャンセルしました"
//        case .notFound: message = "データが見つかりませんでした"
//        case .invalidArgument :message = "データアップデートが無効になりました"
//        case .deadlineExceeded:message = "タイムアウトしました"
//        case .alreadyExists:message = "すでにデータを受け取り済みです"
//        case .permissionDenied:message = "権限を持っていません"
//        // その他は割愛
//        default: break
//        }
//        return message
//    }
//}
//extension Storage {
//    static func errorMessage(of error: Error) -> String {
//        var message = " エラーが起きました。 \nしばらくしてから再度お試しください。"
//        guard let errcd = StorageErrorCode(rawValue: (error as NSError).code) else {
//            return message
//        }
//        switch errcd {
//        //全部共通
//        case .objectNotFound: message = "画像または動画は存在しません"
//        case .bucketNotFound: message = "サーバーが見つかりませんでした"
//        case .projectNotFound: message = "サーバーが見つかりませんでした"
//        case .cancelled: message = "読み込みをキャンセルしました"
//        case .unauthenticated: message = "ログインしてください"
//        case .unauthorized: message = "ユーザー権限がありません"
//        case .retryLimitExceeded: message = "タイムアウトしました"
//        case .nonMatchingChecksum: message = "もう一度アップロードしてください"
//        case .downloadSizeExceeded: message = "データが大きすぎます、もう一度アップロードしてください"
//        case .invalidArgument :message = "データアップデートが無効になりました"
//
//        // その他は割愛
//        default: break
//        }
//        return message
//    }
//}
//
////MARK:エラーを出す例
////func showErrorIfNeeded(_ errorOrNil: Error?) {
////    // エラーがなければ何もしません
////    guard let error = errorOrNil else { return }
////    let message = Auth.errorMessage(of: error) // エラーメッセージを取得
////    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
////    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
////    present(alert, animated: true, completion: nil)
////}
//
