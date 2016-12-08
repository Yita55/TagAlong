
//
//  FirebaseManager.swift
//  FlatironMasterpiece
//
//  Created by Joyce Matos on 12/1/16.
//  Copyright © 2016 Elias Miller. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FBSDKLoginKit

typealias tagalongInfoDict = [String:Any]

final class FirebaseManager {

    static let shared = FirebaseManager()


    // Reference properties
    static let ref = FIRDatabase.database().reference().root
    static var chatRef: FIRDatabaseReference!
    static let allChatsRef = FIRDatabase.database().reference().child("chats")
    static var newMessageRefHandle: FIRDatabaseHandle?
    static var newTagalongRefHandle: FIRDatabaseHandle?
    static var currentUser = FIRAuth.auth()?.currentUser?.uid
    static var currentUserEmail = FIRAuth.auth()?.currentUser?.email


    // Tagalongs that populate tagalong tableview
    var tagalongs = [Tagalong]()

    //Tagalong ID from selected Tagalong
    var selectedTagAlongID: String? //"in9xyf2doNghFp2cBlecJB3M4mf1"       // TODO: Remove this. Using it to test.
    //User ID from guest requesting tagalong
    var guestID: String? //"lgIUzQSOU0O5nBS9VvVy9WRIGsf1"           // TODO: Remove this. Using it to test.

    var guestStatus = [String: Bool]()


    private init() {}







//    static func upload(image: UIImage, handler: (Bool) -> Void) {
//
//        // upload to firebase
//
//        // when done.
//
//
//
//
//    }

    //MARK: - Firebase user methods
    //this function is called in AccountCreationViewController, createAccountButton()
    static func createNewUser(currentUser: User, completion: @escaping (Bool) -> Void) {
        // 1 - create a new user in Firebase
        FIRAuth.auth()?.createUser(withEmail: currentUser.emailAddress, password: currentUser.passWord, completion: { (user, error) in

            guard error == nil, let rawUser = user else { completion(false); return }
            //2 - save the new user in Firebase
           let storageRef = FIRStorage.storage().reference()
 //           let uploadData = UIImagePNGRepresentation(picImage)
  //          storageRef.put(<#T##uploadData: Data##Data#>, metadata: <#T##FIRStorageMetadata?#>, completion: <#T##((FIRStorageMetadata?, Error?) -> Void)?##((FIRStorageMetadata?, Error?) -> Void)?##(FIRStorageMetadata?, Error?) -> Void#>)

            self.ref.child("users").child(rawUser.uid).setValue(currentUser.serialize(), withCompletionBlock: { error, ref in

                guard error == nil else { completion(false); return }

                completion(true)

            })
        })
    }

    static func storeImage(image: UIImage) {
        let ref = FIRStorage.storage().reference()
        let imageData = UIImagePNGRepresentation(image)
        let metaData = FIRStorageMetadata()
     //   ref.put(imageData, metadata: <#T##FIRStorageMetadata?#>, completion: <#T##((FIRStorageMetadata?, Error?) -> Void)?##((FIRStorageMetadata?, Error?) -> Void)?##(FIRStorageMetadata?, Error?) -> Void#>)
    }

    //    func savePreferences() {
    //        // Send to shake instruction view controller
    //        let user = FIRAuth.auth()?.currentUser
    //        guard let unwrappedUser = user else { return }
    //        print(unwrappedUser)
    //        if   FIRAuth.auth()?.currentUser != nil {
    //
    //        }
    //        print("Save preferences tapped")
    //        print(store.preferredCuisineArray)
    //        let shakeInstructionVC = ShakeInstructionViewController()
    //        self.navigationController?.pushViewController(shakeInstructionVC, animated: true)
    //
    //    }
    //    func savePreferencesToFirebase() {
    //        if FIRAuth.auth()?.currentUser?.uid != nil {
    //       //     let unique = FIRAuth.auth()?.currentUser?.uid
    //        //    FIRDatabase.database().reference().child("users").child(unique).observeSingleEvent(of: .value, with: { (snapshot) in
    //
    //            })
    //        }
    //    }
   /* static func blockUser(user: String) {
        if FIRAuth.auth()?.currentUser?.uid != nil {
          let unique = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("blockedUsers").child(unique).child
        }
    }
 */

