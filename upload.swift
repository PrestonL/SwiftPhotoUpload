//  "SwiftPhotoUpload"
//  Created by Preston Ursini on 6/17/17.
//  Copyright © 2017 Preston Ursini, The Fire Horn, Inc.
//  See LICENSE file for information
//

import Foundation
import UIKit

func uploadImage() {
    
    //create an array of images
    var images = [UIImage]();

    //add an image to our array - never tried to upload an empty image object
    let image = UIImage();

    //append our blank image object to our array
    images.append(image);
    
    
    let reqURL = "https://example.com/image_upload";
    //The URL of the service you'll be posting to
    
    let session = URLSession.shared;
    //initialize the URLsession
    
    let fullURL = URL(string: reqURL);
    //Everything is an object in Swift, so initialize the URL object with the string above

    let request = NSMutableURLRequest(url: fullURL!);
    //Initialize the request with the URL object above

    request.httpMethod = "POST"
    //set the HTTP method of the request to POST
        
    let boundary = "Boundary-0VZ0U9809EFAWJ023RJIOJIF0Q0J32IDXK0OPR32IOJIG43T"
    //Set your HTTP boundary to something random - you can probably come up with a better random string than this

    let body = NSMutableData()
    //initialize the body object
        
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    //This will define the post data as being multipart and set the boundary - similar to email attachments
    
    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
    //go ahead and start your envelope
    
    //send the post value of POSTVALUE1_NAME as the value of the variable postValue1
    //rinse and repeat for multiple values
    let postValue1 = "Post value 1"
    body.append("Content-Disposition:form-data;name=\"POSTVALUE1_NAME\"\r\n\r\n".data(using: String.Encoding.utf8)!)
    body.append("\(postValue1.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)\r\n".data(using: String.Encoding.utf8)!)
    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        

    //the above could be done in an array like this - this will upload each image in the images array
    var i = 0
    for image in images {
        body.append("Content-Disposition:form-data; name=\"file\(i)\"; filename=\"image.png\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(UIImagePNGRepresentation(image)!)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        i += 1;
    }

    //assign the httpBody as being the data we just got done setting up with all our pictures and form data
    request.httpBody = body as Data
    

    //setup the task that will mean sending the
    let task = session.dataTask(with: request as URLRequest) {
        data, response, error in
        
        guard data != nil else {
            //do something in the event the server doesn't respond
            return
        }
        
        //get the response as a string - if you so wish
        let dataStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)

        //Throw the output here - remove any NSLogs before going into production though for security / performance reasons
        NSLog(dataStr! as String)

        //You should insert some tests here - maybe have your server give back some JSON for us to parse

        //since we aren't in the main thread, any calls to the UI should be done inside one of these
        DispatchQueue.main.async {
            //maybe show a message box or graphic if successful
        }
    }
    
    //send the images!
    task.resume()
}