    class func savePref(dictionary: [String: Any]) {
        print(dictionary)
        if FIRAuth.auth()?.currentUser?.uid != nil {
            let unique = FIRAuth.auth()?.currentUser?.uid
            print(unique!)
            //    FIRDatabase.database().reference().setValuesForKeys(dictionary)
            FIRDatabase.database().reference().child("users").child(unique!).child("preferences").updateChildValues(dictionary)

        }
    }

    //this method gets preferences from firebase

    class func getPreferences() {
        //work with ELI to get the cuisines from Firebase
    }

    static func sendEmailVerification() {

        FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: { (error) in
            if error == nil {
                print("Email sent")
            }
            else {
                print(error?.localizedDescription)
            }
        })
    }

    static func listenForLogIn() {
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.
                // Move to next screen
                // Add logout button to user's settings screen
            } else {
                // No user is signed in.
                // Display log in screen
                // createViews()
            }
        }

    }

    static func loginToFirebase(email: String, password: String, completion: @escaping (Bool)-> Void) {

        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in

            guard error == nil else { completion(false); return }

            completion(true)
        })
    }

    static func sendPasswordReset(email: String, completion: @escaping (Bool) -> Void) {

        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
            guard error == nil else { completion(false); return }
            completion(true)

        })

    }

    //MARK: - Firebase Facebook Methods
    static func facebookLogIn(completion: @escaping (Bool) -> Void) {

        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        print("credential is \(credential)")

        if let token = FBSDKAccessToken.current() {
            print("ALL good")
            if let tokenString = token.tokenString {
                if let token = FBSDKAccessToken.current() {
                    print("ALL good")
                    if let tokenString = token.tokenString {
                        print("Token string is here \(tokenString)")
                    }
                }
            }

            FIRAuth.auth()?.signIn(with: credential) { (user, error) in

                print("User has logged into Firebase")
                guard error == nil else { completion(false); return }
                completion(true)
            }

            print("User has logged in")
            print("=====================================================\n\n\n")

        }
    }


    //MARK: - Firebase chat methods

    //1 - call this when a tagalong is created (restaurant card review) and
    static func createTagAlong(with tagAlongInfo: tagalongInfoDict, completion:@escaping (String)-> Void) {

        // Outline of what the code should look like:
        let tagAlongsRef = FIRDatabase.database().reference().child("tagalongs")

        //this is created when BOTH users in a tagalong have confirmed being in a tagalong
        //        let tagAlongInfo = [
        //            "host" : "UserID", <-- should be collected when host confirms
        //            "location" : [     <-- should be collected from host
        //                "name" : "taco bell", <-- should be collected from host / restaurant conf card
        //                "latitude" : "30",
        //                "longitude" : "30"
        //            ],
        //            "guests" : [   <-- should be collected when guest confirms, these are people who have clicked to initiate a tagalong w/ or w/o host confirmation
        //                "UserID3" : true, <-- when this is true then create this dictionary and this createTagAlong() should be called
        //                "UserID2" : false,
        //                "UserID3" : false
        //            ],
        //            "date-time" : "figure out formatting here"
        //        ] as [String : Any]

        // Tagalong ID
        let tagAlongIDRef = tagAlongsRef.childByAutoId()

        // Tagalong Key
        let tagAlongIDKey = tagAlongIDRef.key

        // Add Tagalong dictionary to Tagalong ID
        tagAlongIDRef.updateChildValues(tagAlongInfo)
        print("hey there")
        completion(tagAlongIDKey)
        print(tagAlongIDKey)
        print("after completion")

    }

    //2 - update user with tagalong id
    static func updateUserWithTagAlongKey(key: String) {

        // Add tagalong key to users
        // 1. Create tagalongs
        if FIRAuth.auth()?.currentUser?.uid != nil {
            guard let currentUser = currentUser else { return }
            ref.child("users").child(currentUser).child("tagalongs").updateChildValues([key: true])
        }

        // 2. Create current tagalongs
        if FIRAuth.auth()?.currentUser?.uid != nil {
            guard let currentUser = currentUser else { return }
            ref.child("users").child(currentUser).child("currentTagalongs").setValue([key: true])
        }

    }

    ///this gets called in searchingForTagAlongVC (acceptTagalong())
    func updateGuestWithTagAlongKey(tagAlongkey: String) {

        guard let unwrappedGuestID = guestID else { return }

        FirebaseManager.ref.child("users").child(unwrappedGuestID).child("tagalongs").updateChildValues([tagAlongkey: true])

        FirebaseManager.ref.child("users").child(unwrappedGuestID).child("currentTagalongs").setValue([tagAlongkey: true])

    }


    static func createUserFrom(tagalong: String, completion:@escaping (User)->()){

        FirebaseManager.ref.child("tagalongs").child(tagalong).child("user").observeSingleEvent(of: .value, with: { (snapshot) in
            let userName = snapshot.value as! String

            // This will need to be replaced with the userID
            FirebaseManager.ref.child("users").child(userName).observe(.value, with: { (snapshot) in
                let userInfo = snapshot.value as! [String: Any]
                let user = User(snapshot: userInfo)


                print("=-=-=-=-=-=-= \(userInfo)-=-=-=-=-=-=-=-=")
                //self.newtagalongUserArray.append(user)
                completion(user)

            })
        })
    }



    //MARK: - Tagalong Message Methods

    static func createChatWithTagID(key: String) {

        //Create chat with tagalong key
        self.chatRef = allChatsRef.child("\(key)")
        
        
        //Create chat with tagalongID from user's node
        
//        guard let userID = currentUser else { return }
//       let tagalongID = FirebaseManager.ref.child("users").child(userID).child("currentTagalongs").key
//        self.chatRef = allChatsRef.child("\(tagalongID)")

    }


    static func observeTagalongs(completion: @escaping (String) -> Void) {

        newTagalongRefHandle = ref.child("tagalongs").observe(.childAdded, with: { (snapshot) -> Void in

            print("--------------------GETTING CALLED------------------")


            print("tagalongQuery snapshot: \(snapshot.value)")
            print("tagalongKey: \(snapshot.key)")

            if let tagalongKey = snapshot.key as? String,
                let tagalongValue = snapshot.value as? [String: Any] {

                completion(tagalongKey)

            } else {
                print("Error! Could not decode message data")
            }

            print("----------------------------------------------\n\n\n")
        })
    }

    // Request a tagalong
    static func requestTagAlong(key: String) {

        guard let currentUser = currentUser else { return }
        ref.child("tagalongs").child("\(key)").child("guests").updateChildValues([currentUser : false])

    }

    func observeTagalongRequests(response: @escaping (FIRDataSnapshot?) -> Void) {

//        selectedTagAlongID = "-KYJz-QJjY4XHOe5qj3C" // TODO: Remove this. Using it to test.

//        guard let theSelectedTagAlongID = selectedTagAlongID else { response(nil); return }

        guard let currentUser = FirebaseManager.currentUser else { print("hey coming out as nil");return}
        FirebaseManager.ref.child("users").child("\(currentUser)").child("currentTagalongs").observe(.childAdded, with: { (snapshot) in
            let currentTagalong = snapshot.key
            print("Current Tagalong -> \(currentTagalong)")
            FirebaseManager.ref.child("tagalongs").child("\(currentTagalong)").child("guests").observe(.childAdded, with: { snapshot in

                DispatchQueue.main.async {

                    response(snapshot)
                }

            })


        })



    }


    func createGuestFrom(tagalong: String, completion:@escaping (User)->()){
        var userName = guestID
//
        FirebaseManager.ref.child("tagalongs").child(tagalong).child("guests").observe(.value, with: { (snapshot) in
            userName = snapshot.key as! String

            // This will need to be replaced with the userID
            FirebaseManager.ref.child("users").child("\(userName)").observe(.value, with: { (snapshot) in
                let userInfo = snapshot.value as! [String: Any]
                let user = User(snapshot: userInfo)


                print("=-=-=-=-=-=-= \(userInfo)-=-=-=-=-=-=-=-=")
                //self.newtagalongUserArray.append(user)
                completion(user)

            })
        })
    }

    func acceptTagalong(guestID: String, completion: @escaping (String)-> Void) {
        //get my own tag along id


        guard let currentUser = FirebaseManager.currentUser else { print("hey coming out as nil");return}
        FirebaseManager.ref.child("users").child("\(currentUser)").child("currentTagalongs").observe(.childAdded, with: { (snapshot) in
            let currentTagalong = snapshot.key
            print("Current Tagalong -> \(currentTagalong)")
            FirebaseManager.ref.child("tagalongs").child("\(currentTagalong)").child("guests").updateChildValues([guestID : true])
            completion(currentTagalong)
        })

    }

    func denyTagalong(guestID: String) {

        guard let currentUser = FirebaseManager.currentUser else { print("hey coming out as nil");return}
        FirebaseManager.ref.child("users").child("\(currentUser)").child("currentTagalongs").observe(.childAdded, with: { (snapshot) in
            let currentTagalong = snapshot.key
            print("Current Tagalong -> \(currentTagalong)")


            FirebaseManager.ref.child("tagalongs").child("\(currentTagalong)").child("guests").updateChildValues([guestID : "none"])

        })


    }

    func observeGuestTagalongStatus(completion: @escaping (FIRDataSnapshot?) -> Void) {

        guard let guestID = FirebaseManager.currentUser else { print("hey retuning");return }
        guard let selectedTag = selectedTagAlongID else { print("selected tag along is nil");return}

        print("firebase manager observe guest tagalong - selected tag: \(selectedTag)")
        
        FirebaseManager.ref.child("tagalongs").child("\(selectedTag)").child("guests").child("\(guestID)").observe(.value, with: { (snapshot) in
            completion(snapshot)

        })
    }


    static func sendMessage(senderId:String, senderDisplayName: String, text: String, date: Date, messageCount: Int) {

        print("\n\nFirebaseManager sendMessage:\nsenderId: \(senderId)\nsenderDisplayName: \(senderDisplayName)\ntext: \(text)\ndate: \(date)\nself.messages.count: \(messageCount)\n\n")

        let messageItem = [ // 2
            "senderId": senderId,
            "senderName": senderDisplayName,
            "text": text,
            "timestamp": String(Int(Date().timeIntervalSince1970))
        ]

        print("\n\nFirebaseManager sendMessage:\nchatRef: \(self.chatRef)\n\n")

        self.chatRef.updateChildValues(["\(messageCount)": messageItem])

    }

    static func observeMessages(completion: @escaping (String, String, String) -> Void) {


        // 1. Creating a query that limits the synchronization to the last 25 messages
        //        let messageQuery = chatRef.queryLimited(toLast:25)

        // 2. Observe every child item that has been added, and will be added, at the messages location.
        newMessageRefHandle = chatRef.observe(.childAdded, with: { (snapshot) -> Void in

            print("--------------------GETTING CALLED------------------")

            // 3. Extract the messageData from the snapshot

            print("messageQuery snapshot: \(snapshot.value)")
            let messageData = snapshot.value as! [String: Any]

            if let id = messageData["senderId"] as? String,
                let name = messageData["senderName"] as? String,
                let text = messageData["text"] as? String,
                text.characters.count > 0 {

                completion(id, name, text)

            } else {
                print("Error! Could not decode message data")
            }

            print("----------------------------------------------\n\n\n")
        })
    }



}
